# 일기장 📔

## 📖 목차

1. [소개](#-소개)
2. [프로젝트 구조](#-프로젝트-구조)
3. [구현 내용](#-구현-내용)
4. [타임라인](#-타임라인)
5. [실행 화면](#-실행-화면)
6. [트러블 슈팅 & 어려웠던 점](#-트러블-슈팅--어려웠던-점)
7. [참고 링크](#-참고-링크)

## 😁 소개

|<img src= https://i.imgur.com/ryeIjHH.png width=150>|<img src= "https://avatars.githubusercontent.com/u/74972815?v=4" width=150>|
|:---:|:---:|
|[토털이](https://github.com/tottalE)|[스톤](https://github.com/lws2269)

## 🛠 프로젝트 구조

### 📊 UML
추후 추가예정입니다.



### 🌲 Tree
```
.
└── Diary/
    ├── .swiftlint.yml
    └── Diary/
        ├── AppDelegate.swift
        ├── SceneDelegate.swift
        ├── Assets.xcassets
        ├── Info.plist
        ├── Diary.xcdatamodeld
        ├── Extension/
        │   └── DateFormatter+extension.swift
        ├── Models/
        │   └── Diary.swift
        ├── Views/
        │   └── DiaryCell.swift
        └── Controllers/
            ├── DiaryListViewController.swift
            └── AddDiaryViewController.swift
```
## 📌 구현 내용
## SceneDelegate
- **Scene**
```swift
func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {

    guard let windonScene = (scene as? UIWindowScene) else {return}

    window = UIWindow(windowScene: windonScene)

    let rootViewController = DiaryListViewController()
    let navigationViewController = UINavigationController(rootViewController: rootViewController)

    self.window?.rootViewController = navigationViewController
    window?.makeKeyAndVisible()
}
```
스토리 보드를 삭제하고, 코드를 통해 기본 `ViewContoller`를 `NavagitonViewController`로 선언하여 사용하기 위해 커스텀하였습니다.

## Model
### **Diary**
- STEP1의 `sample`데이터를 parse하기 위한 `DTO`클래스입니다.
## Controller
### DiaryListViewController
   - 다이어리 내용을 `TableView`로 보여주기 위한 `ViewController`입니다.

`TableView` 내부의 Cell의 크기가 유동적으로 바뀔 수 있도록 해주는 `UITableViewDelegate` 프로토콜의 `tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat`를 채택해 주었습니다.

```swift
func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    return UITableView.automaticDimension
}
```



### AddDiaryViewController
- 새로운 일기 작성을 위한 `ViewContoller`입니다.

`TextView`의 `placeholder`기능을 구현하기 위해 `UITextViewDelegate`를 사용해 구현하였습니다.
```swift
func textViewDidBeginEditing(_ textView: UITextView) {
    if textView.text == "내용을 입력하세요." {
        textView.text = nil
        textView.textColor = .black
    }
}

func textViewDidEndEditing(_ textView: UITextView) {
    if textView.text.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
        textView.text = "내용을 입력하세요."
        textView.textColor = .lightGray
    }
}
``` 

## View
### DiaryCell
- `DiaryListViewController` - `UITableView`에 사용되는 `UITableVieCell`클래스입니다.
## Extension
### DateFormatter+extension
- `Date`타입의 값을 형식에 맞게 변환하기 위하여 확장구현하였습니다.

`DateFormatter`의 타입메서드로, `Date`, `Locale`, `dateStyle`의 값을 받아 형식에 맞는 `Date`타입의 값을 `String`타입으로 반환합니다.
```swift
static func conversionLocalDate(date: Date, local: Locale, dateStyle: DateFormatter.Style) -> String {
    let formatter = DateFormatter()
    formatter.locale = local
    formatter.dateStyle = dateStyle
    return formatter.string(from: date)
}
```
## 📱 실행 화면
|가로 리스트| 가로 키보드 UpDown|
|:------------------------------------:|:------------------------------------:|
|![](https://i.imgur.com/w0ynlO9.gif)|![](https://i.imgur.com/FHdHKIL.gif)|
|**세로 리스트**| **세로 키보드 UpDown**|
|![](https://i.imgur.com/dHGPEpy.gif)|![](https://i.imgur.com/OoNG7uv.gif)|
|**플레이스 홀더**|
|![](https://i.imgur.com/jIAhZBY.gif)|



## ⏰ 타임라인


<details>
<summary>Step1 타임라인</summary>
<div markdown="1">       

- **2022.12.21**
    - `NavigationController` 내부의 `NavigationItem` 설정
    - 커스텀 Cell을 생성하여 제목, 작성일자, 한줄 미리보기 정보 표시
    - 커스텀 Cell 내부 스택뷰를 활용하여 구성
    - `DateFormatter`를 이용해 작성일자는 지역에 맞는 날짜 포맷으로 변경 
    - 견본 JSON 데이터를 통한 화면 구성을 위해 Decodable한 Model 생성
- **2022.12.22**
    - AddDiaryViewController 생성을 통해 + 버튼을 터치시 일기장 작성 화면으로 이동하도록 코드 작성
    - `UITextField`와 `UITextView`를 통해 제목 및 본문 화면 구성, AutoLayout으로 화면 구성
    - `UITextViewDelegate`을 채택하여 `textViewDidBeginEditing()'과 `textViewDidEndEditing()`에 PlaceHolder를 구현해 줌
    - 일기장 화면의 제목 부분에는 일기 생성 날짜를 표기하도록 `NavigationController`의 `NaviationTitle` 설정
    - 편집중인 텍스트가 키보드에 의해 가리지 않도록 구현
    
</div>
</details>


## ❓ 트러블 슈팅 & 어려웠던 점
STEP2 이후 추가 예정입니다.

---

## 📖 참고 링크

[Fixing the keyboard: NotificationCenter](https://www.hackingwithswift.com/read/19/7/fixing-the-keyboard-notificationcenter)

---

[🔝 맨 위로 이동하기](#일기장-)
