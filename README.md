# 📔 Diary
- jpush와 Wonbi가 만든 일기를 쓰고 편집할 수 있는 Diary App입니다.

## 📖 목차
1. [팀 소개](#-팀-소개)
2. [팀 위키](#-팀-위키)
3. [실행 화면](#-실행-화면)
4. [폴더 구조](#-폴더-구조)
5. [타임라인](#-타임라인)
6. [기술적 도전](#-기술적-도전)
7. [트러블 슈팅 및 고민](#-트러블-슈팅-및-고민)
8. [참고 링크](#-참고-링크)

<!-- 
4. [Diagram](#-diagram)
5. [폴더 구조](#-폴더-구조)
6. [타임라인](#-타임라인)
7. [기술적 도전](#-기술적-도전)
8. [트러블 슈팅 및 고민](#-트러블-슈팅-및-고민)
9. [참고 링크](#-참고-링크)
 -->

## 🌱 팀 소개
|[Wonbi](https://github.com/wonbi92)|[jpush](https://github.com/jjpush)|
|:---:|:---:|
| <img width="180px" img style="border: 2px solid lightgray; border-radius: 90px;-moz-border-radius: 90px;-khtml-border-radius: 90px;-webkit-border-radius: 90px;" src="https://avatars.githubusercontent.com/u/88074999?v=4">| <img width="180px" img style="border: 2px solid lightgray; border-radius: 90px;-moz-border-radius: 90px;-khtml-border-radius: 90px;-webkit-border-radius: 90px;" src= "https://i.imgur.com/BpCwjWH.jpg">|

## 🧭 팀 위키

#### [🤙 Ground Rule](https://github.com/jjpush/ios-diary/wiki/🤙-Ground-Rule)

#### [🖋 Code Convention](https://github.com/jjpush/ios-diary/wiki/🖋-Code-Convention)

#### [📝 일일 스크럼](https://github.com/jjpush/ios-diary/wiki/3.-일일-스크럼)

## 🛠 실행 화면

### Localizable

| 한국어 설정 | 영어 설정 |
|:--:|:--:|
|![](https://i.imgur.com/WqJR5mx.gif)|![](https://i.imgur.com/bTPX4S3.gif)|

### 실행화면

| 실행 화면 | 메모 생성 화면 | 
|:--:|:--:|
|![step1 실행화면](https://user-images.githubusercontent.com/82566116/208919392-8c0fac1a-1282-42a2-ae0c-c6e54debbdb0.gif)| ![](https://i.imgur.com/QeBfmLF.gif) | 

| 빈 내용 입력 시 메모 생성하지 않음 | 메모 수정 화면 |
|:--:|:--:|
|![](https://i.imgur.com/3CJvJjE.gif) | ![](https://i.imgur.com/R08mrDl.gif)

<!--
## 👀 Diagram

### 🧬 Class Diagram
![](https://i.imgur.com/14dtqyj.png)
-->
 
## 🗂 폴더 구조
> DiaryViewController: 일기장의 리스트를 보여주는 뷰 컨트롤러 <br>
> EditorViewController: 일기장을 편집하는 뷰를 보여주는 뷰 컨트롤러 <br>
> Extension: 기존 타입의 확장 기능을 정의 <br>
> CoreData: CoreData 관련 파일
```
├── Diary
│   ├── Info.plist
│   ├── AppDelegate
│   ├── SceneDelegate
│   ├── Assets
│   │   ├── Contents.json
│   │   └── sample.dataset
│   ├── CoreData
│   │   ├── Diary+CoreDataClass.swift
│   │   ├── Diary+CoreDataProperties.swift
│   │   ├── DiaryData.swift
│   │   └── DiaryDataStore.swift
│   ├── Constant
│   ├── DiaryViewController
│   │   ├── DiaryListCell
│   │   └── DiaryViewController
│   ├── EditorViewController
│   │   └── EditorViewController
│   ├── Extension
│   │   ├── CellIdentifiable+.swift
│   │   ├── Collection+.swift
│   │   ├── Date+.swift
│   │   ├── String+.swift
│   │   ├── Date+.swift
│   │   └── UIAlertController+.swift
├── Pods
│   └── SwiftLint
└── README
```

## ⏰ 타임라인

#### 👟 Step 1
- SwiftLint 적용
    ✅ SwiftLint이용해 코드 컨벤션 지키기
- Date Formatter 활용하기
    ✅ DateFormatter를 활용해 사용자의 지역 포맷에 맞게 날짜 출력하기
- NotificationCenter 활용하기
    ✅ 키보드가 나타나고 사라질 때 키보드의 위치 정보 구하기 

#### 👟 Step 2
- CoreData 적용
    ✅ CoreData를 이용해 메모장의 데이터를 저장 및 로드
    ✅ 데이터의 상태에 따라 분기처리를 통한 UX 개선

## 🏃🏻 기술적 도전

#### ⚙️ SwiftLint 
<details>
<summary>펼쳐보기</summary>
    
- SwiftLint란 스위프트 언어에서 사용하는 `Linter` 입니다.`Linter`란 커뮤니티나 팀에서 정한 스타일 규칙을 따르지 않는 코드 부분을 식별하고 표시하는 것을 돕는 도구입니다.
- 이 SwiftLint 오픈소스 라이브러리를 활용하면 미리 정한 코드 컨벤션을 지키지 않았을 시 이를 컴파일러가 표시하도록 해서 코더가 코드 컨벤션을 지키고 코드의 복잡성이 올라가지 않도록 도와주는 장점이 있습니다. <br><br>
- 💡 이번 프로젝트에서는 팀원과 미리 정해놓은 코드 컨벤션 규칙을 실수로 어기는 일이 없도록 하기위해 CocoaPods을 통해 라이브러리를 적용해보았습니다.

</details>

#### ⚙️ LocalizedString 
<details>
<summary>펼쳐보기</summary>
    
- LocalizedString은 사용자가 선호하는 언어적, 문화적, 기술적 컨벤션에 맞추어 좀 더 사용자 친화적으로 앱을 보여줄 수 있습니다. 
- 이를 통해 사용자에게 좀 더 나은 UI/UX를 제공할 수 있고, 각 나라와 언어에 맞는 앱을 구성할 수 있습니다. <br><br>
- 💡 이번 프로젝트에서는 이 Localized를 사용하기 위해서 [Locale](https://developer.apple.com/documentation/foundation/locale) 타입을 사용하여 
    사용자의 기기의 Locale.preferredLanguages 배열의 첫번째 값을 가져와서 사용했습니다.

</details>

#### ⚙️ CoreData 
<details>
<summary>펼쳐보기</summary>
    
- CoreData는 애플리케이션의 모델 계층의 객체를 관리하기 위한 프레임워크입니다. 이 프레임워크는 객체의 영속 기능을 포함한 객체 생명주기 및 객체 관계도 관리 작업에 대한 일반적이고 자동화 된 방법을 제시합니다.
- 코어데이터를 사용하면 앱이 종료되어도 앱 내에 작성했던 데이터를 영속적으로 보관할 수 있고, 사용자의 입력값에 따라 새로운 데이터를 만들거나, 기존 데이터를 수정하거나, 데이터를 제거하는 동작을 자동화 된 방법으로 활용할 수 있습니다.
    <br><br>
- 💡 이번 프로젝트에서는 이 코어데이터를 통해 사용자가 입력한 일기를 앱이 종료되어도 영속적으로 보관하도록 하고, 사용자가 내용을 수정하거나 삭제할 수 있는 방법을 제시하여 활용하도록 사용했습니다.
</details>

## 🏔 트러블 슈팅 및 고민
    
# 고민했던 점

#### 🚀 Locale.current에 접근하기
    
<details>
<summary> 
펼쳐보기
</summary>

**문제 👻**
- LocalizedString을 사용하기 위해서 Locale.current를 통해 접근하고 싶었으나 한국 지역의 경우 값이 "ko_KR"이 아닌 "en_KR"이 나오게 되어 정상적으로 Localize 되지 않는 문제가 있었습니다. 
    
**해결 🔫**
- 사용자 기기의 설정의 선호하는 언어 리스트(Locale.preferredLanguages)를 가져온 후 가장 상단(first)에 있는 언어를 가져와서 "ko_KR"로 설정해줄 수 있었습니다.

</details>
    
#### 💭 delegate와 dataSource는 누가 해야하나?
    
<details>
<summary> 
펼쳐보기
</summary>

**고민 🤔**
- 방대해져 가독성이 떨어지는 ViewController 클래스의 가독성을 올리기 위해 `UITableViewDelegate`객체와 `UITableViewDataSource`객체를 커스텀으로 직접 만들어 만든 객체가 관련된 로직을 수행하고, 이를 뷰 컨트롤러가 소유하게 하는 방법을 생각했습니다.
```swift
final class DiaryTableViewDelegate: UITableViewDelegate {
    // 델리게이트 기능 구현
}

final class DiaryTableViewDataSource: UITableViewDataSource {
    // 데이터소스 기능 구현
}

final class DiaryViewController: UIViewController {
    private let tableView: UITableView = UITableView()
    
    private let delegate: UITableViewDelegate = DiaryTableViewDelegate()
    private let dataSource: UITableViewDataSource = DiaryTableViewDataSource()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = delegate
        tableView.dataSource = dataSource
    }
}
```
- 하지만, 실제로 이 객체들을 커스텀으로 만들었을 때 delegate가 다음 화면을 띄우기 위해 네비게이션 컨트롤러를 가지고 있게 되고 화면을 띄우기 전에 뷰 컨트롤러에 모델에 대한 데이터를 넘겨주기 위해 모델을 소유하게 되는 등, 오히려 불필요한 의존성을 만들게되고, 이로 인해 로직이 더욱 복잡해지는 듯한 느낌을 받았습니다.

```swift
class TestTableViewDelegate: NSObject, UITableViewDelegate {
    let navigationController: UINavigationController
    private var diaryContents: [DiaryContent] = []
    
    init(data: [DiaryContent], navi: UINavigationController) {
        diaryContents = data
        navigationController = navi
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        let editorViewController = EditorViewController()
        editorViewController.configureEditorView(from: diaryContents[indexPath.row])
        
        self.navigationController.pushViewController(editorViewController, animated: true)
    }
}
```

- 결과적으로 데이터소스와 델리게이트 역할을 하는 컨트롤러 객체만 더 생겼을 뿐이고, 이는 방대해진 뷰 컨트롤러를 줄이기 위해 너무 많은 사이드 이팩트를 가져간다고 생각했습니다. 뷰 컨트롤러가 조금 방대하더라도 중간에 객체를 거쳐서 로직이 진행되는 것보다 다이렉트로 컨트롤 하는 것이 더 좋은 방향이라 생각했습니다.
- 이런 고민을 거듭한 결과, 이는 좋은 방향성이 아니라는 생각이 들어 적용하지 않았습니다.
    
</details>
    
    
#### 💭 Container를 어디서 가지게 할 것인가?
<details>
<summary> 
펼쳐보기
</summary>
    
- 먼저, 코어데이터를 사용하기위한 패턴을 어떻게 가져가야 할지에 대한 고민을 했습니다. 단순히 뷰 컨트롤러가 NSPersistentContainer 객체를 가지는 방식으로 간다면, 코어데이터의 데이터를 여기저기서 접근할 수 있게되어 어디서 언제 이 데이터가 생성, 수정, 삭제가 일어나는지에 대한 시점을 알기 힘들어지기 때문에 이 방법은 좋은 방법이 아니라 생각했습니다. 그래서 좀 더 좋은 방법은 없을까 고민해보았습니다.

    
1. 시작할 때 rootViewController에 주입해서 사용하는 방법
    - NSPersistentContainer객체를 하나 만든 후, 그 객체를 뷰 컨트롤러에 주입하여 사용하는 방식을 생각했습니다. 그리고 프로토콜을 이용해 이 프로토콜을 채택하는 객체만 Container를 주입받아 사용하도록 로직을 구성하였습니다. 
    - 하지만, 이 방법은 뷰컨트롤러가 Container를 가지고 있는 것은 동일하기에 context에 직접 접근이 가능해 코어데이터가 뷰 컨트롤러에 직접 노출되는 문제가 있었습니다.
    
    
2. 전역으로 사용한 Appdelegate의 container를 가져오는 방법
    - 그래서 NSPersistentContainer객체를 Appdelegate가 가지도록 하고, 그 Container를 매니징하는 Store 싱글톤 객체를 만들어 context에 직접 접근하지 않고 데이터의 생성, 수정, 삭제를 요청하기만 하도록 하여 context를 숨기면서 데이터의 변화를 추적하기 편하도록 구성하게 되었습니다.
    
    
    
    
</details>

#### 💭 textView focus 시, 키보드를 올리는 방법
<details>
<summary> 
펼쳐보기
</summary>

- iOS 15 버전 이후부터는 KeyboardGuideLayout이 있어 사용이 간편하나 이번 프로젝트는 14버전을 기준으로 잡았기 때문에 NotificationCenter를 활용해서 키보드를 불러주는 방법을 사용했습니다.
    - 키보드를 불러오는 순간 textView의 Bottom 제약조건을 수정해서 키보드의 높이만큼 constant를 주었습니다.
    - 새 메모를 생성 시 키보드가 올라오는 애니메이션을 보여주고 UX를 향상시키기 위해서 viewDidAppear에서 조정하도록 했습니다.
    
    - 키보드를 올릴 때 textview가 tap되었을 때 NotificationCenter.post를 하고 싶었으나 작동하지 않았습니다. 왜 그런지는 아직 파악하지 못했고 firstResponder를 불러오는 becomefirstResponder를 사용했습니다.
    
</details>

#### 


## 🔗 참고 링크

[공식문서]

- [localizedString](https://developer.apple.com/documentation/foundation/dateformatter/1415241-localizedstring) <br>
- [Locale](https://developer.apple.com/documentation/foundation/locale) <br>
- [Creating Great Localized Experiences with Xcode 11](https://developer.apple.com/videos/play/wwdc2019/403/) <br>
- [Move TextView Up when keyboard appear](https://stackoverflow.com/questions/25693130/move-textfield-when-keyboard-appears-swift) <br>
- [CoreData](https://developer.apple.com/documentation/coredata) <br>
---


[⬆️ 맨 위로 이동하기](#-diary)
