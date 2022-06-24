# 📒 일기장
> 프로젝트 기간 2022.06.13 ~ 2022.07.01  
팀원 : [malrang](https://github.com/malrang-malrang) [Tiana](https://github.com/Kim-TaeHyun-A) / 리뷰어 : [stevenkim](https://github.com/stevenkim18)

- [Ground Rules](#ground-rules)
- [실행화면](#실행화면)
- [STEP 1 구현](#step-1-구현)
    + [고민했던 것들(트러블 슈팅)](#고민했던-것들트러블-슈팅)
    + [질문한것들](#질문한것들)
- [STEP 2 구현](#step-2-구현)
    + [고민했던 것들(트러블 슈팅)](#고민했던-것들트러블-슈팅-1)
    + [질문한것들](#질문한것들-1)

## Ground Rules
### 🌈 스크럼
- 10시 ~ 10시30분

### 주간 활동 시간
- 월, 화,수, 목, 금 : 10시 ~ 22시
- 수요일 : 개인공부
- 점심시간 : 12시 ~ 13시
- 저녁시간 : 18시 ~ 20시
- 상황에 따라 조정 가능

###  🪧 코딩 컨벤션

#### Commit 규칙
커밋 제목은 최대 50자 입력
본문은 한 줄 최대 72자 입력

#### Commit 메세지
chore: 코드 수정, 내부 파일 수정.  
feat: 새로운 기능 구현.  
style: 스타일 관련 기능.(코드의 구조/형태 개선)  
add: feat 이외의 부수적인 코드 추가, 라이브러리 추가  
file: 새로운 파일 생성, 삭제 시  
fix: 버그, 오류 해결.  
docs: README나 WIKI 등의 문서 개정.   
correct: 주로 문법의 오류나 타입의 변경, 이름 변경 등에 사용합니다.  
move: 프로젝트 내 파일이나 코드(리소스)의 이동.  
refactor: 전면 수정이 있을 때 사용합니다  
test: 테스트 코드를 작성할 때 사용합니다.  

#### Commit Body 규칙
제목 끝에 마침표(.) 금지
한글로 작성

#### 브랜치 이름 규칙
`STEP1`, `STEP2`, `STEP3`

## 실행화면
![ㄴㄴ](https://user-images.githubusercontent.com/88717147/174244161-6825eafe-d1ec-4336-a3f9-a1fc96c3f7d6.gif)

## STEP 1 구현
1. 일기장 List 페이지 구현
2. 일기장 추가/수정 페이지 구현

### 구조
![](https://i.imgur.com/IgC8p5k.png)

### DiaryView Autolayout
![](https://i.imgur.com/etIy3bQ.png)

## 고민했던 것들(트러블 슈팅)
1️⃣ **요구서와 유사하도록 네비게이션바 버튼 text의 크기와 굵기를 두껍게 할수 없을까?🤔**

`DiaryViewController`의 네비게이션바 right item + 버튼 굵기(weight) 를 두껍게 할수 없을까 고민하였고 `UIFont, NSAttributedString` 을 활용해 text의 size와 굵기(weight) 를 설정해주었다.

```swift
let weight = UIFont.systemFont(ofSize: 35, weight: .light)
let attributes = [NSAttributedString.Key.font: weight]

registerButton.setTitleTextAttributes(attributes, for: .normal)
```

2️⃣ **code로 테이블뷰 셀을 만들 때 어떤 이니셜라이져를 사용해야 할까?🤔**
TableviewCell에는 `init(style: UITableViewCell.CellStyle, reuseIdentifier: String?)` 와 `init?(coder: NSCoder)` 이니셜라이져가 있습니다.

```swift
override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
    super.init(style: style, reuseIdentifier: reuseIdentifier)
    ...
}
```

3️⃣ **일기장 추가 시 화면 전환 방식: push vs modal**
일기장 추가하는 화면을 전환하는 방식에 대해 고민했습니다.
일기장 목록을 보여주는 기존의 작업과 연결되는 작업이 아니라 새로운 작업을 잠시 수행한다고 생각해서 모달로 띄웠습니다.
이때, 기능요구서에 맞게 상단에 바를 추가하고 싶어서 새로운 네비게이션을 연결했습니다.

하지만 모달 방식으로 화면을 띄우게되면 네비게이션바의 left item을 직접 추가해주어야 하는 상황이 발생했습니다.

이를 해결하기위해 버튼을 구현하여 네비게이션의 left item에 추가해주었으나 기능요구서와 동일하게 만들기위해서는 버튼에 indicator이미지를 추가해주어야 하는 문제가 생겼습니다.

```
버튼에 사용된 이미지 이름 systemName: "chevron.left"
```
![](https://i.imgur.com/PANLzTv.png)

button 에 이미지를 넣기위해 UIButton을 extension 하여 convenience init, UIButton의 setImage(), setTitle() 를 활용해 문제를 해결하였습니다.

```swift
extension UIButton {
    enum SystemImage {
        static let indicator = "chevron.left"
    }
    
    convenience init(title: String?, imageName: String? = SystemImage.indicator) {
        self.init()
        self.setImage(UIImage(systemName: SystemImage.indicator), for: .normal)
        self.setTitle(title, for: .normal)
        self.titleLabel?.font = UIFont.systemFont(ofSize: 15, weight: .semibold)
        self.setTitleColor(.systemBlue, for: .normal)
    }
}
```

그후 일기장 프로젝트와 형태가 유사한 메모앱을 살펴보니 메모 추가 시 네비게이션 방식(push)으로 화면 전환이 되는 것을 확인하였고, 추가해야하는 기능중 일기장 수정 페이지(UI)를 구현할때는 네비게이션 방식으로 화면전환 하도록 결정하였습니다.

일기장 추가 페이지와 일기장 수정페이지의 UI가 동일하기 때문에 하나의 ViewController로 사용할수있도록 일기장 추가페이지 화면으로 전환하는 방법을 모달에서 네비게이션 방식으로 변경하였습니다.

네비게이션 방식으로 전환하게되면 자동으로 backButtonItem에 indicator이미지가 추가된 버튼이 생성되기 때문에 따로 버튼을 만들어 추가해주지 않아도되도록 수정하였습니다.

**모달 화면전환 방식의 코드**
```swift
let viewContoller = RegisterViewController(backButtonTitle: navigationItem.title)

// modal 방식이지만 navigationBar 를 사용하기위해 NavigationController의 rootView로 설정해준 코드
let navigationController = UINavigationController(rootViewController: viewContoller)
        
navigationController.modalPresentationStyle = .fullScreen
        
present(navigationController, animated: true)
```
**네비게이션 화면전환 방식의 코드**
```swift
let viewContoller = UpdateViewController()

navigationController?.pushViewController(viewContoller, animated: true)
```

4️⃣ **init vs loadView vs ViewDidLoad**
init은 프로퍼티의 값을 초기화할 때 사용합니다.
UpdateViewController 에서 이전 화면에서 받은 값을 통해 UI요소의 text를 초기화합니다.
```swift
init(diaryData: DiaryData? = nil) {
    super.init(nibName: nil, bundle: nil)
        
    setUpEditPage(diaryData: diaryData)
}
```
[loadView](https://developer.apple.com/documentation/uikit/uiviewcontroller/1621454-loadview)
loadView는 view Controller가 관리하는 view를 생성할 때 호출됩니다.
view 프로퍼티에 root view를 할당할 때 사용합니다.
super.loadView는 호출하지 않습니다.

[viewDidLoad](https://developer.apple.com/documentation/uikit/uiviewcontroller/1621495-viewdidload)
viewDidLoad는 뷰 컨트롤러가 메모리에 로드된 후 호출됩니다.
뷰에 대한 초기화를 진행합니다.
```swift
override func viewDidLoad() {
    super.viewDidLoad()
        
    setUpView()
    setUpNavigationController()
    setUpTableView()
    setUpTableViewLayout()
    setUpDataSource()
    setUpSampleData()
}
```



5️⃣ **범용적인 메서드**

* UIButton의 init에 title과 imageName을 매개변수로 받아서 다양한 버튼을 만들 수 있습니다.

```swift
convenience init(title: String?, imageName: String? = SystemImage.indicator)
```

* 셀의 식별자를 구현했습니다.
```swift
extension UITableViewCell {
    static var identifier: String {
        return String(describing: Self.self)
    }
}
```

* 아래방식으로 register를 구현하면 identifier 실별자 없이도 사용 가능합니다.
```swift
extension UITableView {
    func register<T: UITableViewCell>(_ type: T.Type)  {
        self.register(type, forCellReuseIdentifier: "\(type)")
    }
}

tableView.register(DiaryCell.self)
tableView.register(UITableViewCell.self)

//기존 방식
//tableView.register(DiaryCell.self, forCellReuseIdentifier: DiaryCell.identifier)
//tableView.register(UITableViewCell.self, forCellReuseIdentifier: UITableViewCell.identifier)
```

* 파일 이름을 가지고 데이터를 추출합니다. 메서드 호출 시 인스턴스 생성 없이 바로 사용하기 위해 static 메서드로 구현했습니다.
```swift
struct AssetManager {
    static func convert(fileName: String) -> Data? {
        guard let assetFile = NSDataAsset(name: fileName) else {
            return nil
        }
        
        return assetFile.data
    }
}
```

* Decodable을 채택한 타입을 JsonDecoder를 사용해서 데이터를 파싱합니다.
```swift
extension Decodable {
    static func parse(data: Data) -> [Self]? {
        guard let data = try? Json.shared.decode([Self].self, from: data) else {
            return nil
        }
        return data
    }
}

final class Json {
    static let shared = JSONDecoder()
    
    private init() { }
}
```

6️⃣ DateFormatter

* dateFormatter의 프로퍼티 세팅을 통해 앱 사용자의 위치에 맞게 시간을 표시합니다.
```swift
dateFormatter.dateStyle = .long
dateFormatter.locale = .autoupdatingCurrent
```
* Json 에서 Date 타입으로 파싱하기
    Json 데이터 파싱에 사용되는 데이터 타입의 프로퍼티가 Date인 경우에는 별도의 디코딩을 하지 않으면 Double 값으로 디코딩을 시도합니다. 이 덕분에 제공된 JSONFile에 작성된 double 데이터(timeIntervalSinceReferenceDate)를 별도의 처리 없이 Date로 파싱할 수 있었습니다.

* 시뮬레이터가 동작하는 지역을 바꾸려면 프로젝트의 세팅에서 Localization을 추가하고 시뮬레이터 세팅 앱에서 위치를 변경해야 합니다.

![](https://i.imgur.com/ueNvuq9.png)


## 질문한것들
1️⃣ **`UITableViewCell()` vs `tableView.dequeueReusableCell(withIdentifier: UITableViewCell.identifier, for: indexPath)`**

위 두 방식 모두 같은 결과를 시뮬레이터에서 보이는 것 같습니다.
cell 캐스팅 실패 시 UITableViewCell() 를 반환하는 것이 안전하지 고민했습니다.

거의 실패할 경우가 없기 때문에 전자로 구현해도 무방하다고 합니다.


2️⃣ **싱글턴 패턴을 사용할때 class vs struct 어떤것을 사용하는것이 좋을까요?**
상황마다 다를수 있겠지만 보통 어떤것을 사용하는지 궁금합니다!

아래의 타입들은 예를들어 parse 메서드를 호출하거나 DateFormatter를 사용할때마다 인스턴스가 생성되는것을 방지하기위해 인스턴스를 한번만 만들어 사용할수있도록 구현하였습니다.

구조체로 싱글톤을 만들 경우 값 타입이라서 공유되는 인스턴스가 수정되지 않는 문제가 생길 것 같습니다. 또, Formatter는 private으로 DateFormatter(Formatter타입이 아닌) 프로퍼티를 가져서 싱글톤으로 보긴 힘들것 같다는 생각이 들었습니다.

이처럼 싱글톤 처럼 타입을 구현할때 class와 struct를 선택하는 기준에 대해 고민했습니다.

주로 class로 사용해서 싱글톤을 만든다고 합니다.

Swift에서 싱글톤으로 사용하는 객체들을 보면 거의 class(URLSession, Notification 등등)를 사용하고 있습니다.

구조체로 만들어야할 경우에는 그냥 전역변수로 선언할 수 있을 것 같습니다.

```swift
class Json {
    static let shared = JSONDecoder()
    
    private init() { }
}

struct Formatter {
    static private let dateFormatter = DateFormatter()
    
    private init() { }
}
```

3️⃣ **ViewController들의 공통된 기능들을 중복제거 하는 방법🤔**

중복 코드 제거하는 방식으로 새로운 타입을 만들지, 추상 클래스를 만들지 고민했습니다. 아래 코드처럼 새로운 타입을 만들 경우 @objc 메서드를 인식하지 못해서 crash가 납니다.(NotificationCenter를 등록할때 문제가 발생합니다!)

위 문제는 `addObserver` 메서드에서 첫번째 매개변수에 selector 메서드가 구현된 위치, 즉 self를 넘겨줘서 해결했습니다.

- 추상 클래스를 상속받을 경우 자식 클래스만 봤을 때는 구현된 기능을 알기 어려운 것 같습니다.
- protocol extension 기본 구현하는 방식은 @objc 함수 때문에 불가능합니다.
- ViewController의 extension으로 분리하는 것은 실제로는 기능 분리가 되지 않아서 의미가 없다고 생각합니다.
- TextView나 TextView의 extension으로 분리 후 구현하는 방식과 새로운 타입을 만들어서 기능을 분리하는 방식은 내부 구현은 유사합니다. 전자의 경우 UITextView 대신에 커스텀 TextView를 이용해서 인스턴스를 생성합니다. 후자는 프로퍼티로 새로운 타입을 가져서 제일 명시적으로 구현된 기능을 표시할 수 있다고 생각합니다.

```swift
final class Keyboard {
    enum Const {
        static let keyboardBounds = "UIKeyboardBoundsUserInfoKey"
    }
    
    var bottomContraint: NSLayoutConstraint?
    
    func setUpKeyboardNotification() {
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(keyboardWillAppear),
                                               name: UIResponder.keyboardWillShowNotification,
                                               object: nil)
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(keyboardWillHide),
                                               name: UIResponder.keyboardWillHideNotification,
                                               object: nil)
    }
    
    @objc private func keyboardWillAppear(notification: Notification) {
        guard let keyboardBounds = notification.userInfo?[Const.keyboardBounds] as? NSValue else {
            return
        }
        
        bottomContraint?.constant = -keyboardBounds.cgRectValue.height
    }
    
    @objc private func keyboardWillHide() {
        bottomContraint?.constant = .zero
    }
}
```

---

## STEP 2 구현

## 고민했던 것들(트러블 슈팅)
1️⃣ **UI를 구현하기위한 sample데이터 관련 로직의 위치**

CoreData에서 데이터를 가져오기전 tableView를 구현하기위해 사용된 Asset에 저장된 sample데이터를 가져오는 로직을 어디서 관리해야할지 위치를 고민하였습니다.

추후 사용될 일이 없기때문에 ViewController를 최소화하기 위해 해당 로직을 Sample 타입을 만들어 분리하였으나 Asset을 관리하는 AssetManager타입에서 해당 기능을 수행하도록 수정하였습니다.

```swift
struct Sample {
    enum Const {
        static let sample = "sample"
    }
    
    static func get() -> [DiaryDTO]? {
        guard let assetData = AssetManager.convert(fileName: Const.sample) else {
            return nil
        }
        
        guard let diaryData = DiaryDTO.parse(data: assetData) else {
            return nil
        }
        
        return diaryData
    }
}
```
Sample 타입의 get() 메서드를 제네릭을 활용하여 Decodable을 채택하는 타입으로 반환하도록 수정하였습니다.

```swift
struct AssetManager {
    enum Const {
        static let sample = "sample"
    }
    
    private static func convert(fileName: String) -> Data? {
        guard let assetFile = NSDataAsset(name: fileName) else {
            return nil
        }
        
        return assetFile.data
    }
    
    static func get<T: Decodable>() -> [T]? {
           guard let assetData = AssetManager.convert(fileName: Const.sample) else {
               return nil
           }
           
           guard let diaryData = T.parse(data: assetData) else {
               return nil
           }
           
           return diaryData
       }
}
```
제네릭을 사용 하는 메서드(get메서드)의 호출
```swift
let sampleData: [DiaryDTO] = AssetManager.get()
```
상수나 변수에 타입 어노테이션을 사용하여 반환되는 타입을 추론할수있도록 타입을 명시해주면 된다!

2️⃣ **Keyboard타입과 KeyBoard를사용하는 주체 를 주입받는 방법** 

textView에서 사용되는 키보드관련 기능들은 KeyBoard타입 만들어 구현하였다.

textView에서 사용되는 키보드를 비활성화 하기 위해 SwipeGesture를 추가하기위해서는 KeyBoard를 사용하는 주체(ViewController, textView)를 알고있어야 해당 주체에 제스쳐를 추가해줄수 있게된다.

그렇다면 KeyBoard타입은 사용하는 주체를 알고있어야 하기때문에 프로퍼티로 가지고있어야한다고 생각했고 KeyBoard타입을 OOP 적으로 설계하기 위해 해당 프로퍼티를 은닉화하여 init()으로 주입받을지, 메서드를 사용해 주입받을지 고민하였습니다.

```swift
final class Keyboard {
    enum Const {
        static let keyboardBounds = "UIKeyboardBoundsUserInfoKey"
    }
    
    private let bottomContraint: NSLayoutConstraint?
    private let textView: UITextView?
    
    init(bottomContraint: NSLayoutConstraint, textView: UITextView) {
        self.textView = textView
        self.bottomContraint = bottomContraint
    }
```
KeyBoard타입을 초기화 할때 한번에 주입할수있도록 init()을 활용하였습니다.

3️⃣ **SceneDelegate에서 BackGround로 진입할 때 데이터를 저장하는 방법(Notification vs 델리게이트)**

백드라운드에서 진입할 때 SceneDelegate에 있는 sceneDidEnterBackground(_ scene: UIScene) 메서드가 호출됩니다.이때, 저장 메서드가 UpdateViewController 에 있어서 델리게이트를 사용해서 메서드를 호출합니다.
SceneDelegate에 프로퍼티를 선언하는 것이 단점이 될 수도 있다고 생각합니다.
반면, notification을 사용하는 경우는 UpdateViewController에 진입 후 계속 관찰해야해서 성능상으로 상대적으로 좋지 않을 것 같습니다. 또, 관찰 대상이 많을 경우 디버깅하기 어렵습니다.

```swift
class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    weak var delegate: BackGroundDelegate?
    
    func sceneDidEnterBackground(_ scene: UIScene) {
        delegate?.updateCoredata()
    }
 ...   
}

protocol BackGroundDelegate: AnyObject {
    func updateCoredata()
}

extension UpdateViewController: BackGroundDelegate {
    func updateCoredata() {
        saveData()
    }
}
```

4️⃣ **textView text에서 title 이랑 body 나누기**

UpdateViewController에서만 사용되는 extension이라서 private으로 구현했습니다.
`\n` 을 기준으로 나뉜 문자열에서 첫 문자열만 title로 설정하고 나머지는 body로 고려됩니다.
사용자가 body를 작성하지 않은 경우는 빈 문자열이 저장되도록 구현했습니다.
따라서, UpdateViewController는 별도의 프로퍼티 없이 textview의 데이터를 적절히 가져올 수 있습니다.
```swift
private extension UITextView {
    enum Const {
        static let separator: Character = "\n"
        static let defaultBody = ""
    }
    
    func extractData(date: String?) -> (
        title: String,
        body: String,
        date: Date
    )? {
        guard let date = date else {
            return nil
        }
        
        let splitedText = text.split(
            separator: Const.separator,
            maxSplits: 1
        ).map {
            String($0)
        }
        
        let body: String
        
        switch splitedText.count {
        case 1:
            body = Const.defaultBody
        case 2:
            guard let lastText = splitedText.last else {
                return nil
            }
            
            body = lastText
        default:
            return nil
        }
        
        guard let title = splitedText.first,
              let date = Formatter.getDate(from: date) else {
            return nil
        }
        
        return (title, body, date)
    }
}
```

삼항연사자와 nil 병합연산자가 상대적으로 성능이 좋지 않아서 사용을 지양하려고 했지만 가독성 측면에서 좋지 않아 둘 다 사용하기로 했습니다. 

```swift
var title: String? {
        let text = self.text.components(separatedBy: "\n")
        return text.first == "" ? nil : text.first
}
    
var body: String {
        let splitedText = self.text.split(separator: "\n", maxSplits: 1)
        let body = splitedText.map { String($0) }
        return body[safe: 1] ?? ""
}
```
위와 같이 연산프로퍼티를 통해 title과 body를 각각 전달할 수 있습니다. 이때, 접근할 때마다 text를 분리하는 단점이 존재합니다. 그렇지만, 가독성이 향상되어서 위 코드를 최종 수정에 반영했습니다.


5️⃣ **tableview 레이아웃 에러**

<img src="https://i.imgur.com/9HMBHuJ.png" width="500">

스토리보드에서 테스트해보니, 뷰 안에 레이블 넣으면 스토리보드에서 즉각적으로 높이 조절되지 않는 것을 확인했습니다. 레이블뷰가 스택뷰에 들어갈 때는 자동으로 높이 조절됩니다.

스택뷰는 intrinsic content size를 사용해서 높이를 자동으로 맞추는 것 같습니다. 반면, label을 view에 넣었을 때는 view가 스스로 높이 결정하지 못하는 것으로 보입니다.

위 에러는 테이블뷰 셀의 높이가 정해지지 않아서 발생한 문제라고 생각되어 아래 코드를 통해 해결했습니다.

<img src="https://i.imgur.com/gtIXMdN.png" width="300">

```swift
titleLabel.heightAnchor.constraint(equalTo: informationStackView.heightAnchor)
```

body가 들어가지 않는 경우 stackView에서 너비를 모호하다고 인식하는 레이아웃 에러가 생겼습니다. 이를 해결하기 위해서 아래와 같이 수정했습니다.
```swift
label.setContentHuggingPriority(
        .required,
        for: .horizontal
)
```

6️⃣ **코드 컨벤션**

[관련 링크](https://developer.apple.com/documentation/uikit/uiactivityitemsource/1620455-activityviewcontroller)
공식문서에서 매서드를 표기하는 방식과 동일하도록 컨벤션을 맞췄습니다.
매개변수가 1개 이상 들어가는 경우 줄바꿈을 했습니다.

이때, 가독성이 좋지 못하다고 느꼈습니다.
또한, 아래 공식문서의 예제 코드를 살펴보니 대부분의 경우는 개행 없이 코드 작성이 된 것을 확인했고 전반적인 코드 컨벤션을 줄바꿈을 덜 하도록 다시 수정했습니다.
[관련 링크](https://developer.apple.com/documentation/uikit/uitableviewdatasource)

7️⃣ **빌더 패턴을 적용한 alert**

다양한 형태의 alert을 구현하기 위해 빌더패턴을 사용해서 `AlertBuilder`을 구현했습니다.
설정할 값을 메서드 호출을 통해 세팅해서 간결하게 alertController를 만듭니다.
```swift
let alert = AlertBuilder()
            .setTitle("진짜요?")
            .setMessage("정말로 삭제하시겠어요?")
            .setType(.alert)
            .setAction(action)
            .build()
```

AlertBuilder() 인스턴스가 반복적으로 생성되는 것을 막기 위해 싱글톤 패턴을 적용해서 수정했습니다. 공통적으로 사용되는 인스턴스의 product 초기화가 필요해서 연산 프로퍼티를 활용해서 호출 시 새 product이 할당되도록 수정했습니다.

8️⃣ **범용적으로 사용할수있어야할까? vs 중복코드를 줄여야할까? 🫠**

기존에 사용하던 Alert관련 메서드는 구현되어있는 ViewController모두 사용하고있기때문에UIViewController를 extension하여 구현해두었습니다.

```swift
extension UIViewController {
  func showDeleteAlert(
          identifier: UUID?,
          handler: @escaping () -> Void
      ) {
          guard let identifier = identifier else {
              return
          }
  
          let action = UIAlertAction(
              title: "Delete",
              style: .destructive
          ) { _ in
              self.deleteHandler(identifier: identifier)
              handler()
          }
        
          let alert = AlertBuilder()
              .setTitle("진짜요?")
              .setMessage("정말로 삭제하시겠어요?")
              .setType(.alert)
              .setAction(action)
              .build()
        
          present(alert, animated: true)
      }
}
```
하지만 추후 새로운 ViewController를 구현했을때 showDeleteAlert() 메서드를 사용하지 않을경우 수정해야할 코드라고 생각되어 프로토콜을 사용하여 분리하였고 UIViewController를 상속받는 타입만 채택할수있도록 하여 present메서드도 프로토콜 내부에서 사용할수있도록 수정하였습니다.

```swift
protocol AlertProtocol: UIViewController {}

extension AlertProtocol {
    func showAlert(title: String, message: String, actions: [UIAlertAction]) {
        let alert = AlertBuilder.shared
            .setTitle(title)
            .setMessage(message)
            .setType(.alert)
            .setActions(actions)
            .build()
        
        present(alert, animated: true)
    }
}
```
하지만 이렇게 범용성있게 사용할수있도록 수정하여 사용하게될경우 Alert에서 사용될 action을 외부에서 정의해서 매개변수로 넣어주어야 합니다.

그렇게되면 Alert을 사용하는 ViewController 2곳에서 각각 액션을 정의해서 넣어주게되고 같은기능을 사용할경우 중복코드가 생기게됩니다.

하지만 이렇게 범용성있게 사용할수있도록 수정할경우 확장성에 좀더 용이하다고 판단되어 수정하였습니다.

최종적으로는 위와같이 수정하여 AlertProtocol을 채택하는 타입은 Alert을 사용할수있을거라 생각할수있게되고 자연스럽게 Alert과 관련된 메서드는 AlertProtocol에 정의되어있을것이라 생각할수있게됩니다.

9️⃣ **@objc 메서드**

selectro에서 사용되는 @objc 메서드에서 매개변수로 받을 수 있는 타입은 gesture 또는 sender에서 사용 가능한 UI 타입들(ex. UIButton) 입니다. 시스템에서 해당 메서드를 호출할 때 사용자 정의 타입은 넣을 수 없어서 메서드 구현에 제약이 많은 것 같습니다.

🔟 **tableView Cell의 swipe 액션에러**

테이블뷰의 Delegate메서드 trailingSwipeActionsConfigurationForRowAt() 를 사용하여
Alert을 띄우는 기능과 ActivityController를 띄우는 기능을 구현하였는데 Swipe 제스쳐를 사용한후 Delete 를 클릭후 cancel을 클릭하게될경우 Swipe가 해제되지 않는 버그가 발생했습니다.

![](https://i.imgur.com/NhOIH8p.gif)

```swift
    let delete = UIContextualAction(style: .destructive, title: "Delete") {
        [weak self] (_, _, completion) in
        self?.showAlert(title: "진짜요?",
                        message: "정말로 삭제 하시겠어요?",
                        actions: [cancelAction, deleteAction])
    }
            
    let share = UIContextualAction(style: .normal, title: "Share") {
        [weak self] (_, _, completion) in
        self?.showActivity(title: cellData.title)
    }
```
위의 코드에서 해당 작업이 끝났다는것을 알리기위해 completion(true) 코드를 추가하였습니다.
액션에 등록된 cancel버튼을 누르더라도 해당작업이 완료되도록 하여 문제를 해결했습니다.

```swift
    let delete = UIContextualAction(style: .destructive, title: "Delete") {
        [weak self] (_, _, completion) in
        self?.showAlert(title: "진짜요?",
                        message: "정말로 삭제 하시겠어요?",
                        actions: [cancelAction, deleteAction])
        completion(true)
    }
            
    let share = UIContextualAction(style: .normal, title: "Share") {
        [weak self] (_, _, completion) in
        self?.showActivity(title: cellData.title)
        completion(true)
    }
```

---
## 질문한것들
1️⃣ **파일 그룹화하는 방식**
파일을 쉽게 찾기 위해서 파일들을 묶는 방식에 대해 고민했습니다.
각 화면별로 그룹을 나누고 내부에서 사용되는 타입들을 구현 아키텍처에 맞게 MVC로 그룹화했습니다. 이때, AppDelegate, SceneDelegate를 Window라는 그룹에 넣었는데 더 좋은 그룹명이 있는지 궁금합니다.
또, Info, Diary, Asset, LaunchScreen은 어디에 그룹핑을 하는 것이 좋을지 고민입니다.

2️⃣ **삼항 연산자, nil 병합 연산자의 성능**
[관련 링크](https://code.iamseapy.com/archives/33)
삼함 연산자보다는 조건문이, nil 병합 연산자보다는 옵셔널 바인딩을 하는 것이 더 성능이 좋다고 하여 코드를 수정했습니다.

삼항 연산자와 nil 병합 연산자가 성능에 영향을 많이 주는지, 현업에서는 어떻게 사용되는지 궁금합니다!

3️⃣ **코어데이터 에러 처리**
CRUD 실패 시 에러를 어떻게 사용자에게 보여줄지 고민했습니다.
alert을 띄운다면 데이터 저장/수정 실패 시 백그라운에 진입해서 보여줄 수 없습니다. 또는 수정 페이지에서 이전화면(일기장 리스트화면)을 넘어가는 과정에서 저장/수정 실패 시 이전화면을 새로 띄우면서(일기장 리스트화면으로 돌아가는 것을 막으면서?) alert을 보이는 것이 이상하다고 생각했습니다. textView edit mode가 아닐 때 (`textViewDidEndEditing`매서드)의 저장/수정 실패 에러 처리만 가능할 것 같습니다.

코어데이터의 에러처리를 어떻게 하는 것이 좋을지 고민중입니다.😢

4️⃣ **메서드 역할 분리**
UpdateViewController에 있는 dataSave()의 경우 create와 update가 같이 사용해서 내부 로직이 뷰 컨에게 노출된 상태였습니다.

해당 뷰컨트롤러의 용도를 Mode 타입을 통해 구분하려면 특정 타입에서(DiaryViewcontroller와 UpdateViewController) 사용하도록 한정하는 것이 필요하다고 생각했습니다. 그러나 protocol을 통해 extension에서 기본구현을 사용해서 타입을 정의할 수 없습니다. 또, viewController의 추상클래스를 만들어서 두 뷰 컨트롤러가 상속받도록 하는 형식은 적절하지 않은 것 같습니다.
따라서, DiaryDAO.shared.save(data, isNew: true)와 같은 메서드를 통해 로직 자체를 viewController가 아닌 DiaryDAO에서 처리하도록 수정했습니다.
```swift
func save(_ newData: DiaryDTO?, isNew: Bool) {
        if isNew {
            create(userData: newData)
        } else {
            update(userData: newData)
        }
    }
```
위 메서드 구현으로 create, update 메서드를 은닉화할 수 있습니다.
