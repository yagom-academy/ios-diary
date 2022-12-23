# 📓 일기장 프로젝트

- CoreData를 활용한 일기 작성 보관 앱입니다.

## 📖 목차
1. [팀 소개](#-팀-소개)
2. [기능 소개](#-기능-소개)
3. [Diagram](#-diagram)
4. [폴더 구조](#-폴더-구조)
5. [타임라인](#-타임라인)
6. [프로젝트에서 경험하고 배운 것](#-프로젝트에서-경험하고-배운-것)
7. [고민한 점](#-고민한-점)
8. [트러블 슈팅](#-트러블-슈팅)
9. [참고 링크](#-참고-링크)

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
|<img src="https://i.imgur.com/lozVwF0.gif" width=250>|
|:-:|
|일기장 리스트 및 작성 화면|

## 👀 Diagram


## 🗂 폴더 구조
```bash
├── Resources
│   ├── AppDelegate.swift
│   ├── Assets.xcassets
│   │   ├── AccentColor.colorset
│   │   │   └── Contents.json
│   │   ├── AppIcon.appiconset
│   │   │   └── Contents.json
│   │   ├── Contents.json
│   │   └── sample.dataset
│   │       ├── Contents.json
│   │       └── sample.json
│   ├── Base.lproj
│   │   └── LaunchScreen.storyboard
│   ├── Diary.xcdatamodeld
│   │   └── Diary.xcdatamodel
│   │       └── contents
│   ├── Info.plist
│   └── SceneDelegate.swift
└── Sources
    ├── Controller
    │   ├── DiaryListViewController.swift
    │   └── DiaryWriteViewController.swift
    ├── Extensions
    │   ├── Date+.swift
    │   ├── UIFont+.swift
    │   ├── UINavigationController+.swift
    │   ├── UINavigationItem+.swift
    │   └── UIView+.swift
    ├── Model
    │   └── Diary.swift
    └── View
        └── DiaryListViews
            ├── DiaryContentConfiguration.swift
            ├── DiaryListCell.swift
            └── DiaryListCellContentView.swift
```

## ⏰ 타임라인

|날짜|구현 내용|
|--|--| 
|22.12.19|SwiftLint 적용, UITableViewDiffableDataSource 설정|
|22.12.20|DiaryContentConfiguration 구현, DateFormating 구현|
|22.12.21|DiaryWriteViewController 구현, 키보드 유무에 따른 동적인 레이아웃 구현|
|22.12.22|리뷰 피드백에 맞게 리팩토링(Objserver remove, 메서드 기능에 맞게 내부 로직 분리)|

## ✅ 프로젝트에서 경험하고 배운 것
- UITableViewDiffableDataSource
- DateFormatter를 통한 Localization
- scheme를 편집하여 시뮬레이터의 언어 및 지역 변경
- UIFontDescriptor
- UIContentConfiguration

## 🤔 고민한 점

### Massive ViewController에 대한 고민
`Apple`이 `ViewController`를 개발하는 과정에서 `View` + `Controller`의 개념으로 `ViewController`가 생성된 것으로 알고 있습니다. 이로 인해서 다양한 문제점들이 있지만, 저희가 맞닥들인 문제는 `ViewController`가 비대해진다는 문제였습니다. `ViewController`가 `View`의 전환, `DataSource`의 역할 등을 수행하면서 비대해지는 것을 느끼게 되었습니다. 이를 해결하기 위해서 궁금한 점들이 발생하였습니다.

- `ViewController`의 딜리게이트 메서드를 다른 타입으로 구현하여서 역할을 줄이는 방법을 사용하는 것도 방법이 될 수 있나요?
- `ViewController`가 화면을 전환하는 역할을 가지고 있는 것이 적절한지 궁금합니다.
- 만약, `ViewController`가 화면을 전환하는 역할을 가지고 있을 필요가 없다면, 다른 패턴을 활용하여서 구현하는 것도 괜찮을까요?
- MVC 패턴의 단점을 보완하기 위해서 다른 패턴들을 활용하는 방법 외 에는 Massive한 Controller를 변경할 수 있는 방법이 없나요?

위와 같은 고민들을 하게 되었지만, 아직 명확한 해답을 찾지는 못한 것 같다. 이에 대해서 추가적으로 공부하고 발전 시킬 것입니다.

## 🚀 트러블 슈팅
### `UITableViewDiffableDataSource`를 왜 사용해야 하는가?
기존의 `DataSource`를 사용했을 때 삭제나 삽입 동작을 수행하였을 때 UI의 `truth`와 `DataSource`의 역할을 하는 컨트롤러의 `truth`가 일치하지 않아서 오류가 발생하기 쉽습니다. 또한, 사용자와의 상호작용하는 과정에서 `reloadData` 메서드를 자주 호출하게 됩니다. 위와 같은 행위들은 사용자의 UX를 손상시킬 수 있습니다. 다이어리 앱 같은 경우에는 사용자와의 상호작용이 많은 앱이라고 생각하였고, 위와 같은 문제들을 해결하기 위해서 `DiffableDataSource`를 활용하였습니다.

### `Custom`한 `UIContentConfiguration`을 사용해야 하는가?
커스텀한 셀을 구현하기 위해서 클래스를 상속하여서 구현하게 되면, 새로운 데이터가 생성되거나 셀의 데이터를 변경될 때마다 셀을 다시 업데이트하도록 메서드를 통해서 업데이트 해야 합니다. 하지만, 업데이트를 위해서 메서드를 지속적으로 호출하는 것이 셀에게 데이터를 주는 것이라고 생각하였습니다. 추가적으로 사용자 이벤트에 대한 상태 변경을 더욱 쉽고 유연하게 할 수 있고, 데이터소스가 직접적으로 셀의 컨텐츠 뷰에 접근하지 않도록 할 수 있는 장점이 있어서 사용하게 되었습니다.

### `UIView`의 `Constraint` 메서드가 길어지는 것
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

### 일기 작성 화면에서 제목 `TextField`와 본문 `TextView`의 `inset` 맞추기
`DiaryWriteViewController`의 `TextField` `TextView`의 텍스트가 시작하는 `inset`이 일치하지 않아서 둘을 일치시키는 방법에 대해서 고민하였습니다. `TextView`의 경우 `inputTextView`를 `textContainer`가 감싸고 있는 구조였고 `textContainer`의 `lineFragmentPadding`이라는 `text`의 `padding` 값을 담고있는 프로퍼티의 기본값이 5이기 때문에 일치하지 않은 문제가 있었습니다.
해당 프로퍼티를 0으로 할당하여 문제를 해결하였습니다.

## 🔗 참고 링크
[공식문서]  
[Implementing Modern Collection Views](https://developer.apple.com/documentation/uikit/views_and_controls/collection_views/implementing_modern_collection_views)  
[UITableViewDiffableDataSource](https://developer.apple.com/documentation/uikit/uitableviewdiffabledatasource)

[WWDC]  
[Modern Cell Configuration](https://developer.apple.com/videos/play/wwdc2020/10027/)
