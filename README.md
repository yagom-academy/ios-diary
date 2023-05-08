# 일기장 📔
> CoreData, TextView를 활용해 사용자가 작성한 텍스트를 저장/공유하는 앱입니다.
> * 주요 개념: `UITextView`, `UITableView`, `Factory Pattern`, `Localization`
> 
> 프로젝트 기간: 2023.04.24 ~ 2023.05.12

### 💻 개발환경 및 라이브러리
<img src = "https://img.shields.io/badge/swift-5.8-orange"> <img src = "https://img.shields.io/badge/Minimum%20Deployment%20Target-14.0-blue">  <img src = "https://img.shields.io/badge/swiftLint-0.51.0-brightgreen"> 

## ⭐️ 팀원
| Rowan | Harry |
| :--------: |  :--------: |
| <Img src = "https://i.imgur.com/S1hlffJ.jpg"  height="200"/> |<img height="200" src="https://i.imgur.com/8pKgxIk.jpg">
| [Github Profile](https://github.com/Kyeongjun2) |[Github Profile](https://github.com/HarryHyeon) | 

</br>

## 📝 목차
1. [타임라인](#-타임라인)
2. [프로젝트 구조](#-프로젝트-구조)
3. [실행화면](#-실행화면)
4. [트러블 슈팅](#-트러블-슈팅)
5. [핵심경험](#-핵심경험)
6. [참고 링크](#-참고-링크)

</br>

# 📆 타임라인 
- 2023.04.24 : SwiftLint 적용
- 2023.04.25 : 일기장 목록 셀 구현, 일기장 목록화면 구현
- 2023.04.26 : 일기장 상세보기 화면 구현, 일기장 내용 편집 시, 뷰가 키보드에 가리지 않도록 하는 기능 구현
- 2023.04.27 : Alert Factory Pattern 구현, 코딩 컨벤션 리팩토링
- 2023.04.28 : README 작성, CoreData Entity 정의
- 2023.05.01 : CoreDataManager CRUD 정의, 일기장 생성 버튼을 누르면 CoreData에 새로운 데이터가 저장되도록 구현
- 2023.05.02 : 일기장 화면에서 편집이 종료될 경우 자동으로 CoreData에 업데이트하도록 구현
- 2023.05.03 : ActivityView, Diary 삭제 기능, TableViewCell swipe 구현
- 2023.05.04 : Factory 패턴 리팩토링, CoreData를 불러올때 날짜 내림차순으로 정렬 기능 추가
- 2023.05.05 : README 수정, CoreData 관련 코드 리팩토링 중

</br>

# 🌳 프로젝트 구조

## File Tree
```
└── Diary
    ├── App
    │   ├── AppDelegate
    │   └── SceneDelegate
    ├── Model
    │   └── DiarySample
    ├── View
    │   └── DiaryListCell
    ├── Controller
    │   ├── DiaryContentViewController
    │   └── DiaryListViewController
    ├── Utility
    │   ├── AlertFactory
    │   │   ├── AlertController
    │   │   │   ├── DiaryAlertMaker.swift
    │   │   │   └── DiaryAlertFactoryService.swift
    │   │   └── AlertData
    │   │       ├── ActionSheetViewData.swift
    │   │       ├── AlertViewData.swift
    │   │       ├── DiaryAlertDataService.swift
    │   │       └── DiaryAlertDataMaker.swift
    │   ├── DateFormatter+diaryForm.swift
    │   └── DiaryDecodeManager.swift
    ├── Resource
    │   ├── Assets
    │   └── LaunchScreen
    ├── CoreData
    │   ├── Diary+CoreDataClass
    │   ├── Diary+CoreDataProperties
    │   ├── Diary
    │   └── DiaryCoreDataManager
    └── Info.plist
```

# 📱 실행화면
<img src="https://i.imgur.com/N1dcUQE.gif" width="300">

<br/>

# 🚀 트러블 슈팅
## 1️⃣ TextView가 Keyboard에 가려지는 문제

### 🔍 문제점
이미 작성되어 있는 일기를 편집할 때 키보드가 올라오면서 텍스트뷰의 내용이 가려지는 문제가 발생했습니다. 또한, 일기를 계속해서 작성할 때 줄바꿈을 하면 키보드에 의해 텍스트뷰가 가려지는 문제점이 있었습니다.
  
### ⚒️ 해결방안
UIResponder에 이미 구현되어있는 keyboardWillShowNotification, keyboardWillHideNotification을 활용하여 키보드가 화면에 표시되기 직전, 사라지기 직전에 해당 Notification을 `DiaryContentViewController`가 받을 수 있도록 만들었습니다.

이후 다양한 문제해결 방법을 찾아보고 적절하다고 판단되는 방법으로 구현해봤습니다.

### RootView의 frame origin 조절하기(optional)

`view.frame.origin.y`를 keyboard의 높이에 맞게 이동시켜주는 방법이 있었습니다. 하지만 rootView의 frame을 옮기면 keyboard가 화면에 나타나있는 상태에서 최상단으로 스크롤 할 경우 text의 위쪽 부분이 keyboard의 높이만큼 잘리게 되기 때문에 부적절하다고 생각하여 채택하지 않았습니다.

### UIKeyboardLayoutGuide 활용하기(optional)

뷰컨트롤러 루트뷰에 있는 `keyboardLayoutGuide` 프로퍼티를 통해 텍스트뷰와의 제약관계를 설정해 간단하게 편집중인 텍스트가 가리지 않도록 할 수 있었습니다. (available iOS 15.0)

프로젝트의 minimum deployment를 올려야했기 때문에 이 방법을 채택하지는 않았습니다. 🤔

### 텍스트뷰의 contentInset 활용하기(select)

NotificationCenter를 이용하여 `UIResponder.keyboardWillShowNotification`과 `UIResponder.keyboardWillHideNotification` 이벤트가 발생할 때, 텍스트뷰의 contentInset을 설정해주었습니다.

텍스트뷰는 스크롤뷰를 상속하고 있어서 contentInset 프로퍼티를 활용할 수 있었고, 키보드의 크기를 계산해서 contentInset의 바텀을 키보드 높이로 할당하여 이 방법으로 편집중인 텍스트가 가려지지 않도록 해주었습니다.




</br>

# ✨ 핵심경험

<details>
    <summary><big>✅ Factory Pattern</big></summary>

<img src ="https://i.imgur.com/ma0jm3z.jpg" width="500">

이번 프로젝트의 `UIAlertController`, `AlertViewData` 타입의 인스턴스를 생성함에 있어 Factory Pattern을 활용했습니다.

Factory Pattern은 객체를 생성하기 위한 인터페이스를 정의하는데, 어떤 클래스의 인스턴스를 만들지는 서브클래스에서 결정하게 만듭니다. 즉 팩토리 메소드 패턴을 이용하면 클래스의 인스턴스를 만드는 일을 서브클래스에게 맡기는 것입니다.
    
**Product**
Creator 와 Creator의 서브 클래스에 의해 생성되는 클래스에게 공통적인 인터페이스를 제공합니다.

**Concrete Product**
Product가 선언한 인터페이스로 만든 실제 객체입니다.

**Creator**
Creator 클래스는 새 Product 클래스를 리턴하는 팩토리 메소드를 선언합니다. 이 리턴 타입은 Product 인터페이스와 일치해야합니다. 팩토리 메소드를 추상적(abstract)로 선언하여 모든 서브 클래스가 자체 메소드를 구현할 수 있습니다.

**Concrete Creators**(Factory)
Concrete Creators는 기본 팩토리 메소드를 재정의하여 다른 타입의 Product를 반환합니다.

### 프로젝트 적용
* Creator - `AlertFactoryService`, `AlertDataService`
* Concrete Creator - `AlertImplementation`, `AlertViewDataMaker`
* Concrete Product - `AlertViewData`, `UIAlertController`

위와 같은 타입으로 Factory Pattern 추상화/실체화를 적용했습니다.

</details>
 
<details>
    <summary><big>✅ SceneDelegate에서 최상단 뷰컨트롤러 얻기</big></summary>
    
SceneDelegate의 window 프로퍼티를 이용해 `rootViewController`(as UINavigationController) -> `topViewController`(as DiaryContentViewController) 순으로 최상위 뷰컨트롤러를 얻었습니다.

```swift
guard let navigationController = window?.rootViewController as? UINavigationController,
      let topViewController = navigationController.topViewController,
      let diaryContentViewController = topViewController as? DiaryContentViewController
else { return }
```
</details>

<details>
    <summary><big>✅ CoreData</big></summary>

# CoreData
    
## CoreData 저장 위치 관리 객체
CoreData를 활용하기 위해서는 먼저 CoreDataModel을 생성하고 **Core Data Stack**을 준비해야한다.

iOS 10 이전 버전에서는 NSPersistentContainer 클래스가 없었기 때문에 Core Data Stack을 구성하는 ManagedObjectModel, ManagedObjectContext, PersistentStoreCoordinator를 직접 설정해야 했지만 PersistentContainer의 등장으로 해당 과정이 캡슐화되었다.

ManagedObject를 PersistentStore에 저장하고, 해당 경로를 관리하는 객체는 `NSPersistentStoreCoordinator` 인스턴스이다.

<img src="https://i.imgur.com/tTftQrB.png" width="500">

- NSManagedObjectModel : 관리 객체 모델로 .xcdatamodeld 파일을 나타내는 프로그래밍적인 표현입니다.
    - 해당 타입의 인스턴스에 접근해 모델을 변경하거나 수정하는 등의 기능을 수행할 수 있다.
- NSManagedObjectContext : 관리 객체 컨텍스트로 관리 객체가 존재하는 영역입니다.
    - 앱에서 관리 객체의 생성, 삭제, 편집 등을 수행하기 위해 NSManagedObjectContext와 통신한다.
- NSPersistentStoreCoordinator : 모델을 사용하여 컨텍스트와 persistent store의 통신을 돕는 역할을 한다.
    - 실제 저장소와 object model을 연결하는 다리 역할을 합니다. NSManagedObjectContext의 요청에 대한 답을 주고, data에 대한 검증도 수행한다.

Persistent container는 인스턴스는 프로퍼티로 persistentStoreCoordinator를 가지고 있다. 해당 프로퍼티의 `setURL(_:for:)` 메서드로 저장소 위치를 특정할 수 있으며, 기본적으로 Application Support가 기본 위치로 되어있다.

</br>


    
</details>

---
    
</br>

# 📚 참고 링크

* [WWDC: MakingApps Adaptive, Part1](https://asciiwwdc.com/2016/sessions/222)
* [WWDC: MakingApps Adaptive, Part2](https://asciiwwdc.com/2016/sessions/233)
* [🍎Apple Docs - UITextView](https://developer.apple.com/documentation/uikit/uitextview)
* [🍎Apple Docs - UITextViewDelegate](https://developer.apple.com/documentation/uikit/uitextviewdelegate)
* [🍎Apple Docs - Adjusting Your Layout with Keyboard Layout Guide](https://developer.apple.com/documentation/uikit/keyboards_and_input/adjusting_your_layout_with_keyboard_layout_guide)
* [🍎Apple Docs - keyboardFrameEndUserInfoKey](https://developer.apple.com/documentation/uikit/uiresponder/1621578-keyboardframeenduserinfokey)
* [🍎Apple Docs - CoreData](https://developer.apple.com/documentation/coredata)
* [🍎Apple Docs - UISwipeActionsConfiguration](https://developer.apple.com/documentation/uikit/uiswipeactionsconfiguration)
* [🍎Apple Docs - UIContextualAction](https://developer.apple.com/documentation/uikit/uicontextualaction)
