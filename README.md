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

<br/>

# 프로젝트 구조
## File Tree
```typescript!
├── .swiftlint.yml
├── Extension
│   └── Date+.swift
├── Model
│   ├── AlertManager.swift
│   ├── Contents.swift
│   ├── DecodeManager.swift
│   └── DiaryError.swift
├── View
│   ├── ContentsTableViewCell.swift
│   └── IdentifierType.swift
├── Controller
│   ├── DiaryDetailViewController.swift
│   └── DiaryListViewController.swift
├── Resources
│   ├── Assets.xcassets
│   └── Info.plist
└── Application
    ├── AppDelegate.swift
    └── SceneDelegate.swift
```

# 실행 화면

|<center>초기화면<br>일기장 목록<br></center>|<center>일기장 등록 페이지</center>|<center>셀 클릭 시<br>일기장 수정 페이지로 이동</center> |<center>가로모드 지원</center>|
| -- | -- | -- | -- |
|<img src="https://i.imgur.com/rQklltq.gif" width=250> | <img src="https://i.imgur.com/USRIrfI.gif" width=250> | <img src="https://i.imgur.com/Yobrjbc.gif" width=250> | <img src="https://i.imgur.com/l9koVPD.gif" width=250> |

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
    ...    
    view.keyboardLayoutGuide.followsUndockedKeyboard = true
        
    NSLayoutConstraint.activate([
        view.keyboardLayoutGuide.topAnchor.constraint(equalTo: textView.bottomAnchor),
        
        ...           
            
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

# 참고 링크
## 블로그
- [WWDC 21 분석: Adjust Your Layout with Keyboard Layout Guide](https://zeddios.tistory.com/1282)

## 공식 문서

- [UITextView](https://developer.apple.com/documentation/uikit/uitextview)
- [DateFormatter](https://developer.apple.com/documentation/foundation/dateformatter)
- [preferredLanguages](https://developer.apple.com/documentation/foundation/nslocale/1415614-preferredlanguages)
- [Adjusting Your Layout with Keyboard Layout Guide](https://developer.apple.com/documentation/uikit/keyboards_and_input/adjusting_your_layout_with_keyboard_layout_guide)
- [keyboardLayoutGuide](https://developer.apple.com/documentation/uikit/uiview/3752221-keyboardlayoutguide)
