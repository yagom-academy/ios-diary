# 📓 일기장 프로젝트

- CoreData를 활용한 일기 작성 보관 앱입니다.

## 📖 목차
1. [팀 소개](#-팀-소개)
2. [기능 소개](#-기능-소개)
3. [Diagram](#-diagram)
4. [폴더 구조](#-폴더-구조)
5. [타임 라인](#-타임라인)  
6. [프로젝트에서 경험하고 배운 것](#-프로젝트에서-경험하고-배운-것)
7. [트러블 슈팅](#-트러블-슈팅)
8. [참고 링크](#-참고-링크)

## 🌱 팀 소개
 |[미니](https://github.com/leegyoungmin)|[Hamo](https://github.com/lxodud)|
 |:---:|:---:|
| <a href="https://github.com/leegyoungmin"><img height="150" src="https://i.imgur.com/pcJY2Gn.jpg"></a>| <a href="https://github.com/lxodud"><img height="150" src="https://i.imgur.com/ydRkDFq.jpg"></a>|

### 그라운드 룰
- **🙅‍♀️ 연락 불가능시간(회의 불가능 시간)**
    미니 : 월, 수 20:00 ~ 22:00(저녁 9시 이후에는 개인 공부시간)

- **🏃‍♀️ 프로젝트**
    오전 10시부터 6시까지 프로젝트 진행!!월, 목은 오전에 학습활동 공부 후, 17시 30분 부터 19시까지

- **📝 Git Commit Convention**
    **깃모지 사용**

    | 이모지 | 설명 |
    | :---: | :---: |
    | 🎉 | 프로젝트 시작 |
    | 💄 | UI 관련 업데이트 |
    | ✨ | 새로운 기능 추가 |
    | ♻️ | 코드 리팩토링 |
    | 🐛 | 버그 수정 |
    | 🧱 | 프로젝트 구조 변경 |
    | 📝 | 문서 변경 |

- **📢 학습 공유**
    프로젝트 시작 전 스크럼 하기스크럼 내용 : 오늘 하루 컨디션, 특이사항, 어제 학습한 내용 공유

- **🏃‍♀️운동 시간**
    오후 9시 팔굽혀펴기 100개 하기

## 🛠 기능 소개
|<img src="https://i.imgur.com/WHLc5YI.gif" width=180>|<img src="https://i.imgur.com/xt3uYMi.gif" width=180>|<img src="https://i.imgur.com/aL8XvXC.gif" width=180>|<img src="https://i.imgur.com/SvxnfhT.gif" width=180>|
|:-:|:-:|:-:|:-:|
|일기장 리스트 및 작성 화면|일기장 삭제|일기장 공유|지역화 설정 변경 시 화면|

## 👀 Diagram



## 🗂 폴더 구조
```bash
├── Resources
│   ├── AppDelegate.swift
│   ├── Assets.xcassets
│   ├── Base.lproj
│   ├── Diary.xcdatamodeld
│   ├── Info.plist
│   ├── SceneDelegate.swift
│   ├── en.lproj
│   │   └── Localizable.strings
│   └── ko.lproj
│       ├── LaunchScreen.strings
│       └── Localizable.strings
└── Sources
    ├── Controller
    │   ├── DiaryDetailViewController.swift
    │   └── DiaryListViewController.swift
    ├── CoreDataManager.swift
    ├── Extensions
    │   ├── Date+.swift
    │   ├── TimeInterval+.swift
    │   ├── UIAlertAction+.swift
    │   ├── UIAlertController+.swift
    │   ├── UIFont+.swift
    │   ├── UINavigationController+.swift
    │   ├── UINavigationItem+.swift
    │   └── UIView+.swift
    ├── Model
    │   ├── Diary.swift
    │   └── Utility
    │       ├── Constant.swift
    │       └── LocalizedConstant.swift
    └── View
        └── DiaryListViews
            ├── DiaryContentConfiguration.swift
            ├── DiaryListCell.swift
            └── DiaryListCellContentView.swift
```

## ⏰ 타임라인  
#### STEP 1
|날짜|구현 내용|
|--|--| 
|22.12.19|SwiftLint 적용, UITableViewDiffableDataSource 설정|
|22.12.20|DiaryContentConfiguration 구현, DateFormating 구현|
|22.12.21|DiaryWriteViewController 구현, 키보드 유무에 따른 동적인 레이아웃 구현, **PR 발송**|
|22.12.22|리뷰 피드백에 맞게 리팩토링(Observer remove, 메서드 기능에 맞게 내부 로직 분리)|
#### STEP 2
|날짜|구현 내용|
|--|--| 
|22.12.26|셀이 눌렸을 때 화면 전환, 셀 삭제 기능 구현, UIAlertController rngus|
|22.12.27|코어데이터 구현, 공유 기능 추가|
|22.12.28|전체적인 컨벤션 수정, 메서드 역할 분리, **PR 발송**|

## ✅ 프로젝트에서 경험하고 배운 것
- UITableViewDiffableDataSource
- DateFormatter를 통한 Localization
- scheme를 편집하여 시뮬레이터의 언어 및 지역 변경
- UIFontDescriptor
- UIContentConfiguration
- UISwipeActionsConfiguration
- UIContextualAction
- Core Data
- Singleton Pattern
- UIActivityViewController
- Localizable

## 🤔 고민한 점
### STEP 1
####  `Massive ViewController`에 대한 고민
`Apple`이 `ViewController`를 개발하는 과정에서 `View` + `Controller`의 개념으로 `ViewController`가 생성된 것으로 알고 있습니다. 이로 인해서 다양한 문제점들이 있지만, 저희가 맞닥들인 문제는 `ViewController`가 비대해진다는 문제였습니다. `ViewController`가 `View`의 전환, `DataSource`의 역할 등을 수행하면서 비대해지는 것을 느끼게 되었습니다. 이를 해결하기 위해서 궁금한 점들이 발생하였습니다.

- `ViewController`의 딜리게이트 메서드를 다른 타입으로 구현하여서 역할을 줄이는 방법을 사용하는 것도 방법이 될 수 있나요?
- `ViewController`가 화면을 전환하는 역할을 가지고 있는 것이 적절한지 궁금합니다.
- 만약, `ViewController`가 화면을 전환하는 역할을 가지고 있을 필요가 없다면, 다른 패턴을 활용하여서 구현하는 것도 괜찮을까요?
- MVC 패턴의 단점을 보완하기 위해서 다른 패턴들을 활용하는 방법 외 에는 Massive한 Controller를 변경할 수 있는 방법이 없나요?

위와 같은 고민들을 하게 되었지만, 아직 명확한 해답을 찾지는 못한 것 같다. 이에 대해서 추가적으로 공부하고 발전 시킬 것입니다.

### STEP 2
#### `CoreDataManager`의 구성

코어데이터 매니저를 구성하는 데 있어서 고민한 부분이 있었습니다. 앱 전역적으로 사용해야 하는 것이기 때문에 싱글턴을 사용해도 될까 라는 고민을 하게 되었습니다. 또한, 코어데이터 매니저에 대해서 유닛 테스트를 적용하는 것에 대해서도 고민하게 되었습니다. 

코어 데이터의 유닛 테스트를 진행하기 위해서는 In-Memory 특성을 가지는 PersistentContainer를 이용하여 Stub한 코어 데이터 매니저를 구현할 수 있어야 합니다. 즉, 코어 데이터 매니저를 싱글톤 패턴으로 구현하지 못하고, initalizer를 가지고 있어야 하는 상황이 발생한 것입니다. 위와 같이 트레이드 오프한 상황에 대처하기 위해서 각각의 장점을 표로 정리하고 함께 토론 하면서 어떤 점을 중점으로 앱을 개발하는 것이 중요한가에 대해서 함께 고민하였습니다.

| 싱글톤 | 유닛 테스트 |
| --- | --- |
| 앱이 전반적으로 코어 데이터에 접근할 수 있다. | 앱이 전반적으로 코어 데이터에 접근할 수는 없지만, 코드가 의도한 대로 동작하는 지 확인하기 용이하다. |

위와 같은 표에서 싱글톤을 사용하는 것이 더 좋은 장점을 가지고 있다고 판단하였습니다.

#### `UIContextualAction`의 `Completion`
SwipeAction을 구현하기 위해서는 UIContextualAction 타입을 구현해야 합니다. UIContextualAction타입은 사용자가 테이블 행을 스와이프할 때 표시할 동작으로 completionHandler를 가지고 있으며, 이를 통해서 액션이 정상적으로 동작하였는지에 대한 값을 반환해 주고 있습니다.
요구 사항에 따르면, 삭제 버튼을 누를 경우에는 다시 삭제에 대한 핸들러 내부에서 다음 동작을 할 수 있도록 구현하여야 합니다. 이에 대해서 많은 고민을 하게 되었습니다. 많은 컴플리션 핸들러를 통해서 코드의 가독성이 많이 떨어지기 때문입니다. 아래와 같이 completionHandler와 동일한 형식의 함수를 구성하고 그 내부에서 다음동작을 할 수 있도록 하였습니다. 또한, 많은 정보를 줄 수 없는 init를 대체하기 위해서 convenience init를 구성하고 이를 활용하여서 컴플리션 핸들러를 줄였습니다.

```swift
// before
let handler: UIContextualAction.Handler = { [weak self] _, _, handler in
    let alert = UIAlertController(
        title: NSLocalizedString("DeleteTitle", comment: "삭제 Alert 제목"),
        message: NSLocalizedString("DeleteMessage", comment: "삭제 Alert 본문"),
        preferredStyle: .alert
    )
    
	let deleteAction = UIAlertAction(type: .delete) { [weak self] _ in
	    guard let self = self else { return }
	    
	    let result = self.deleteSnapshot(item: item)
	    handler(result)
	}
            
    let cancelAction = UIAlertAction(type: .cancel) { [weak self] _ in
        handler(false)
    }
            
    alert.addAction(deleteAction)
    alert.addAction(cancelAction)            
    self?.present(alert, animated: true)
}
    
// after
let handler: UIContextualAction.Handler = { [weak self] _, _, handler in
    guard let self = self else { return }
    
    let alert = UIAlertController(
        title: LocalizedConstant.AlertController.deleteTitle,
        message: LocalizedConstant.AlertController.deleteMessage,
        diary: item,
        deleteCompletion: { [weak self] _ in
            guard let self = self else { return }
            
            let result = self.deleteSnapshot(item: item)
            handler(result)
        },
        cancelCompletion: { _ in
            handler(false)
        }
    )
    
    self.present(alert, animated: true)
}

```

#### 지역화에 맞춘 앱 구성시 앱의 상수를 관리하는 방법
앱에 대해서 지역화를 구성하기 위해서 각 문자열에 대해서 고민하게 되었습니다. 많은 NSLocalizedString 타입을 직접적인 문자열을 활용하여서 구성하는 것이 다른 코더가 보았을 때, 수정해도 되는 문자열이라고 착각할 수 있을 것 같다는 생각이 들었습니다. 그래서 앱 전체에서 사용되는 지역화된 문자열 상수를 LocalizedConstant 타입으로 묶어서 관리하였습니다. 그래서 다음과 같이 앱에 필요한 상수들을 한개의 enum타입에서 모두 관리할 수 있도록 하였습니다.

```swift
// before
let alert = UIAlertController(
    title: NSLocalizedString("DeleteTitle", comment: "삭제 Alert 제목"),
    message: NSLocalizedString("DeleteMessage", comment: "삭제 Alert 본문"),
    ...
```

```swift
// after
let alert = UIAlertController(
    title: LocalizedConstant.AlertController.deleteTitle,
    message: LocalizedConstant.AlertController.deleteMessage,
        ...
```

## 🚀 트러블 슈팅

### STEP 1
#### `UITableViewDiffableDataSource`를 왜 사용해야 하는가?
기존의 `DataSource`를 사용했을 때 삭제나 삽입 동작을 수행하였을 때 UI의 `truth`와 `DataSource`의 역할을 하는 컨트롤러의 `truth`가 일치하지 않아서 오류가 발생하기 쉽습니다. 또한, 사용자와의 상호작용하는 과정에서 `reloadData` 메서드를 자주 호출하게 됩니다. 위와 같은 행위들은 사용자의 UX를 손상시킬 수 있습니다. 다이어리 앱 같은 경우에는 사용자와의 상호작용이 많은 앱이라고 생각하였고, 위와 같은 문제들을 해결하기 위해서 `DiffableDataSource`를 활용하였습니다.

#### `Custom`한 `UIContentConfiguration`을 사용해야 하는가?
커스텀한 셀을 구현하기 위해서 클래스를 상속하여서 구현하게 되면, 새로운 데이터가 생성되거나 셀의 데이터를 변경될 때마다 셀을 다시 업데이트하도록 메서드를 통해서 업데이트 해야 합니다. 하지만, 업데이트를 위해서 메서드를 지속적으로 호출하는 것이 셀에게 데이터를 주는 것이라고 생각하였습니다. 추가적으로 사용자 이벤트에 대한 상태 변경을 더욱 쉽고 유연하게 할 수 있고, 데이터소스가 직접적으로 셀의 컨텐츠 뷰에 접근하지 않도록 할 수 있는 장점이 있어서 사용하게 되었습니다.

#### `UIView`의 `Constraint` 메서드가 길어지는 것
뷰의 `constraint`를 걸어주기 위한 보일러플레이트 코드가 지속적으로 발생하였습니다. 이에 대해서 줄일 수 있는 방법에 대해서 고민해보았습니다. `UIView`를 확장하여 하나의 메서드로 구현하였습니다.
```swift
func anchor(
    top: NSLayoutYAxisAnchor? = nil,
    leading: NSLayoutXAxisAnchor? = nil,
    bottom: NSLayoutYAxisAnchor? = nil,
    trailing: NSLayoutXAxisAnchor? = nil,
    paddingTop: CGFloat = 0,
    paddingLeading: CGFloat = 0,
    paddingBottom: CGFloat = 0,
    paddingTrailing: CGFloat = 0
) {
    if let top = top {
        topAnchor.constraint(equalTo: top, constant: paddingTop).isActive = true
    }
    
    if let leading = leading {
        leadingAnchor.constraint(equalTo: leading, constant: paddingLeading).isActive = true
    }
    
    if let bottom = bottom {
        bottomAnchor.constraint(equalTo: bottom, constant: -paddingBottom).isActive = true
    }
    
    if let trailing = trailing {
        trailingAnchor.constraint(equalTo: trailing, constant: -paddingTrailing).isActive = true
    }
}
```

#### 일기 작성 화면에서 제목 `TextField`와 본문 `TextView`의 `inset` 맞추기
`DiaryWriteViewController`의 `TextField` `TextView`의 텍스트가 시작하는 `inset`이 일치하지 않아서 둘을 일치시키는 방법에 대해서 고민하였습니다. `TextView`의 경우 `inputTextView`를 `textContainer`가 감싸고 있는 구조였고 `textContainer`의 `lineFragmentPadding`이라는 `text`의 `padding` 값을 담고있는 프로퍼티의 기본값이 5이기 때문에 일치하지 않은 문제가 있었습니다.
해당 프로퍼티를 0으로 할당하여 문제를 해결하였습니다.
    </details>

### STEP 2

#### 많은 `guard let`의 사용
`DiaryDetailViewController`에서 textField, textView의 text를 다루는데 해당 프로퍼티의 타입이 optional이기 때문에 각 메서드들에서 두 text프로퍼티를 옵셔널 바인딩하는 코드가 중복되어서 나타났습니다. textField와 textView에 아무런 입력이 없을 때 text 프로퍼티는 nil이 아닌 빈 문자열을 가지고 있기 때문에 UITextField와 UITextView를 extension하여 text의 옵셔널을 해제하여 리턴하는 프로퍼티를 정의하여 `DiaryDetailViewController`에서 중복되는 옵셔널 바인딩을 줄여보았습니다.

### 코어데이터의 Response와 앱에서 사용할 데이터의 분리
코어 데이터를 데이터 베이스와 동일한 측면으로 생각하게 되면, 네트워킹을 통해서 받아오는 원천 데이터로 생각하였습니다. 원천 데이터를 직접적으로 뷰에 보여주는 것을 적절하지 않고 의도치 않은 수정이 바로 반영이 될 수 있는 점에서 위험하다고 생각하였습니다. 그래서 코어 데이터를 통해서 받아오는 데이터를 가공하여서 뷰에 보여줄 데이터를 따로 구성하였습니다. 또한, 위와 같이 구성하면서 모든 타입이 옵셔널을 사용할 수 없도록 하였습니다.

## 🔗 참고 링크
[공식문서]
[Implementing Modern Collection Views](https://developer.apple.com/documentation/uikit/views_and_controls/collection_views/implementing_modern_collection_views)
[UITableViewDiffableDataSource](https://developer.apple.com/documentation/uikit/uitableviewdiffabledatasource)
[UISwipeActionsConfiguration](https://developer.apple.com/documentation/uikit/uiswipeactionsconfiguration)
[UIContextualAction](https://developer.apple.com/documentation/uikit/uicontextualaction)
[Core Data](https://developer.apple.com/documentation/coredata)

[WWDC]
[Modern Cell Configuration](https://developer.apple.com/videos/play/wwdc2020/10027/)
[Advances in UI Data Source](https://developer.apple.com/videos/play/wwdc2019/220)
