# 📒 일기장
> 프로젝트 기간 2022.06.13 ~ 2022.07.01  
팀원 : [malrang](https://github.com/malrang-malrang) [Tiana](https://github.com/Kim-TaeHyun-A) / 리뷰어 : [stevenkim](https://github.com/stevenkim18)

- [Ground Rules](#ground-rules)
- [실행화면](#실행화면)
- [STEP 1 구현](#step-1-구현)
    + [고민했던 것들(트러블 슈팅)](#고민했던-것들트러블-슈팅)
    + [질문한것들](#질문한것들)

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

