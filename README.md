# Diary ReadME

- Kyo와 Baem가 만든 Diary App입니다.

## 목차
1. [팀 소개](#팀-소개)
2. [GroundRule](#ground-rule)
3. [Code Convention](#code-convention)
4. [실행 화면](#실행-화면)
5. [Diagram](#diagram)
6. [폴더 구조](#폴더-구조)
7. [타임라인](#타임라인)
8. [기술적 도전](#기술적-도전)
9. [트러블 슈팅 및 고민](#트러블-슈팅-및-고민)
10. [참고 링크](#참고-링크)


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


## Diagram

### Class Diagram

Step2에서 공개예정

 
## 폴더 구조
```
Diary
├── AppDelegate.swift
├── SceneDelegate.swift
├── Assets.xcassets
│   ├── Contents.json
│   └── sample.dataset
│       ├── Contents.json
│       └── sample.json
├── MainViewController.swift
├── AddViewController.swift
├── Extensions
│   ├── Formatter+Extension.swift
│   └── UIComponent+Extension.swift
├── Models
│   ├── DecoderManager.swift
│   ├── Diary.swift
│   └── Error.swift
├── Views
|    ├── AddDiaryView.swift
|    ├── DiaryCollectionViewCell.swift
|    └── MainDiaryView.swift
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
  
  - Right Navigation Bar Buttond을 클릭했을 때 보여지는 `AddDiaryView`에 대한 `Controller`입니다.
  - 내부에서 `title`을 설정 언어에 맞는 날짜로 설정하였습니다.
  
3️⃣ DecodeManager
  
  - 임시데이터인 Json 데이터에 대한 `Decoder`와 decode관련 메서드를 정의한 구조체가 정의된 파일입니다.
    
4️⃣ Diary
  
  - 말 그대로 Diary에 대한 데이터이며, `Hashable`을 만족하기 위해 `uuid`를 추가하였습니다.

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


## 트러블 슈팅 및 고민

### 🔥 Keyboard 사용에 따른 AutoLayout Constraint 변경에 대한 고민

<details>
<summary> 
펼쳐보기
</summary>

**문제 👀**
- 저희는 키보드 사용에 따라 `TextView`의 제약조건을 변경하여 `TextView`가 키보드를 제외하고 보여지도록 했습니다. 하지만 `TextView`의 `Bottom`제약을 변경해주는 방식으로 구현했습니다.<br>
  <img width= 400px, src ="https://i.imgur.com/J4xs8tc.png"> <br>
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


## 참고 링크

[공식문서]    
- [Swift Language Guide - Closure - Escaping Closures](https://docs.swift.org/swift-book/LanguageGuide/Closures.html)
- [UICollectionView](https://developer.apple.com/documentation/uikit/uicollectionview/)
- [DateFormatter](https://developer.apple.com/documentation/foundation/dateformatter/)
- [Adaptivity and Layout](https://developer.apple.com/design/human-interface-guidelines/ios/visual-design/adaptivity-and-layout)
- [UITextView](https://developer.apple.com/documentation/uikit/uitextview)
