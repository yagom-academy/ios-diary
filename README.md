# 일기장

## 📖 목차

1. [소개](#-소개)
2. [프로젝트 구조](#-프로젝트-구조)
3. [구현 내용](#-구현-내용)
4. [타임라인](#-타임라인)
5. [실행 화면](#-실행-화면)
6. [트러블 슈팅 & 고민했던 점](#-트러블-슈팅--고민했던-점)
7. [참고 링크](#-참고-링크)

## 😁 소개

[애런](https://github.com/hashswim), [로빈](https://github.com/yuvinrho), [건디](https://github.com/Gundy93)의 일기장 프로젝트 앱입니다.

- KeyWords
    - Localization
    - Date Formatter
    - Text View
    - Attributed String
    - Table View
    - Core Data
    - UISwipeActionsConfiguration

## 🛠 프로젝트 구조

## 📊 UML
> ![](https://i.imgur.com/NMvP1Vd.png)


## 🌲 Tree
```
Diary
├── App
│   ├── AppDelegate.swift
│   └── SceneDelegate.swift
├── Controller
│   ├── DiaryListViewController.swif
│   └── DiaryViewController.swift
├── CoreData
│   ├── CoreDataManager.swift
│   └── Diary.xcdatamodeld
├── Extension
│   ├── Date+.swift
│   ├── UIApplication+.swift
│   └── UITableView+.swift
├── Model
│   └── Diary.swift
├── Preview Data
│   └── sample.json
├── Protocol
│   └── ReusableCell.swift
└── View
    ├── DiaryListCell.swift
    └── DiaryScrollView.swift
```

## 📌 구현 내용
### 일기장 리스트 화면 구현
#### Table View 선택
[HIG - Lists and tables](https://developer.apple.com/design/human-interface-guidelines/components/layout-and-organization/lists-and-tables)에 따르면 컨텐츠가 텍스트 위주인 경우 테이블뷰의 사용을 권장하기 때문에 이번 프로젝트에서는 콜렉션 뷰보다는 테이블 뷰를 사용하여 구현하였습니다.

#### Diffable Data Source 사용
```swift
private func configureDataSource() {
    dataSource = DiaryDataSource(tableView: diaryListTableView, cellProvider: { tableView, indexPath, diary in
        guard let cell = tableView.dequeueReusableCell(withIdentifier: DiaryListCell.reuseIdentifier,
                                                           for: indexPath) as? DiaryListCell else {
            return DiaryListCell()
    }

            cell.titleLabel.text = diary.title
            cell.subtitleLabel.attributedText = self.configureSubtitleText(diary.createdDate, diary.body)
            
            return cell
    })
}
```
- Diffable DataSource는 Cell에 어떤 종류의 데이터가 들어갈지만 정해놓고, 데이터를 Snapshot 형태로 사진을 찍어서 View에 반영 하는 방식입니다.
- View를 다시 그릴 때 Snapshot의 변화를 스스로 파악하고 애니메이션으로 자연스럽게 연결되기 때문에 유저 경험적 측면과 데이터 동기화 문제나 예외 충돌 상황 등의 이슈를 방지하기 위해서 사용하였습니다.

### 일기장 생성 및 상세 화면 구현

#### KeyboardLayoutGuide 사용
![](https://i.imgur.com/2uE6xVo.gif)<br>
iOS 15버전에 발표된 KeyboardLayoutGuide API를 사용하여, 일기장을 작성할 시 키보드가 글씨를 가리지 않도록 구현하였습니다.

#### UIMenu 사용
![](https://i.imgur.com/1zP4Nsf.png)<br>
프로젝트 명세서에서는 일기장화면에서 더보기 버튼을 누르면 `ActionSheet`가 나오도록 되어있었지만, `UIMenu`를 사용하여 구현하였습니다. HIG에서 `ActionSheet`를 공부해 보았을 때 `ActionSheet`는 삭제, 내용편집, 되돌리기와 같이 결과물에 지장을 주는 작업이 이기때문에 이를 알려주기 위한 경고창으로 이해했고, 작업과 관련하여 추가적인 선택사항(일기장에서는 공유 기능이라고 생각했습니다)을 제공하지 않는다는 것을 보고, `UIMenu`를 선택해서 공유기능과 삭제기능을 제공하도록 구현하였습니다.

#### UIAlertController 사용
![](https://i.imgur.com/9VMVPNu.png)<br>
[HIG - Alerts](https://developer.apple.com/design/human-interface-guidelines/components/presentation/alerts)에 따르면 사용자가 파괴적인 작업을 수행할 때 UIAlertController를 통해 alert을 제공하는 것을 권장하고 있습니다. 사용자가 다이어리를 삭제하려는 행동을 취할 때 alert을 통한 확인 작업을 한 번 거친 뒤 삭제가 되게끔 작업하였습니다.

## ⏰ 타임라인

<details>
<summary> Step1 타임라인</summary>
<div markdown="1">       

- **2022.12.20**
    - JSON 데이터에 맞는 Diary 모델 타입구현
    - DiaryListViewController 구현
    - Custom TableViewCell DiaryListCell 구현
    
- **2022.12.21**
    - 다이어리 추가 버튼 및 추가 화면 구현
    - Date 구조체 확장을 통한 Formatter 구현
    - DiaryViewContorller 구현 및 autolayout 설정
    - 컨벤션 수정 및 폴더구조 변경
    
- **2022.12.23**
    - Swift Lint 관련 수정
    - Development Assets 설정
    - 네이밍 수정
    
- **2022.12.26**
    - 네비게이션 버튼에 UIAction 설정
    - Model 계층 분리
    - 테스트 케이스 리팩토링
    - 코드 컨벤션 수정
    
- **2022.12.27**
    - extension 및 셀의 프로토콜 채택 등을 통한 UITableView 간편화
    - 메서드 기능 분리
    - 테스트 케이스 리팩토링
    
</div>
</details>

<details>
<summary> Step2 타임라인</summary>
<div markdown="2">       
   
- **2022.12.28**
    - 코어데이터 CRUD 구현
    - 새로운 일기 작성시 화면 전환 및 키보드가 내용 가려지지 않게 구현
    - 코어데이터와 UI 연동
    - 일기장 수정되면 CoreData에 업데이트하는 메서드 추가
    - 일기장 화면 네이게이션바에 더보기 버튼누르면 일기 공유, 삭제 가능하도록 구현
    - 새로운 만드는 일기를 삭제하려는 경우 버그 수정
    - 일기장 리스트에서 일기 swipe하면 공유, 삭제 가능하도록 구현
    
</div>
</details>

## 📱 실행 화면
|![](https://i.imgur.com/WFWjWFT.gif)|![](https://i.imgur.com/YWuYgRi.gif)|
|:-:|:-:|
|**다이어리 생성 기능**|**다이어리 공유 기능**|<br>

|![](https://i.imgur.com/GEnYIOA.gif)|![](https://i.imgur.com/qN8GxG7.gif)|
|:-:|:-:|
|**다이어리 삭제 기능**|**리스트 스와이프 기능**|

## ❓ 트러블 슈팅 & 고민했던 점

### 1. Keyboard Layout Guide 사용할 때 텍스트 뷰의 커서가 가려지는 문제

```swift!
 private func configureLayout() {
        NSLayoutConstraint.activate([
            ...
            scrollView.bottomAnchor.constraint(equalTo: view.keyboardLayoutGuide.topAnchor),
            ...
        ])
    }
```

위와 같이 `keyboardLayoutGuide`를 사용했는데 화면에서 줄바꿈을 계속 진행하다보면 현재 입력중인 커서의 위치가 키보드에 가려지는 문제가 있었습니다.

<img src = "https://i.imgur.com/2iAAJ9S.gif" height=380>

이는 뷰 드로잉 사이클에 따라 업데이트의 필요성으로 인식되지 않는 점이 원인이었습니다.

### 해결방안

뷰 드로잉 사이클을 위해 `layoutIfNeeded` 등을 호출하여 해결할 수도 있겠지만 이때문에 매 사이클에서 호출이 된다면 성능의 저하가 우려되기 때문에 아래와 같이 `contentInset`을 사용해 해결했습니다.

```swift!
scrollView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 20, right: 0)
```

<img src = "https://i.imgur.com/6Y2UC9f.gif" height=380>

### 2. 테이블 뷰 vs 콜렉션 뷰 선택
ios 14 버전부터 콜렉션 뷰에서도 리스트 셀 구현이 가능하도록 틀을 제공해주어서 메인화면 일기장 리스트를 테이블뷰를 사용할지 콜렉션 뷰를 사용할지 고민했습니다. 주된 내용은 텍스트로만 이루어져 있기 때문에 HIG에 명시된대로 테이블뷰를 사용하여 구현하였습니다.

![](https://i.imgur.com/RyVS78B.png)
[HIG - Lists and tables](https://developer.apple.com/design/human-interface-guidelines/components/layout-and-organization/lists-and-tables)

### 3. Diffable Data source 사용 여부
`table View`를 사용하면서 `data source` 부분을 무엇으로 사용할 지 고민했습니다.
```swift
private func configureDataSource() {
        dataSource = DiaryDataSource(tableView: diaryListTableView, cellProvider: { tableView, indexPath, diary in
            guard let cell = tableView.dequeueReusableCell(withIdentifier: DiaryListCell.reuseIdentifier,
                                                           for: indexPath) as? DiaryListCell else {
                return DiaryListCell()
            }

            cell.titleLabel.text = diary.title
            cell.subtitleLabel.attributedText = self.configureSubtitleText(diary.createdDate, diary.body)
            
            return cell
        })
    }
```

`Diffable DataSource`는 `Cell`에 어떤 종류의 데이터가 들어갈지만 정해놓고, 데이터를 `Snapshot` 형태로 사진을 찍어서 `View`에 반영 하는 방식입니다.
다음과 같은 이유로 Diffable Data를 사용하였습니다.
- `View`를 다시 그릴 때 `Snapshot`의 변화를 스스로 파악하고 애니메이션으로 자연스럽게 연결되기 때문에 유저 경험적 측면을 위함
- 데이터 동기화 문제나 예외 충돌 상황 등을 커버 할 수 있음

또한 [WWDC2019 - Making Apps with Core Data](https://developer.apple.com/videos/play/wwdc2019/230/)에 소개된 내용에 따르면 차후 스텝에서 Core Data를 사용할 때 Snapshot과의 연계가 좋을 것이라고 생각했습니다.


### 4. 반복되는 alertConroller와 activityConroller에 대한 재사용
```swift!
private func showDeleteActionAlert() {
    ...
}

private func showActivityViewController(diary: Diary) {
     ...
}
```
`DiaryViewController`와 `DiaryListViewController`에 중복되어 사용되는 부분에 대해 어떻게 위치할지 고민하다 두 부분의 차이점을 반영하기 위해서 각 뷰컨트롤러에 구현하였습니다. 추후 공통되는 부분만 따로 위치하도록 리팩토링 할 예정입니다.

### 5. 하나의 뷰컨트롤러를 통해 편집과 추가 화면 동시 사용
step1 에서는 새로운 일기를 생성할 때 `NewDiaryViewController`으로 이동하게 하였는데, 기존일기 편집과 새로작성하는 뷰가 같아서 굳이 새로운 뷰컨트롤러가 필요할까라는 생각을 했습니다. 그래서 `DiaryViewController` 하나로 사용하는 것으로 결정하였습니다. 하지만 아직 저장하지 않은 다이어리에 대해서 삭제를 시도하는 것을 방지하고자 신규 작성의 경우 `rightBarButtonItem`을 넣어주지 않는 방향으로 진행하였습니다.

---

## 📖 참고 링크
[Adaptivity and Layout](https://developer.apple.com/design/human-interface-guidelines/ios/visual-design/adaptivity-and-layout/)
[UIKit: Apps for Every Size and Shape](https://developer.apple.com/videos/play/wwdc2018/235/)
[DateFormatter](https://developer.apple.com/documentation/foundation/dateformatter)
[UITextView](https://developer.apple.com/documentation/uikit/uitextview)
[UITextViewDelegate](https://developer.apple.com/documentation/uikit/uitextviewdelegate)
[UITableView](https://developer.apple.com/documentation/uikit/uitableview)
[Diffable data source](https://developer.apple.com/documentation/uikit/uitableviewdiffabledatasource)
[Adjusting Your Layout with Keyboard Layout Guide](https://developer.apple.com/documentation/uikit/keyboards_and_input/adjusting_your_layout_with_keyboard_layout_guide)
[Core Data](https://developer.apple.com/documentation/coredata)
[UISwipeActionsConfiguration](https://developer.apple.com/documentation/uikit/uiswipeactionsconfiguration)
[HIG: Menu](https://developer.apple.com/design/human-interface-guidelines/components/menus-and-actions/menus)

---

[🔝 맨 위로 이동하기](#일기장)
