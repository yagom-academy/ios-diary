# 📔 일기장
> 나의 일기를 등록, 수정, 삭제할 수 있는 앱
> 
> 프로젝트 기간: 2023.04.24-2023.05.12
> 

## 팀원
| kokkilE | 혜모리 |
| :--------: |  :--------: | 
| <Img src ="https://i.imgur.com/4I8bNFT.png" width="200" height="200"/>      |<Img src ="https://i.imgur.com/VJtnO5j.png" width="200" height="200"/>
| [Github Profile](https://github.com/kokkilE) |[Github Profile](https://github.com/hyemory)

## 목차
1. [타임라인](#타임라인)
2. [프로젝트 구조](#프로젝트-구조)
3. [실행 화면](#실행-화면)
4. [트러블 슈팅](#트러블-슈팅) 
5. [참고 링크](#참고-링크)


# 타임라인 

|날짜|내용|
|:-----:| ------ |
| 2023.04.24 | - JSON Decode 모델인 Contents 타입 구현 <br>- 일기 리스트 화면 구현 <br> - custom TableviewCell 구현 <br>- SwiftLint 적용|
| 2023.04.25 | - 날짜 지역화 구현 <br>- 상세페이지 화면 구현 <br> - KeyBoard에 따른 뷰 위치 변경 구현|
| 2023.04.26 | - DecodeManager 구현<br>- AlertManager 구현 <br>- keyboardLayoutGuide 적용 <br>- 프로젝트 Minimum DeployMents 변경 (14.0 → 15.0) |
| 2023.04.28 | - CoreDataManager - Create, Read 기능 구현<br>- Coredata의 Entity 구현 |
| 2023.05.01 | - Core Data Update, Delete 구현을 위한 추가 학습 |
| 2023.05.02 | - CoreDataManager - Update, Delete 기능 구현<br>- VC의 데이터 CRUD 기능 구현 |
| 2023.05.03 | - 에러 Alert 기능 구현 <br> - 데이터가 편집될 때 전체 데이터가 아닌 편집된 데이터만 reload 하도록 기능 수정 |
| 2023.05.04 | - 에러 처리 위치 수정 (model → VC)|

<br/>

# 프로젝트 구조
## File Tree

<details>
<summary> 파일 트리 보기 (클릭) </summary>
<div markdown="1">

```typescript!
├── .swiftlint.yml
├── CoreData
│   ├── ContentsEntity+CoreDataClass.swift
│   ├── ContentsEntity+CoreDataProperties.swift
│   ├── CoreDataManager.swift
│   └── Diary.xcdatamodeld
│       └── Diary.xcdatamodel
│           └── contents
├── Error
│   └── DiaryError.swift
├── Extension
│   └── Date+.swift
├── Protocol
│   └── DiaryDetailViewControllerDelegate.swift
├── Utility
│   ├── AlertManager.swift
│   └── DecodeManager.swift
├── View
│   ├── ContentsTableViewCell.swift
│   └── IdentifierType.swift
├── Model
│   └── Contents.swift
├── Controller
│   ├── DiaryDetailViewController.swift
│   └── DiaryListViewController.swift
├── Resources
│   ├── Assets.xcassets
│   │   ├── AccentColor.colorset
│   │   │   └── Contents.json
│   │   ├── AppIcon.appiconset
│   │   │   └── Contents.json
│   │   ├── Contents.json
│   │   └── sample.dataset
│   │       ├── Contents.json
│   │       └── sample.json
│   ├── Base.lproj
│   │   └── LaunchScreen.storyboard
│   └── Info.plist
└── Application
    ├── AppDelegate.swift
    └── SceneDelegate.swift
```
    
</div>
</details>

# 실행 화면

### Step 1

<details>
<summary> Step1 실행화면 보기 (클릭) </summary>
<div markdown="1">
    
|<center>초기화면<br>일기 목록<br></center>|<center>+버튼 클릭 시<br> 일기 상세 화면 이동 (create)</center>|<center>셀 클릭 시<br>일기 상세 화면 이동 (update)</center> |<center>가로모드 지원</center>|
| -- | -- | -- | -- |
|<img src="https://i.imgur.com/rQklltq.gif" width=250> | <img src="https://i.imgur.com/USRIrfI.gif" width=250> | <img src="https://i.imgur.com/Yobrjbc.gif" width=250> | <img src="https://i.imgur.com/l9koVPD.gif" width=250> |

</div>
</details>
    
### Step 2
|<center>앱 실행 시<br>저장된 데이터 로드</center>|<center>데이터 로드 실패 시<br>알림 표시</center>|<center>일기 목록 화면<br>스와이프로 공유</center>|<center>일기 목록 화면<br>스와이프로 삭제</center>|
|--| -- | -- | -- |
|<img src="https://i.imgur.com/xqQftkN.gif" width=250> | <img src="https://i.imgur.com/kWbnD8y.gif" width=250> | <img src="https://i.imgur.com/ScKxczX.gif" width=250> | <img src="https://i.imgur.com/6vbOfR4.gif" width=250> |

|<center>일기 상세 화면<br>일기 자동 저장</center> |<center>일기 상세 화면<br>더보기 버튼 클릭 시<br>공유, 삭제 선택</center>|<center>일기 상세 화면<br>더보기 → 공유</center> |<center>일기 상세 화면<br>더보기 → 삭제</center>|
| -- | -- | -- | -- |
|<img src="https://i.imgur.com/EtKZ99W.gif" width=250> | <img src="https://i.imgur.com/dYIi5Jh.gif" width=250> | <img src="https://i.imgur.com/xU7RDNA.gif" width=250> | <img src="https://i.imgur.com/AeedOOy.gif" width=250> |

# 트러블 슈팅

## 1️⃣ 키보드가 편집중인 텍스트를 가리지 않도록 처리
키보드가 나타날 때 편집중인 텍스트를 가리지 않도록 하기 위해 세 가지 방법을 찾아 고려하였습니다.

- 키보드가 나타날 때 textView의 오토레이아웃을 조정하여 구현
- 키보드가 나타날 때 textView.contentInset을 조정하여 구현
- **keyboardLayoutGuide의 제약으로 구현**

위의 첫 번째, 두 번째 방법은 Notification을 활용하여 키보드 이벤트를 수신하는 방법으로 구현이 가능했습니다.
다만 첫 번째 방법인 오토레이아웃을 변경하는 방법으로 구현할 경우, 다음과 같이 딜레이 시간동안 키보드가 내려감에도 채워지지 않는 레이아웃이 어색하게 느껴졌습니다.

<br/>
<img src= "https://i.imgur.com/L3u84Y7.gif" width=250>
<br/>

두 번째 방법과 세 번째 방법은 동작상의 문제는 없다고 생각했습니다. 세 번째 방법은 keyboardLayoutGuide의 제약조건으로 비교적 간단히 구현이 가능해 세 번째 방법을 채택하였습니다.
다만 keyboardLayoutGuide을 사용하기 위해 Minimum Deployments를 iOS 15.0으로 올려야 했습니다.

### 📄 코드 참조

#### 키보드가 나타날 때 textView의 오토레이아웃을 조정하여 구현

``` swift
@objc func keyboardWillShow(notification: Notification) {
    guard let userInfo = notification.userInfo,
          let keyboardFrameValue = userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue else {
        return
    }
    let keyboardHeight = keyboardFrameValue.cgRectValue.height
    
    textViewBottomAnchor.isActive = false
    
    // 키보드가 나타날 경우 textView의 bottomAnchor 조정
    textViewBottomAnchor = textView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -keyboardHeight)

    textViewBottomAnchor.isActive = true
    }
```

#### 키보드가 나타날 때 textView.contentInset을 조정하여 구현

``` swift
@objc private func keyboardWillShow(notification: Notification) {
    guard let userInfo = notification.userInfo,
          let keyboardFrameValue = userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue else {
        return
    }
    let keyboardHeight = keyboardFrameValue.cgRectValue.height
        
    textView.contentInset.bottom = keyboardHeight
    textView.verticalScrollIndicatorInsets.bottom = keyboardHeight
    }
```

#### ✅ keyboardLayoutGuide의 제약으로 구현
``` swift
private func configureLayout() {
    //...    
    view.keyboardLayoutGuide.followsUndockedKeyboard = true
        
    NSLayoutConstraint.activate([
        view.keyboardLayoutGuide.topAnchor.constraint(equalTo: textView.bottomAnchor),
        
        //...           
            
        textView.bottomAnchor.constraint(equalTo: view.keyboardLayoutGuide.topAnchor)
        ])
    }
```

## 2️⃣ 일기장 내용이 전부 보이도록 수정
     
### 🔍 문제점

가장 긴 글의 수정 페이지로 이동했을 때 위로 스크롤하지 않으면 제목 부분이 잘려보이는 현상이 확인됐습니다.

<img src= "https://i.imgur.com/6GIrrZx.gif" width=250>

### ⚒️ 해결방안

`contentSize`가 텍스트 내용보다 작아 발생한 현상으로,
하이어라키를 설정할 때 뷰의 offset의 크기를 초기화시켜주니 정상적으로 표시되었습니다.

``` swift
private func configureLayout() {
    view.addSubview(textView)
    textView.contentOffset = .zero // 추가
    
    // 이하 layout 설정
}
```

## 3️⃣ 예외 처리 정리
     
### 🔍 문제점

기능 구현 중 스텝 요구사항 외에 어색하다고 생각되는 로직이 여러가지 있었습니다.
이 내용들은 예외적으로 처리가 필요하다고 생각하여 관련 정책을 자체적으로 협의하여 결정했습니다.

### ⚒️ 결과

1. 새 글을 create할 때 아무 내용도 입력하지 않은 경우
 → 저장되지 않습니다.
3. 새 글을 create하고 + 자동 저장된 후 글 내용을 전부 삭제한 경우
 → 비어있는 내용이 저장됩니다.
5. 글을 한 줄만 등록한 경우 (title만)
 → title은 입력한 내용이 저장되고 body는 빈 문자열로 저장됩니다.
7. 이미 등록된 글의 내용을 전부 지운 경우 update 여부
 → 비어있는 내용이 저장됩니다.
9. 새 글을 create할 때 더보기 버튼(right bar button) 노출 여부
 → 입력 후 내용을 바로 공유하거나, 자동저장된 내용을 바로 삭제시킬 수 있다고 생각하기 때문에 새 글을 저장할 때도 버튼이 노출됩니다.

## 4️⃣ 목록 화면과 상세 화면간 데이터 동기화

상세 화면에서 편집된 데이터를 목록 화면에도 반영하기 위한 로직을 구현하였습니다.
개선 전에는 목록 화면으로 돌아올 때 전체 데이터를 다시 읽고, 목록을 reload하는 방법으로 구현하였습니다.
개선 후에는 편집된 데이터만 갱신되도록 구현하였습니다.

### 🔍 문제점
상세 화면에서 데이터가 편집된 후 다시 목록 화면으로 돌아올 때, 편집된 데이터를 목록 화면에 반영하기 위해 `DiaryDetailViewController`에서는 데이터가 편집될 때 CoreData 저장소의 데이터를 변경해주었습니다. 이후 목록 화면이 다시 나타날 때 아래와 같은 코드로 데이터를 갱신하였습니다.

**DiaryListViewController**
``` swift
override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    
    fetchContents()
    tableView.reloadData()
}
```


위 코드는 동작에 문제는 없었지만, 하나의 데이터만 편집되는 상황에서 전체 데이터를 다시 읽어오고, reload하기 때문에 오버헤드가 발생합니다.
데이터가 많아질수록 오버헤드는 커지기 때문에 개선할 필요가 있다고 생각하였습니다.

### ⚒️ 해결방안
상세 화면에서 편집된 데이터만 목록 화면에서 갱신할 수 있도록 delegate 패턴을 적용하여 다음과 같이 코드를 개선하였습니다.

**DiaryListViewController**
``` swift
// MARK: - DiaryDetailViewController Delegate
extension DiaryListViewController: DiaryDetailViewControllerDelegate {
    func createCell(contents: Contents) {
        // ...
        contentsList?.append(contents)
        tableView.insertRows(at: [selectedCellIndex], with: .automatic)
    }
    
    func updateCell(contents: Contents) {
        // ...
        contentsList?[selectedCellIndex.row] = contents
        tableView.reloadRows(at: [selectedCellIndex], with: .automatic)
    }
    
    func deleteCell() {
        // ...
        contentsList?.remove(at: selectedCellIndex.row)
        tableView.deleteRows(at: [selectedCellIndex], with: .fade)
    }
}
```

**DiaryDetailViewController**
``` swift
	// ...
	weak var delegate: DiaryDetailViewControllerDelegate?
	// ...
	private func updateContents() {
	    // ...
	    delegate?.updateCell(contents: contents)
	    // ...
	}
	    
	private func createContents() {
	    // ...
	    delegate?.createCell(contents: contents)
	    // ...
	}
	        
	private func deleteContents() {
	    // ...
	    delegate?.deleteCell()
	    // ...
	}
```


# 참고 링크
## 블로그
- [WWDC 21 분석: Adjust Your Layout with Keyboard Layout Guide](https://zeddios.tistory.com/1282)

## 공식 문서

- [UITextView](https://developer.apple.com/documentation/uikit/uitextview)
- [DateFormatter](https://developer.apple.com/documentation/foundation/dateformatter)
- [preferredLanguages](https://developer.apple.com/documentation/foundation/nslocale/1415614-preferredlanguages)
- [Adjusting Your Layout with Keyboard Layout Guide](https://developer.apple.com/documentation/uikit/keyboards_and_input/adjusting_your_layout_with_keyboard_layout_guide)
- [keyboardLayoutGuide](https://developer.apple.com/documentation/uikit/uiview/3752221-keyboardlayoutguide)
- [followsUndockedKeyboard](https://developer.apple.com/documentation/uikit/uikeyboardlayoutguide/3752189-followsundockedkeyboard)
- [textViewDidEndEditing(_:)](https://developer.apple.com/documentation/uikit/uitextviewdelegate/1618628-textviewdidendediting)
- [didEnterBackgroundNotification](https://developer.apple.com/documentation/uikit/uiapplication/1623071-didenterbackgroundnotification)
- [willDeactivateNotification](https://developer.apple.com/documentation/uikit/uiscene/3197924-willdeactivatenotification)
- [description](https://developer.apple.com/documentation/swift/customstringconvertible/description)
- [init(context:)](https://developer.apple.com/documentation/coredata/nsmanagedobject/1640602-init)
- [UIActivityViewController](https://developer.apple.com/documentation/uikit/uiactivityviewcontroller)
    - [init(activityItems:applicationActivities:)](https://developer.apple.com/documentation/uikit/uiactivityviewcontroller/1622019-init)
