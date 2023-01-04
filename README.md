# 📔 일기장 📓

## 🗒︎ 목차
1. [소개](#-소개)
2. [개발환경 및 라이브러리](#-개발환경-및-라이브러리)
3. [팀원](#-팀원)
4. [타임라인](#-타임라인)
5. [파일구조](#-파일구조)
6. [UML](#-UML)
7. [실행화면](#-실행-화면)
8. [트러블 슈팅 및 고민](#-트러블-슈팅-및-고민)
9. [참고링크](#-참고-링크)

<br>

## 👋 소개

**UI를 코드로만 구성하여 메모기능을 구현한 일기장 프로젝트 입니다**
- 프로젝트 기간 : 22.12.23 ~ 23.01.06 (3주)

**[다뤄본 기술]**
- UI를 코드만으로 구성
    - AutoLayout
    - Naviation Controller
    - TableView
- SwiftLint 적용
- KeyBoard 사용시 KeyBoard가 텍스트를 가리지 않도록 구현
    - NotificationCenter & ContentInset
- Core Data
- UIActivityController

## 💻 개발환경 및 라이브러리
[![swift](https://img.shields.io/badge/swift-5.6-orange)]()
[![macOS](https://img.shields.io/badge/macOS_Deployment_Target-14.0-blue)]()

<br>

## 🧑 팀원
|Inho|Dragon|
|:---:|:---:|
|<img src=https://user-images.githubusercontent.com/71054048/188081997-a9ac5789-ddd6-4682-abb1-90d2722cf998.jpg width=200>|<img src = "https://i.imgur.com/LI25l3O.png" width=200 height=200>| 

<br>

## 🕖 타임라인

|날짜|구현 내용|
|--|--| 
|22.12.20|<`step1` 시작> `SwiftLint`적용, `Diary`, `CustomDiaryCell`, `MainViewController`, `MainDiaryVIew` , `SceneDelegate`을 이용한 네비게이션 구현|
|22.12.21|`DiarFormView`, `DiaryFormViewController`, 텍스트뷰의 `contentInset`조정|
|22.12.23|뷰컨트롤러에 주석 추가 및 `prepareForReuse`메서드 구현|
|22.12.27|<`step2` 시작> `CoreData` 엔티티 생성 및 `create, read, update`메서드 구현, 백그라운드 진입시 `sceneDelegate`을 통한 자동 저장기능 구현|
|22.12.28|`AletControllerManager`, `ActivityControllerManager`구현, `CoreDataProcessible`프로토콜 생성 및 `delete`메서드 구현, 각 화면에서의 알럿 후 삭제기능 구현,일기가 두 번 저장되는 버그 수정 |
|22.12.29|주석(`MARK`)수정 및 일기 생성 조건 수정|
    
<br>

## 💾 파일구조

### tree
```bash
.
├── Diary
│   ├── Diary.xcdatamodeld
│   ├── Info.plist
│   ├── Resource
│   │   ├── Assets.xcassets
│   │   ├── Base.lproj
│   │   │   └── LaunchScreen.storyboard
│   │   ├── Entity+CoreDataClass.swift
│   │   └── Entity+CoreDataProperties.swift
│   └── Source
│       ├── App
│       │   ├── AppDelegate.swift
│       │   └── SceneDelegate.swift
│       ├── Controller
│       │   ├── DiaryFormViewController.swift
│       │   └── MainViewController.swift
│       ├── Extension
│       │   └── DateFormatter + Extension.swift
│       ├── Model
│       │   ├── ActivityControllerManager.swift
│       │   ├── AlertControllerManager.swift
│       │   ├── CoreDataProcessable.swift
│       │   └── Diary.swift
│       └── View
│           ├── Base.lproj
│           │   └── Main.storyboard
│           ├── CustomDiaryCell.swift
│           ├── DiaryFormView.swift
│           └── MainDiaryView.swift
└── README.md

```
<br>

## 📊 UML

|<img src=https://i.imgur.com/uI6sKwA.png width=700>|
|--|

<br>

## 💻 실행 화면

|<img src="https://i.imgur.com/dBNxcvt.gif" width=250>|<img src="https://i.imgur.com/qXj9d7e.gif" width=250>|<img src="https://i.imgur.com/fHHCvp7.gif" width=250>|
|:-:|:-:|:-:|
|일기 저장기능|일기 업데이트 기능|스와이프 기능|

|<img src="https://i.imgur.com/rOEWQKY.gif" width=250>|<img src="https://i.imgur.com/end0ZaQ.gif" width=250>|<img src="https://i.imgur.com/OSXwaIH.gif" width=250>|
|:-:|:-:|:-:|
|일기 삭제 기능|일기 공유 기능|제목&본문 구분 기능|

## 🎯 트러블 슈팅 및 고민

- **`DateFormatter`를 재사용하는 방법**

    - `DateFormatter`를 사용하려고 찾아보던 중에 해당 객체가 사용할때 비용이 많이 들어서 효율적으로 사용하는 방법을 적용했습니다.
    - 타입 프로퍼티로 저희 코드에 사용될 한글형식으로 날짜를 나타내는 `koreanDateFormatter`를 구현하여, 한번만 인스턴스를 만들고 그 뒤에 재사용하는 식으로 구현하였습니다.

- **일기장 추가 화면 및 편집 화면의 구성 방법**

    - 일기장 앱의 화면 중에 +버튼을 눌렀을때 보이는 추가 화면과, 기존의 일기장 목록을 눌러 편집할때의 화면 구성이 동일하다고 판단하였습니다. 
    - 그래서 일기를 입력하는 양식을 나타내는 `DiaryFormView`와 해당 뷰를 담는 `DiaryFormViewController`를 구현하였고, 추후에는 두 클래스를 재사용하는 방식으로 구현할 예정입니다.
        - 재사용을 위해 구현하다보니 두 클래스의 네이밍이 포괄적으로 작성되어서, 이런 모호성은 추후에 일기장 수정 화면을 구현할때 구체적인 네이밍으로 변경하거나, 분리하여 구현하도록 수정될 수도 있을것 같습니다!

- **일기장 추가 화면시 화면 전환 방법**
    - 일기를 추가하기 위해 +버튼을 눌렀을때 모달 형식으로 화면이 전환되어야 한다고 생각했습니다. 
    - 그런데 애플의 기본 메모장 앱을 참고해 보니, 새로운 메모를 작성할때 push로 화면이 전횐되는걸 확인할 수 있었습니다.
    - 결과적으로 저희도 같은 방식인 push로 화면을 전환하도록 구현하였습니다.
        - 기본앱에서 그렇게 구현되어 있는 이유를 고민했을때, 기존의 메모를 수정하는것과 새로 작성하는 기능이 동일하여 전체 로직과 비슷한 화면을 보여주기 때문이라고 생각하였습니다.🤔

- **Private & FilePrivate**
    - `MainViewController`안에 열거형 `NameSpace`를 작성하여 접근제어를 설정하는 과정에서 `fileprivate`를 사용하였는데, `Swiftlint` 에러메세지로 `private`를 사용 권장메세지가 띄워지는것을 확인하였습니다.
    - `fileprivate`는 같은파일.swift안에서 접근 가능한 것으로 알고 있고 `private`는 {}괄호 안에서 접근 가능한 것으로 알고 있었는데, 열거형 `NameSpace`는 `private`로 설정해주어도 같은파일.swift에서 접근이 가능하여 동작에 이상이 없는 것을 확인하였습니다.
        - 그런데 왜 정상적으로 동작이 되는지 이해가 되지않아 찾아본 결과, `Top Level File`내에서는 `private` = `fileprivate`와 동일 기능을 한다는 것을 알게 되었습니다.

- **`DiaryFormViewController`의 재사용 방법**
    - 일기 생성 및 편집의 화면 구성이 완전히 동일하여 지난 스텝에서 구현한 `DiaryFormViewController`를 재사용하는 방법을 고민하였습니다.
    - 두가지를 구분하는 기준은 테이블뷰의 셀에서 선택되어 넘어왔는지, +버튼이 눌려 넘어왔는지 였고, 이는 해당 뷰컨이 `Diary`를 가지고 있는가 없는가의 차이라고 생각하여 커스텀 이니셜라이저와 옵셔널 프로퍼티를 이용해 구분해주었습니다.

    ```swift
    final class DiaryFormViewController: UIViewController {
        // MARK: Properties
        private var selectedDiary: Diary?

        // MARK: Initializer
        init(diary: Diary? = nil) {
            selectedDiary = diary
        }
    }
    ```
    - 셀이 선택되었을때는 해당 셀의 `Diary`를 넘겨주어 초기화하고, +버튼이 눌렸을때는 `nil`값으로 초기화하는 구조입니다.
- **`Alert`를 생성하는 객체 활용 방법**
    - 일기의 공유/삭제 및 삭제 알림을 보여주는 `AlertController`를 생성하기 위해 ``AlertControllerManager``객체를 구현하였습니다.
    - `VC`에서 `AlertControlManager`를 어떻게 활용시킬지 아래 두가지의 방법을 생각해보았습니다.
    - 첫번째, 메서드에서 `UIAlertController`을 `return`하여 `VC`에서 사용하는 방법
    - 두번째, `AlertControlManager`에 작성된 메서드의 파라미터에 `VC`을 전달하여 `VC`에서는 `self`키워드를 통해 `AlertControlManager`를 활용하는 방법
    - 위 두가지 방법 중 **최종적으로 첫번째 방법을 사용**하였고, 그 이유는 `VC`에서 `self`키워드를 통한 `Model`접근은 좋지 않다고 판단하였습니다.

- **`Alert -> Alert -> Action` 동작을 구현하는 방법**
    - 고민되었던 부분은 액션시트에서 삭제를 누르고 -> 삭제 알럿을 보여주고 -> 데이터 삭제 후 이전화면으로 전환하는 기능을 구현하는 것이었습니다. 
    - 뷰컨에 있는 데이터 삭제 메서드와 화면전환 기능을 수행하기 위해 이스케이핑 클로저를 전달하여 이를 해결하였습니다.
    ```swift
    struct AlertControllerManager {
        func createActionSheet(_ shareHandler: @escaping () -> Void,
                               _ deleteHandler: @escaping () -> Void) -> UIAlertController {
            ...
            let deleteAction = UIAlertAction(title: NameSpace.deleteTitle, style: .destructive) { _ in
                deleteHandler()
            }
            ...
    }
    //뷰컨에서 전달하는 핸들러   
    @objc private func showActionSheet() {
         present(alertControllerManager.createActionSheet(: ,: showDeleteAlert),
                ...
    }

    private func showDeleteAlert() {
        ...
        present(alertControllerManager.createDeleteAlert({
            self.deleteCoreData(diary: diary)
            self.navigationController?.popViewController(animated: true)
        }), animated: true)
    }
    ```
    - `AlertControllerManager`의 메서드가 `AlertController`를 리턴하는 이유는 스스로 `present`할 수 없기 때문입니다.

- **액션 만드는 구조체 내의 기능 분리**
    - `Alert`을 관리하는 `AlertControlManager`에서 `Alert을 생성해주는 메서드`가 유연하지 못한 구조로 작성되어있습니다.
    - 고정된 `Alert`만을 생성할 수 있는 메서드인데, 이것을 해결하고자 `Action`을 생성하는 메서드 분리를 시도 해보았지만 `Alert - Alert - Action`으로 구성된 동작을 수행하기 위해 `@escaping`을 사용하게 되어, 기능분리가 오히려 복잡하게 구현되어 기존 상태를 유지하였습니다.
    - 프로젝트 일정상 해결하지 못하였지만, `@escaping`을 사용하게 되면 `유연한 Alert생성`이 어렵다는 것을 알게 되었습니다...🥲

- **`CoreDataProcessible`프로토콜 구현을 통한 `CoreData`메서드 분리**
    - `CoreData` 사용을 어떤 방식으로 해줘야할지 고민하다가 CRUD기능을 `Protocol+Extension`으로 묶어서 `CoreData`를 사용하고자하는 뷰컨은 프로토콜 채택을 통해 기능활성화를 할 수 있도록 구현하였습니다.
    - CRUD를 모두 묶어서 하나의 `Protocol`로 두어도 되는 것인지 아니면 각각 기능에 따라 `Protocol`을 나눠줘야하는 것인지 고민이 되었습니다.
    - 고민해본 결과 전체를 묶어 놓아야 활용성이 간단해지고, `CoreData`를 사용하게되면 CRUD는 반드시 필요한 기능이라고 생각되어 전체로 묶어서 사용하였습니다.

- **`UIActivityViewController`활용 방법**
    - 프로젝트의 요구사항을 구현하기 위해 `ActivityControllerManager`를 생성하고 액티비티 뷰를 보여줍니다.
    - 그 중 공유할 내용을 나타내는 `activityItems`에는 일기를 공유한다고 생각하여, 일기 전체 텍스트를 나타내는 `diary.totalText`를 공유하도록 구현했습니다.
    - 액티비티에 `excludedActivityTypes`을 통해 제외할 사항을 지정할 수 있었는데, 이는 현업에서 기획과 관련되어 있을거라 판단하여 제외 사항을 포함하지는 않았습니다. 

<br>

## 📚 참고 링크

[공식 문서]
- [Adaptivity and Layout](https://developer.apple.com/design/human-interface-guidelines/foundations/layout/) <br>
- [UIKit: Apps for Every Size and Shape](https://developer.apple.com/documentation/uikit/uicollectionview) <br>
- [DateFormatter](https://developer.apple.com/documentation/foundation/dateformatter) <br>
- [UITextView](https://developer.apple.com/documentation/uikit/uitextview) <br>
- [Core Data](https://developer.apple.com/documentation/coredata) <br>
- [UITextViewDelegate](https://developer.apple.com/documentation/uikit/uitextviewdelegate) <br>
- [UISwipeActionsConfiguration](https://developer.apple.com/documentation/uikit/uiswipeactionsconfiguration) <br>

[WWDC]
- [Making Apps Adaptive, Part 1](https://www.youtube.com/watch?v=hLkqt2g-450) <br>
- [Making Apps Adaptive, Part 2](https://www.youtube.com/watch?v=s3utpBiRbB0w) <br>
- [Making Apps with Core Data](https://developer.apple.com/videos/play/wwdc2019/230/) <br>

[그 외 참고문서]
- [How to use DateFormatter in Swift](https://sarunw.com/posts/how-to-use-dateformatter/) <br>
- [iOS에서 키보드에 동적인 스크롤뷰 만들기](https://seizze.github.io/2019/11/17/iOS%EC%97%90%EC%84%9C-%ED%82%A4%EB%B3%B4%EB%93%9C%EC%97%90-%EB%8F%99%EC%A0%81%EC%9D%B8-%EC%8A%A4%ED%81%AC%EB%A1%A4%EB%B7%B0-%EB%A7%8C%EB%93%A4%EA%B8%B0.html) <br>
- [Private & FilePrivate](https://stackoverflow.com/questions/43503274/in-swift-3-is-there-a-difference-between-private-class-foo-and-fileprivate-c) <br>
- [CoreData 다루는 방법](http://yoonbumtae.com/?p=3865) <br>
