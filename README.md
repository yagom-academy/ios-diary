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
        ├── Common/
        │   ├── Constant.swift
        │   └── Error/
        │       └── DataError.swift
        ├── Uitilities/
        │   └── CoreDataManager.swift
        ├── Extension/
        │   ├── DateFormatter+extension.swift
        │   ├── Array+Extension.swift
        │   └── String+Extension.Swift
        ├── Models/
        │   ├── Diary+CoreDataClass.swift
        │   ├── Diary+CoreDataProperties.swift
        │   └── Diary.swift
        ├── Views/
        │   └── DiaryCell.swift
        └── Controllers/
            ├── DiaryListViewController.swift
            ├── AddDiaryViewController.swift
            ├── DiaryItemViewController.swift
            └── EditDiaryViewController.swift
```
## 📌 구현 내용
## 1. SceneDelegate
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

## 2. Model
### **DiaryData**
- STEP1의 `sample`데이터를 parse하기 위한 `DTO`클래스입니다.

### **Diary**
- CoreData 사용을 위한 CoreDataClass 및 프로퍼티 입니다.

## 3. Utilites
### CoreDataManager
- CoreData를 Manage 해주기 위한 Manager 역할을 합니다.
- 싱글톤으로 구현이 되어 있으며 appDelegate에 접근하여 context를 가져와 CRUD가 구현되어 있습니다.
```swift
class CoreDataManager {
    
    static var shared = CoreDataManager()
    
    private init() { }
    
    let appdelegate = UIApplication.shared.delegate as? AppDelegate

    lazy var context = appdelegate?.persistentContainer.viewContext
    
    let entityName = "Diary"
    ...
}

```
## 4. Controller
### DiaryListViewController
   - 다이어리 내용을 `TableView`로 보여주기 위한 `ViewController`입니다.

`TableView` 내부의 Cell의 크기가 유동적으로 바뀔 수 있도록 해주는 `UITableViewDelegate` 프로토콜의 `tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat`를 채택해 주었습니다.

```swift
func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    return UITableView.automaticDimension
}
```

### DiaryItemViewController
- 일기 작성과 일기 수정 컨트롤러 모두가 공유하는 부모 컨트롤러 입니다.
- CoreData에 Diary를 CRUD하는 로직이 담겨있습니다. 뒤로가기, 백그라운드 실행, keyboard hide시 저장하도록 manageCoreData를 트리거해 주었습니다.

```swift
@objc func manageCoreData() {
    if self.diary != nil {
        updateCoreData()
    }
}

func updateCoreData() {
    guard let diary,
    let text = contentTextView.text else { return }
        
    diary.text = text
        
    do {
        self.diary = try CoreDataManager.shared.updateDiary(updatedDiary: diary)
    } catch {
        print(error)
    }
}
```

- keyboard를 조정하여 쓰고 있는 화면이 가리지 않게 구현해 주었습니다. 로직은 NotificationCenter를 통해서 트리거 됩니다.
```swift
extension DiaryItemViewController {
    
    private func configureNotificationCenter() {
        NotificationCenter.default.addObserver(self, selector: #selector(self.adjustForKeyboard), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.adjustForKeyboard), name: UIResponder.keyboardWillHideNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.manageCoreData), name: UIApplication.willResignActiveNotification, object: nil)
    }
    
    @objc func adjustForKeyboard(notification: NSNotification) {
        guard let keyboardValue = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue else { return }
        let keyboardScreenEndFrame = keyboardValue.cgRectValue
        let keyboardViewEndFrame = view.convert(keyboardScreenEndFrame, from: view.window)
        
        if notification.name == UIResponder.keyboardWillHideNotification {
            contentTextView.contentInset = .zero
            manageCoreData()
        } else {
            contentTextView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: keyboardViewEndFrame.height - view.safeAreaInsets.bottom, right: 0)
        }
        
        contentTextView.verticalScrollIndicatorInsets = contentTextView.contentInset

        let selectedRange = contentTextView.selectedRange
        contentTextView.scrollRangeToVisible(selectedRange)
    }
}
```
- NavigationItem에 더보기 버튼을 추가하고, 버튼 클릭시 Alert 화면이 나오거나, ActivityView가 나오도록 구현해 주었습니다.
```swift
@objc func showActionSheet() {
    self.contentTextView.resignFirstResponder()
    let alert = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
    alert.addAction(UIAlertAction(title: Constant.share, style: .default, handler: showActivityViewController))
    alert.addAction(UIAlertAction(title: Constant.cancel, style: .cancel))
    alert.addAction(UIAlertAction(title: Constant.delete, style: .destructive, handler: showDeleteAlert))
    self.present(alert, animated: true, completion: nil)
}
```
### AddDiaryViewController
- 새로운 일기 작성을 위한 `ViewContoller`입니다.

- `DiaryItemViewController`의 대부분의 기능을 공유하며, configureNavigationItem만이 차이가 있어 override를 통해 구현합니다.

```swift
override func configureNavigationItem() {
    super.configureNavigationItem()
    let currentDate = DateFormatter.conversionLocalDate(date: Date(), locale: .current, dateStyle: .long)
    self.navigationItem.title = currentDate
}
```
### EditDiaryViewController
- `configureNavigationItem()` 및 `updateTexts()` 외에는 `DiaryItemViewController`와 동일한 로직을 가지고 있습니다. 
## 5. View
### DiaryCell
- `DiaryListViewController` - `UITableView`에 사용되는 `UITableViewCell`클래스입니다.
## 6. Extension
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

### Array+Extension
- `Array`타입의 index에 접근 시 범위를 벗어난 값이라면 `nil`을 리턴할 수 있도록 확장구현하였습니다.
```swift
extension Array {
    subscript (safe index: Int) -> Element? {
        return indices ~= index ? self[index] : nil
    }
}
```
### String+Extension
- 다이어리의 내용을 `title`, `content`로 변환하도록 `String`타입을 확장 구현하였습니다.
    - `Array`타입에서 확장구현한 서브스크립트를 사용하여 내용이 없는 글일 경우 빈 값을 반환하도록 처리하였습니다.
```swift
extension String {
    func sliceTitleAndContent() -> (String, String) {
        let title = self.components(separatedBy: "\n").filter { $0 != ""}.first ?? ""
        let content = self.components(separatedBy: "\n").filter { $0 != ""}[safe: 1] ?? ""
        return (title, content)
    }
}
```

## 📱 실행 화면
|가로 리스트| 가로 키보드 UpDown|
|:------------------------------------:|:------------------------------------:|
|![](https://i.imgur.com/w0ynlO9.gif)|![](https://i.imgur.com/FHdHKIL.gif)|
|**세로 리스트**| **세로 키보드 UpDown**|
|![](https://i.imgur.com/dHGPEpy.gif)|![](https://i.imgur.com/OoNG7uv.gif)|
|**리스트화면 셀 삭제**| **리스트화면 셀 공유**|
|![](https://i.imgur.com/Zw9Uu9U.gif)|![](https://i.imgur.com/UuTrpN1.gif)|
|**디테일화면 셀 삭제**| **디테일화면 셀 공유**|
|![](https://i.imgur.com/rO5gB6b.gif)|![](https://i.imgur.com/Xs5turz.gif)|
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
<details>
<summary>Step2 타임라인</summary>
<div markdown="1">       

- **2022.12.26**
    - Keyboard 관련 함수 내부 deprecated 프로퍼티 리팩토링 진행
    - 파일 정리 및 오타 수정, 네임 스페이스 처리
- **2022.12.27**
    - CoreData의 Diary 모델 생성
    - CoreData CRUD 구현 및 테스트 코드 작성
    - DataError 타입 추가
    - keyboard hide시, background 실행 시, view가 사라질 시 저장하도록 저장 구현
    - 상속 관계 정의를 위해 `DiaryItemViewController`를 만들고 `AddDiaryViewController`와 `EditViewController`가 상속할 수 있도록 구현
- **2022.12.28**
    - Array, String Extension을 추가하여 text를 Title과 Content로 구분할 수 있도록 구현
    - 코어데이터 구조 변경에 따른 코드 리팩토링 ( Title과 Content를 text 하나로 통합)
    - navigationItem에 더보기 버튼 추가 및 액션시트가 작동하도록 코드 작성, 삭제 기능 구현
    - ActivityViewController에 액티비티 뷰 추가하여 공유버튼 클릭시 공유 가능하도록 함.
    - Constant 분리로 String 타입 관리
</div>
</details>


## ❓ 트러블 슈팅 & 어려웠던 점
### 일기 데이터에 대한 코어데이터 타입
메모 앱을 참고하여, 일기의 제목과 내용에 대하여 어떻게 코어데이터에 저장할 것인가에 대해 고민해보았고, 각각의 장단점을 비교해 최종 채택을 하였습니다.
>~~1. 일기장을 작성하거나 수정하는 View에서 Title과 Content 두 부분을 기존과 같이 UITextField, UITextView 두 가지로 분류해서 진행하는 방법~~
>2. UITextView 하나로 진행하되, 코어데이터에 저장될 때는 제목, 내용의 값을 구분해서 저장하는 방법
>3. UITextView 하나로 진행하면서, 코어데이터에서 저장되는 데이터도 text타입 하나만 저장하고, ListView에서 제목과 내용에 대해 filter를 진행하여 하나의 text로 title과 content를 ListView에서만 표시해주는 방법

위 내용 중 2,3번 항목에 대해 장단점을 비교해 채택했습니다.

**2번 항목의 장점과 단점**
- 장점
    - 제목과 내용을 각각의 타입으로 저장하다보니 `Cell`에 별도의 작업 없이 보여줄 수 있다.
- 단점
    - 일기 내용의 첫번째 라인의 값이 제목 ➡️ 첫번째 라인이 빈 값인 경우 제목이 빈값이 된다.

**3번 항목의 장점과 단점**
- 장점
    - 메모 앱과 같이 도입부에 많은 줄바꿈이 있어도 필터링을 통해 값이 들어있는 첫번째 라인의 값을 제목, 두번째 라인의 값을 내용으로 사용할 수 있다.
- 단점
    - 일기 내용을 하나의 타입으로 저장하다 보니, `Cell`에 표시되는 제목과 타이틀을 나누는 작업이 필요하다.

일기의 내용으로 제목, 내용을 구분하기 위해 사용한 코드는 아래와 같습니다.
```swift
extension String {
    func sliceTitleAndContent() -> (String, String) {
        let title = self.components(separatedBy: "\n").filter { $0 != ""}.first ?? ""
        let content = self.components(separatedBy: "\n").filter { $0 != ""}[safe: 1] ?? ""
        return (title, content)
    }
}
```
위와 같은 로직을 사용할 때 만약, 일기의 내용이 한줄이라면 내용의 값이 빈 값이므로 필터되게 되는데, 이 경우 내용의 값에 접근하게 된다면 `index out of range`라는 런타임 에러가 발생하게 되어서 아래와 같이 Array 타입을 확장 구현하여 이 문제점을 해결했습니다.
```swift
extension Array {
    subscript (safe index: Int) -> Element? {
        return indices ~= index ? self[index] : nil
    }
}
```
아래는 두가지 항목에 대한 실행 화면입니다. 
|2번 -CoreData에서 2개의 타입(제목,내용)| 3번 - CoreData에서 1개의 타입|
|:------------------------------------:|:------------------------------------:|
|![](https://i.imgur.com/USP3O9C.gif)|![](https://i.imgur.com/gpPoIdy.gif)


---

## 📖 참고 링크

[Fixing the keyboard: NotificationCenter](https://www.hackingwithswift.com/read/19/7/fixing-the-keyboard-notificationcenter)

[UIAlertController](https://developer.apple.com/documentation/uikit/uialertcontroller)

[Verticalscrollindicatorinsets](https://developer.apple.com/documentation/uikit/uiscrollview/3198045-verticalscrollindicatorinsets)

[Setting Up CoreData Stack](https://developer.apple.com/documentation/coredata/setting_up_a_core_data_stack)

---

[🔝 맨 위로 이동하기](#일기장-)
