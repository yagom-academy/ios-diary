## 일기장
> 프로젝트 기간: 23/08/28 ~ 23/09/15

## 📂 목차
1. [팀원](#1.)
2. [타임 라인](#2.)
3. [시각화구조](#3.)
4. [실행 화면](#4.)
5. [트러블 슈팅](#5.)
6. [팀 회고](#6.)
7. [참고 문서](#7.)


<a id="1."></a>

## 1. 팀원

| Jusbug | yyss99 |
| :--------: | :--------: |
| <Img src = "https://github.com/JusBug/ios-box-office/assets/125210310/549c2726-aa5a-48cc-a39a-7c10d10bdda5" width="200" height="200"> | <Img src = "https://hackmd.io/_uploads/ryHsN0cTn.png"  width="200" height="200"> |
|[Github Profile](https://github.com/JusBug) |[Github Profile](https://github.com/yy-ss99) |
- - -
<a id="2."></a>

## 2. 타임라인

<details>
<summary>타임 라인</summary>
<div markdown="1">
    
### 2023.08.28.(월)
- README 수정
### 2023.08.29.(화)
- DiaryTableViewCell 등록 및 구현
- Sample 데이터 타입 구현 및 JSON 파일 추가
- JSON파일을 Sample 타입으로 디코딩하는 decodeJSON() 구현
- DiaryTableViewCell 레이아웃 수정
- DateFormatter로 createdDate 날짜형식변환
### 2023.08.30.(수)
- 일기장 생성 버튼 구현
- TextView 생성 및 placeholder 구현
- DetailViewController 네비게이션 타이틀 오늘 날짜 추가
- DetailVC 생성 및 테이블 뷰 커스텀 이니셜라이져로 데이터를 전달하여 didSelectRowAt() 구현
- DetailViewController 편집 시 키보드가 글자 가리는 이슈 
### 2023.09.01 (금)
- final 키워드 명시, 은닉화 처리, 불필요한 프로퍼티 삭제
- NewDiaryViewController 삭제 및 DetailViewController 수정
- 불필요한 주석 제거
- README 업데이트
### 2023.09.14 (목)
- CoreDataManager 생성 및 저장, 수정 메서드 구현
- textView를 하나로 통합
- 새로운 Diary 저장기능 구현
- 추상화 및 조건문 수정, 공유와 삭제가 가능한 didTapMenu() 구현
- 화면 다크모드 적용 및 textColor 변경
- AlertAtion에서 delete 작업 구현
- CoreData에 날짜 저장 기능 추가

</div>
</details>
<a id="3."></a>

## 3. 시각화 구조

### 📐 Diagram

![](https://hackmd.io/_uploads/BJTyDdZka.png)

### 🌲 File Tree
<details>
<summary>File Tree</summary>
<div markdown="1">

```
.
├── Diary
│   ├── Entity+CoreDataClass.swift
│   ├── Entity+CoreDataProperties.swift
│   ├── Application
│   │   ├── AppDelegate.swift
│   │   └── SceneDelegate.swift
│   ├── ViewController
│   │   ├── MainViewController.swift
│   │   ├── DetailViewController.swift
│   │   └── DiaryTableViewCell.swift
│   ├── Model
│   │   ├── Sample.swift
│   │   ├── CustomDateFormatter.swift
│   │   └── CoreDataManager.swift
│   ├── Resources
│   │   ├── Assets
│   │   ├── Diary
│   │   └── Info.plist
│   └── View
│       ├── Base.lproj
│       │   ├── LaunchScreen.storyboard
│       │   └── Main.storyboard
│       └── DiaryTableViewCell.xib
│       
├── README.md
└── sample.json
```

</div>
</details>

</br>
<a id="4."></a>

## 4. 실행 화면
| Create | SwipeDelete | AlertDelete |
| :--------: | :--------: | :--------: |
|<Img src = "https://hackmd.io/_uploads/BkmegKW16.gif" width="200" height="400">|<Img src = "https://hackmd.io/_uploads/HJs43ub1a.gif" width="200" height="400">|<Img src = "https://hackmd.io/_uploads/BJVskY-Jp.gif" width="200" height="400">|

| Update | Share | Date |
| :--------: | :--------: | :--------: |
|<Img src = "https://hackmd.io/_uploads/Hy-I-KZya.gif" width="200" height="400">|<Img src = "https://hackmd.io/_uploads/rJRKkFZJp.gif" width="200" height="400">|<Img src = "https://hackmd.io/_uploads/S1MZVF-1p.gif" width="200" height="400">|

- - -
</br>
<a id="5."></a>

## 5. 트러블 슈팅

### 1. <키보드 가림 이슈>

🤯 **문제상황**
`textField`에 쓰는 글이 길어지다 보면 키보드에 의해 가려지는 현상이 발생했습니다. 

🔥 **해결방법**
키보드의 높이 만큼 `textView`의 `bottomInset`을 올라가도록 만들었습니다. 그래서 글이 쓰여지는 동안에 키보드에 의해 가려지 않고 화면에 보여지게 만들었습니다.

```Swift
@objc func keyboardWillShow(_ sender: Notification) {
    if originalFrame == nil {
        originalFrame = view.frame
    }
        
    if let keyboardFrame = (sender.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
        let keyboardHeight = keyboardFrame.height
        let safeAreaBottom = view.safeAreaInsets.bottom
        let contentInsets = UIEdgeInsets(top: 0, left: 0, bottom: keyboardHeight - safeAreaBottom, right: 0)
            
        bodyTextView.contentInset = contentInsets
    }
}
    
@objc func keyboardWillHide(_ sender: Notification) {
    if originalFrame != nil {
        bodyTextView.contentInset = UIEdgeInsets.zero
    }
}
```
- - -
### 2. <TextView Placeholder 구현>

🤯 **문제상황**
기본적으로 `UITextView`에서는 `placeholder` 기능을 제공하지 않아서 직집 구현해야 하는 문제가 있었습니다. 참고로 `placeholder`는 사용자에게 입력하라는 힌트를 주는 메시지 역할로 사용자 입장에서 보다 편리한 UI 경험을 제공하기 위해서 구현하게 되었습니다.

🔥 **해결방법**
`titleTextView`, `bodyTextView`에서 둘다 사용할 수 있도록 `placeHolderText` 문자열을 전역으로 두고 `UITextViewDelegate`의 `textViewDidBeginEditing` `textViewDidEndEditing` 메서드 즉, 텍스트 뷰의 편집의 시작과 종료 시점에서 호출되는 메서드 안에 텍스트와 컬러를 정의함으로서 직접 placeholder기능을 구현하였습니다.

```Swift
let placeHolderText = "Input Text"
...
extension NewDiaryViewController: UITextViewDelegate {
    func textViewDidBeginEditing(_ textView: UITextView) {
        if titleTextView.text == placeHolderText {
            titleTextView.text = nil
            titleTextView.textColor = .black
        }
        
        if bodyTextView.text == placeHolderText {
            bodyTextView.text = nil
            bodyTextView.textColor = .black
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if titleTextView.text.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
            titleTextView.text = placeHolderText
            titleTextView.textColor = .lightGray
        }
        
        if bodyTextView.text.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
            bodyTextView.text = placeHolderText
            bodyTextView.textColor = .lightGray
        }
    }
}
```
<Img src = "https://hackmd.io/_uploads/rkFAu_2ph.gif" width="300" height="600">
- - -
### 3. <touchesBegan 메서드>
🤯 **문제상황**
`TextViewDelegate`의 `textViewDidEndEditing()`가 호출되기 위해서는 텍스트 뷰의 편집이 종료되어야 하는데 다른 터치이벤트를 이용하여 처리를 해주어야만 편집에서 벗어날 수 있었습니다.

🔥 **해결방법**
`touchesBegan()`는 터치 이벤트가 발생했을 때 호출되는 메서드로 뷰 안에서 편집중인 키보드를 찾아 닫을 수 있도록 해결하였습니다.
```Swift
override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
    self.view.endEditing(true)
}
```
<Img src = "https://hackmd.io/_uploads/H1T32O2T2.gif" width="300" height="600">

- - -
### 4. <DateFormatterManager 구현>

🤯 **문제상황**
`DateFormatter`를 여러번 생성해서 사용해야 하는 상황이 발생 했습니다. 같은 역할을 하는 인스턴스를 여러번 만들어 사용하는 것이 비효율적이었습니다.


🔥 **해결방법**
`static`을 사용하여 `DateFormatter`를 한번만 생성하여 여러 곳에서 쓸 수 있도록 `CustomDateFormatter` 구조체를 만들었습니다.
```Swift
struct CustomDateFormatter {
    static let customDateFormatter: DateFormatter = {
        let todayDateFormatter = DateFormatter()
        todayDateFormatter.locale = Locale(identifier: "koKR")
        todayDateFormatter.dateFormat = "yyyy년 MM월 dd일"

        return todayDateFormatter
    }()

    static func formatTodayDate() -> String {
        let today = Date()
        let formattedTodayDate = customDateFormatter.string(from: today)

        return formattedTodayDate
    }

    static func formatSampleDate( sampleDate: Int) -> String {
        let timeInterval = TimeInterval(sampleDate)
        let inputDate = Date(timeIntervalSince1970: timeInterval)
        let formattedDate = customDateFormatter.string(from: inputDate)

        return formattedDate
    }
}
```
- - -
### 5. <CoreDataManager 데이터 공유>

🤯 **문제상황**
`CoreDataManager`파일로 CRUD를 구현하였는데 각 ViewController에서 어떤 패턴으로 데이터를 가져와 사용할지 고민하게 되었습니다.

🔥 **해결방법**
단일 인스턴스로 여러 곳에서 해당 인스턴스를 공유할 수 있는 싱글톤 패턴을 사용하였습니다.
```Swift
final class CoreDataManager {
    static var shared: CoreDataManager = CoreDataManager()
    ...
```
- - -
### 6. <tableView 업데이트>

🤯 **문제상황**
텍스트 뷰의 생성하여 저장하거나 수정하여도 변경된 `Entity`데이터가 테이블 뷰에 바로 업데이트 되지 않았고 다시 빌드를 해야만 적용되는 문제가 있었습니다. 

🔥 **해결방법**
`MainVC`가 화면에 뜨기 직전에 호출되는 `viewWillAppear()`가 호출될 때, `getAllEntity()`를 통하여 변경된 Entity의 데이터를 가져오고, 메인 스레드에서 비동기 작업을 통해 테이블 뷰에 다시 데이터를 로드하고 업데이트하는 방식으로 해결했습니다.
```Swift
override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    self.callGetAllEntity()
}

private func callGetAllEntity() {
    coreDataManager.getAllEntity()
    DispatchQueue.main.async {
        self.tableView.reloadData()
    }
}

```

- - -
### 7. <새로운 일기 생성와 기존 일기 수정 처리>

🤯 **문제상황**

이전 화면(리스트 화면)으로 이동하는 경우 저장 되는 기능을 구현하기 위해서 `viewWillDisappear` 메서드 안에 저장하는 기능을 구현했습니다. 하지만 새로 생성하는 일기와 전에 있던 일기를 수정하는 경우를 각각 다르게 처리해야 한다는 문제상황이 발생했습니다.

🔥 **해결방법**

초기에 `tableView`에서 전달받는 `entity`가 있는지 없는지 저장하는 `initEntity` 변수를 만들어주었습니다. 전달 받은 `entity`가 없다면 새로운 일기이므로 `CoreData`에 `createEntity`를 하고 아니라면 기존에 있는 일기이므로 `updateEntity`를 합니다

```Swift=
private var initEntity: Entity?
...

override func viewDidLoad() {
...
        initEntity = self.entity
    }

override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        guard let text = textView.text, !text.isEmpty, text != placeHolderText else {
            return
        }
        let (title, body) = self.splitText(text: text)
        
        if initEntity == nil {
            coreDataManager.createEntity(title: title, body: body)
        } else {
            guard let entity = self.entity else {
                return
            }
            coreDataManager.updateEntity(entity: entity, newTitle: title, newBody: body)
        }
    }
```

- - -
### 8. <다크모드>

🤯 **문제상황**
ViewController에서 직접 다크모드로 값을 주어 선언했을 때, 변경된 배경으로 인해 상단 바와 Title이 보이지 않는 문제가 발생하였습니다.

<Img src = "https://hackmd.io/_uploads/HJX0x9ey6.png" width="300" height="600">

🔥 **해결방법**
SceneDelegate의 scene() 메서드에서 직접 window.overrideUserInterfaceStyle을 dark로 선언해주어 해결하였습니다. 참고로 다크모드는 iOS 13에 도입된 UI 옵션입니다. 또한 SceneDelegate는 멀티 윈도우의 관리를 지원하므로써 Scene 설정을 통해서 다크모드로 지정할 수 있습니다.
```Swift
class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?


    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        // Use this method to optionally configure and attach the UIWindow `window` to the provided UIWindowScene `scene`.
        // If using a storyboard, the `window` property will automatically be initialized and attached to the scene.
        // This delegate does not imply the connecting scene or session are new (see `application:configurationForConnectingSceneSession` instead).
        guard let _ = (scene as? UIWindowScene) else { return }
        
        if #available(iOS 13.0, *) {
            window?.overrideUserInterfaceStyle = .dark
        }
    }
    ...
```
<Img src = "https://hackmd.io/_uploads/rkA1ZqekT.png" width="300" height="600">

- - -
### 9. <title과 body 분리>

🤯 **문제상황**
텍스트 뷰에 입력한 문자열을 구분하여 title과 body로 어떻게 저장할지 고민하게 되었습니다.

🔥 **해결방법**
텍스트 뷰의 전체 문자열을 들여쓰기를 기준으로 하여 배열로 담아 분류하여 첫 번째 요소를 title로 주고 이후 나머지 값을 모두 body로 처리하여 구분하였습니다.
```Swift
private func splitText(text: String) -> (title: String, body: String) {
    let lines = text.components(separatedBy: "\n")
    var title = ""
    var body = ""
    
    if let firstLine = lines.first {
        title = firstLine
    }
    
    if lines.count > 1 {
        body = lines[2...]
            .joined(separator: "\n")
    }
    
    return (title, body)
}
```
- - -
<a id="6."></a>

## 6. 팀 회고

### 우리팀이 잘한점👍
- 이해를 하는 데에 중심을 두고 프로젝트를 진행해서 공부를 많이 하게 되었습니다.
    
### 서로에게 피드백😀
    
- <To. yyss99>
    - 적극적으로 질문을 해주셔서 저 또한 다시 이해해보고 공부하게 되는 시간이 될 수 있었습니다.
    - 제 의견과 설명을 해드리면 바로 포인트를 캐치해서 빠르게 이해해주셔서 좋았습니다.

- <To. Jusbug🕷️>
    - 의견을 제시했을 때 잘 반영해주셔서 좋았습니다.👍
    - 프로젝트 진행보다 이해와 학습 우선시 하는 분위기를 만들어 주셔서 좋았습니다.📖
    
</br>

- - -
<a id="7."></a>

## 7. 참고 문서

- [🍎 Apple - Adaptivity and Layout](https://developer.apple.com/design/human-interface-guidelines/ios/visual-design/adaptivity-and-layout/)
- [🍎 Apple - UIKit: Apps for Every Size and Shape
](https://www.wwdcnotes.com/notes/wwdc18/235/)
- [🎦 Video - Making apps adaptive 1](https://www.youtube.com/watch?v=hLkqt2g-450)
- [🎦 Video - Making apps adaptive 2](https://www.youtube.com/watch?v=s3utpBiRbB0)
- [🍎 Apple - dateformatter](https://developer.apple.com/documentation/foundation/dateformatter)
- [🍎 Apple - UITextView](https://developer.apple.com/documentation/uikit/uitextview)
- [🍎 Apple - coredata](https://developer.apple.com/documentation/coredata)
- [🍎 Apple - UItextviewdelegate](https://developer.apple.com/documentation/uikit/uitextviewdelegate)
- [🍎 Apple - UIswipeactionsconfiguration](https://developer.apple.com/documentation/uikit/uiswipeactionsconfiguration)
- [🍎 Apple - UIsearchcontroller](https://developer.apple.com/documentation/uikit/uisearchcontroller)
- [🍎 Apple - dark-mode](https://developer.apple.com/design/human-interface-guidelines/ios/visual-design/dark-mode)
- [🎦 Video - Typography and Fonts (WWDC 2016)](https://www.youtube.com/watch?v=7AeEkoKb52Y)
