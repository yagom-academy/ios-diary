# Diary ReadME
- Kyo와 Baem가 만든 Diary App입니다.
- 텍스트 기능을 구현 할 때, 아이폰 `메모` 앱의 텍스트 입력 로직을 참고하였습니다.

## 목차
1. [팀 소개](#팀-소개)
2. [GroundRule](#ground-rule)
3. [Code Convention](#code-convention)
4. [실행 화면](#실행-화면)
5. [폴더 구조](#폴더-구조)
6. [타임라인](#타임라인)
7. [기술적 도전](#기술적-도전)
8. [트러블 슈팅 및 고민](#트러블-슈팅-및-고민)
9. [참고 링크](#참고-링크)


## 팀 소개
|[Kyo](https://github.com/KyoPak)|[Baem](https://github.com/Dylan-yoon)|
|:---:|:---:|
| <img width="180px" img style="border: 2px solid lightgray; border-radius: 90px;-moz-border-radius: 90px;-khtml-border-radius: 90px;-webkit-border-radius: 90px;" src= "https://user-images.githubusercontent.com/59204352/193524215-4f9636e8-1cdb-49f1-9a17-1e4fe8d76655.PNG" >|<img width="180px" img style="border: 2px solid lightgray; border-radius: 90px;-moz-border-radius: 90px;-khtml-border-radius: 90px;-webkit-border-radius: 90px;" src= https://i.imgur.com/jrW5RQj.png>|

## Ground Rule

[Ground Rule 바로가기](https://github.com/Dylan-yoon/ios-diary/wiki/GroundRule)

## Code Convention

[Code Convention 바로가기](https://github.com/Dylan-yoon/ios-diary/wiki/Code-Convention)

## 실행 화면

### ▶️ Step-1 실행화면

<details>
<summary> 
펼쳐보기
</summary>


|**실행화면**|**언어변경**|
|:---:|:---:|
|<img width = 600, src = "https://i.imgur.com/pItjW58.gif" >|<img width = 600, src = "https://i.imgur.com/ghHB03I.gif" >|

</details>

### ▶️ Step-2 실행화면

<details>
<summary> 
펼쳐보기
</summary>

|**미 입력**|**일기생성**|**Background 진입시 저장**|
|:---:|:---:|:---:|
|<img width = 600, src = https://i.imgur.com/JDS28lP.gif >|<img width = 600, src = https://i.imgur.com/U6RjgRR.gif>|<img width = 600, src = https://i.imgur.com/awPjF8d.gif>|
|**ActivityController구현**|**스와이프삭제**|**일기내에서 삭제**|
|<img width = 600, src = https://i.imgur.com/hgE4E9J.gif>|<img width = 600, src = https://i.imgur.com/eispxGL.gif>|<img width = 600, src = https://i.imgur.com/eVl3qBU.gif>|
    
</details>
 
## 폴더 구조
```
Diary
├── AppDelegate.swift
├── SceneDelegate.swift
├── DiaryData+CoreDataClass.swift
├── DiaryData+CoreDataProperties.swift
├── Info.plist
├── Controllers
│   ├── EditViewController.swift
│   └── MainViewController.swift
├── Diary.xcdatamodeld
│   └── Diary.xcdatamodel
│       └── contents
├── Extensions
│   ├── Formatter+Extension.swift
│   ├── NSMutableAttributedString+Extension.swift
│   ├── UIComponent+Extension.swift
│   └── UIViewController+Extension.swift
├── Models
│   ├── CoreData
│   │   └── CoreDataManager.swift
│   ├── DecoderManager.swift
│   └── Error.swift
└── Views
│       ├── CustomListCell.swift
│       ├── EditDiaryView.swift
│       └── MainDiaryView.swift
├── Podfile
├── Podfile.lock
└── README.md
```

##  타임라인
### 👟 Step 1

- ✅ Date Formatter의 지역 및 길이별 표현의 활용
- ✅ Text View의 활용
- ✅ Notification을 활용한 키보드 동작에 따른 View 제어
- ✅ Compositional Layout을 이용한 CollectionView 활용
- ✅ SwiftLint 적용

<details>
<summary> 
펼쳐보기
</summary>
    
1️⃣ MainViewController
- 앱 동작 시 가장 먼저 보여주는 View에 대한 `Controller`입니다.
- `MainViewController`에서 CollectionView의 DataSource로는 DiffableDataSource를 사용하였습니다.
    
2️⃣ AddViewController
- Right Navigation Bar Button을 클릭했을 때 보여지는 `AddDiaryView`에 대한 `Controller`입니다.
- 내부에서 `title`을 설정 언어에 맞는 날짜로 설정하였습니다.
    
3️⃣ DecodeManager
- 임시데이터인 Json 데이터에 대한 `Decoder`와 decode관련 메서드를 정의한 구조체가 정의된 파일입니다.
    
4️⃣ Diary
- 말 그대로 Diary에 대한 데이터이며, `Hashable`을 만족하기 위해 `uuid`를 추가하였습니다.

</details>

### 👟 Step 2

- ✅ 코어데이터 모델 생성
- ✅ Swipe를 통한 삭제기능 구현
- ✅ Swipe를 통한 공유기능 구현
- ✅ ActivityController 구현
- ✅ NSMutableAttributeString 활용
- ✅ UICollectionLayoutListConfiguration 활용
- ✅ Text View Delegate의 활용

<details>
<summary> 
펼쳐보기
</summary>
    
1️⃣ CoreDataManager
- CoreDataManager에서 CRUD를 구현하였습니다.
    - Create(Save)
    - Read(Fetch)
    - Update
    - Delete   
- 위 메서드들을 정의하여 CoreDataManager의 싱글톤 객체에서 호출할 수 있도록 구현하였습니다.

2️⃣ AddViewController ➡️ EditViewController
- Add, Modify하는 기능의 Controller을 하나의 Controller로 통합하였습니다.

    
3️⃣ EditDiaryView
- Add, Modify 화면을 하나의 View로 통합하였습니다.


</details>


## 기술적 도전

### ⚙️ ModernCollectionView - CompositionalLayout

<details>
<summary> 
펼쳐보기
</summary>
    
- 확장성을 위해 CollectionView를 사용하여 TableView를 구성하고자 하였습니다.
추후에 요구사항이 Grid 형으로 변경되어도 빠른 대응이 가능하다고 생각하였습니다
- 하지만 개발을 모두 마친 후, 개발 속도를 고려한다면 비교적 쉬운 TableView를 사용하는 것이 빠른 프로젝트 진행에 도움이 될것이라는 생각도 들었습니다.
- 향후 Step2에서 해당 부분은 UICollectionViewList 혹은 UITableView로 변경될 예정입니다.

</details> 

### ⚙️ DiffableDataSource
<details>
<summary> 
펼쳐보기
</summary>
- 기존의 DataSource를 경험해보고 새롭게 Diffable Data Source를 사용해보고자 하였습니다.
- DiffableDataSource의 장점은 데이터 동기화, 데이터 추가, 업데이트, 삭제시 Animate적용이 가능하다는 점 입니다. 
    또한 기존의 DataSource보다 코드량도 감소시킬수 있다는 점이 있습니다.
- 그리고 Section마다 다른 데이터들을 적용할 수도 있다는 점이 장점이라고 생각합니다.
- DiffableDataSource를 적용해보면서 코드의 길이가 길어지는 부분은 typealias를 활용하였습니다.
- 아직 Animation을 적용하는 부분이 많지 않아 기존 DataSource와 비교해서 장점에 대한 체감은 못하고 있습니다.
하지만 추후 Animation을 적용하는 부분이 많아진다면 Diffable DataSurce로 사용자 경험을 높힐 수 있다는 점은 큰 장점이라고 생각이 되어 도입해보았습니다.

    
</details> 

### ⚙️ DataFormatter, Locale의 사용
<details>
<summary> 
펼쳐보기
</summary>
    
- 새로운 Diary를 추가 할 때 지역에 맞는 날짜, 날짜 표기법을 수동적으로 선택해주는 것이 아닌 자동적으로 반환해주기 위해 DataFormatter를 추가해 주었습니다.
- 사용자의 기기 preferredLanguage에 따라 날짜의 표기방법이 자동으로 변경되도록 구현하였습니다.. (세계화, Internationalization)
- 사용자의 위치에 따라 날짜가 변할 수 있도록, `Locale`을 활용하여 Localization(지역화)를 해주었습니다.
    
``` swift
extension Formatter {
    static func changeCustomDate(_ date: Date) -> String {
        let locale = NSLocale.preferredLanguages.first
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: locale ?? Locale.current.identifier)
        formatter.timeZone = TimeZone(identifier: TimeZone.current.identifier)
        ...
        return formatter.string(from: date)
    }
}
```
    
</details> 

### ⚙️ Swipe 
<details>
<summary> 
펼쳐보기
</summary>
    
- 각 메인화면의 List의 Cell을 Swipe시 Share, Delete할 수 있는 기능이 필요하였습니다.
- Diary App에서 `UICollectionLayoutListConfiguration`를 사용하였기 때문에 `UISwipeActionsConfiguration`를 `configuration.trailingConfiguration`에 추가해주었습니다.
    
```swift
    var configuration = UICollectionLayoutListConfiguration(appearance: .plain)
        configuration.trailingSwipeActionsConfigurationProvider = .some({ indexPath in
            self.delegate?.makeSwipeActions(for: indexPath)
        })
```
- 그리고 ShareAction, DeleteAction을 추가 구현해주었습니다.
    
</details> 

### ⚙️ NSMutableAttributedString 사용 
<details>
<summary> 
펼쳐보기
</summary>

- `NSMutableAttributedString`은 문자열의 특정 부분에 원하는 속성을 주고 싶을 때 사용하는 객체입니다. 특정 문자열만 다른 폰트, 다른 Color을 부여할 수 있습니다.
- 하나의 TextView에서 첫줄(Title)의 Text과 그 이외의 Text를 다른 Font를 적용하고자 하였습니다.
- 현재 첫 문장을 입력 후 `"\n"`을 입력하면 첫문장의 폰트가 변경되도록 구현하였습니다.
- 하지만 이용자가 중간에 제목을 수정할 수 도 있는 상황과 개행을 하고 다시 입력하는 상황등 여러 유스케이스를 생각하며 로직을 보완하고 있습니다.
    
</details> 


## 트러블 슈팅 및 고민

### 🔥 Keyboard 사용에 따른 AutoLayout Constraint 변경에 대한 고민

<details>
<summary> 
펼쳐보기
</summary>

**문제 👀**
- 저희는 키보드 사용에 따라 `TextView`의 제약조건을 변경하여 `TextView`가 키보드를 제외하고 보여지도록 했습니다. 하지만 `TextView`의 `Bottom`제약을 변경해주는 방식으로 구현했습니다. 
    <img width= 400px, src ="https://i.imgur.com/J4xs8tc.png">
    위의 사진처럼 Constarint의 충돌이 일어났습니다.
**해결 🔥**
- `func setupConstraints()` 내부에서 초기 Constraint를 잡아 줄 때, TextView의 Bottom Constraint까지 잡아주고, 키보드 나타남에 따라 다시 제약을 추가적으로 잡아주기 때문에 발생했습니다.
- 따라서 기존 Constraint을 `false`로 변경하고 새로운 제약을 `true` 해야 충돌나지 않기 때문에 주의해서 Constraint를 잡아주어야 합니다.

</details>


### 🔥 UIComponent Object 생성시 중복코드 감소에 대한 고민

<details>
<summary> 
펼쳐보기
</summary>

**문제 👀**
- UIComponent를 View에서 생성할때 클로저를 이용하여 생성하였었습니다.
여러개의 Label, StackView가 필요한 상황에서 코드의 중복성이 느껴졌고 비효율적이라고 생각이 들었습니다. 
    
**해결 🔥**
- 2개 이상 사용되는 UIComponent들에 대해서 Extension으로 저희가 원하는 convenience initializer을 생성해주었습니다.
- 이렇게 구현의 결과 1개의 `UIComponent`를 생성할때, 기존보다 코드량이 1/5 줄로 감소하였습니다.

```swift
// Befor 
private lazy var bottomStackView: UIStackView = {
    let stackView = UIStackView(arrangedSubviews: [dateLabel, previewLabel])
    stackView.spacing = 5
    stackView.axis = .horizontal
    stackView.alignment = .center
    stackView.distribution = .fill
    return stackView
}()

// After
private lazy var bottomStackView = UIStackView(subview: [dateLabel, previewLabel],
                                            spacing: 5,
                                            axis: .horizontal,
                                            alignment: .firstBaseline,
                                            distribution: .fill)
```
    
</details>


### 🔥 Add, Modify 기능을 하나의 View, 하나의 Controller로 구현

<details>
<summary> 
펼쳐보기
</summary>
    
- Diary를 ADD하고, Modify하는 Controller의 역할과 View가 매우 유사하다고 생각을 했습니다.
- `MainViewController`에서 Modify를 할 때는 `indexPath`를 통해 데이터를 전달하고, + 버튼을 눌러 추가할때는 `nil`을 전달하여 Controller가 Add기능, Modify기능을 분기처리 할 수 있도록 구현하였습니다.
- 두 가지의 기능을 하나로 하였을 때의 장점은 로직은 추가되지만 전체적인 코드량 감소, 관리할 Class가 적어진다는 점이라고 생각이 듭니다.
- 하지만, 두 개의 컨트롤러를 사용하면 로직이 간결해진다는 점, 명확하다는 점에서 이점이 있다고 생각이 들었습니다. 
    
</details>


### 🔥 UISwipeActionsConfiguration 추가 


<details>
<summary> 
펼쳐보기
</summary>
    
- 리스트를 구현하기위해 `UICollectionLayoutListConfiguration`을 사용하였습니다.
- `CollectionView`의 `Configuration` 구성은 View의 역할이라고 생각이 되어 View 내부에 `CollectionView Configure`을 하는 메서드를 구현하였습니다.
- 후에, Swipe를 구현해야했을 때 View에서 구현한 Configure하는 메서드에서 SwipeActione들을 추가해주어야 했고, Swipe 기능을 만들기 위해서는 Controller의 Snapshot에 대한 접근, Delete Swipe 기능을 위한 CoreData에 대한 접근을 필요로 하였습니다.
- `ViewController`에서 `CollectionView` 혹은, `Configure`을 View 생성시점에 주입하는 방법도 좋겟다고 생각했지만, `Controller`의 역할에서 벗어난 기능을 수행한다고 판단하여 Delegate 패턴을 사용하여 `SwipeConfiguration`을 전달하였습니다.

    
</details>

### 🔥 NSMutableAttributedString 사용에 따른 TextView내부 텍스트 커서 이동

<details>
<summary> 
펼쳐보기
</summary>
    
- 처음에는 `textField`에 title을, `textView`에 body를 넣어주어 각각 해당하는 font를 사용하였습니다.
- 그렇기 때문에 Field, View 간의 간섭이 없기 때문에 폰트에 대해서 신경을 많이 써주지 않았습니다.
- 많은 생각 후, 우리는 아이폰 `메모`앱을 참고하여 사용을 고려하여, 하나의 `TextView`로 보여주고자 했습니다.
- 그렇기에 `NSMutableAttributedString`을 사용하여 첫번째 Title 부분만을 다른 폰트로 적용하였습니다.

#### 문제 👀
```
func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool { ... }
    
func textViewDidChange(_ textView: UITextView) { ... } 
```
- 텍스트 입력시 즉각적으로 Font 변경을 위해 위의 두 메서드를 사용하였는데,
- `NSMutableAttributedString` 이 호출될 때마다 `텍스트 커서`가 텍스트의 마지막에 위치하게 되었습니다.
    
#### 해결방법 🔥
- 현재 보완중입니다.
- textRange(from: to:) 및 UITextPosition()을 사용하여 해결이 가능하다 생각됩니다.
- 해결 후 추가작성하겠습니다.
    
</details>

## 참고 링크

[공식문서]    
- [Swift Language Guide - Closure - Escaping Closures](https://docs.swift.org/swift-book/LanguageGuide/Closures.html)
- [UICollectionView](https://developer.apple.com/documentation/uikit/uicollectionview/)
- [DateFormatter](https://developer.apple.com/documentation/foundation/dateformatter/)
- [Adaptivity and Layout](https://developer.apple.com/design/human-interface-guidelines/ios/visual-design/adaptivity-and-layout)
- [UITextView](https://developer.apple.com/documentation/uikit/uitextview)
- [Core Data](https://developer.apple.com/documentation/coredata)
- [Making Apps with Core Data](https://developer.apple.com/videos/play/wwdc2019/230/)
- [UITextViewDelegate](https://developer.apple.com/documentation/uikit/uitextviewdelegate)
- [UiSwipeactionsConfiguration](https://developer.apple.com/documentation/uikit/uiswipeactionsconfiguration)
