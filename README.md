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

## 🛠 프로젝트 구조

## 📊 UML
> ![](https://i.imgur.com/uEaAmjY.png)



## 🌲 Tree
```
Diary
├── App
│   ├── AppDelegate.swift
│   └── SceneDelegate.swift
├── Controller
│   ├── DiaryListViewController.swift
│   ├── DiaryViewController.swift
│   └── NewDiaryViewController.swift
├── Extension
│   └── Date+.swift
├── Model
│   └── Diary.swift
└── View
    └── DiaryListCell.swift

```
## 📌 구현 내용

### 일기장 리스트 화면 구현
#### Table View 선택
[HIG](https://developer.apple.com/design/human-interface-guidelines/guidelines/overview/)에 컨텐츠가 텍스트인 경우 테이블뷰를 사용하라고 해서 최종적으로 테이블 뷰를 사용하여 구현하였습니다.

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

#### KeyboardLayoutGuide 사용
iOS 15버전에 발표된 KeyboardLayoutGuide API를 사용하여, 일기장을 작성할 시 키보드가 글씨를 가리지 않도록 구현하였습니다.




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
    
</div>
</details>


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

---

## 📖 참고 링크

[UITableView](https://developer.apple.com/documentation/uikit/uitableview)
[Diffable data source](https://developer.apple.com/documentation/uikit/uitableviewdiffabledatasource)
[Adjusting Your Layout with Keyboard Layout Guide](https://developer.apple.com/documentation/uikit/keyboards_and_input/adjusting_your_layout_with_keyboard_layout_guide)

---

[🔝 맨 위로 이동하기](#일기장)
