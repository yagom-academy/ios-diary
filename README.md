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
    
<br>

## 💾 파일구조

### tree
```bash
.
├── Diary
│   ├── Info.plist
│   ├── Resource
│   │   ├── Assets.xcassets
│   │   └── Base.lproj
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

**STEP2 진행 후 추가 예정!**

<br>

## 💻 실행 화면

|<img src="https://i.imgur.com/p4gFTWY.png" width=250>|<img src="https://i.imgur.com/YNo9ZaV.gif" width=250>|<img src="https://i.imgur.com/X8GTu09.gif" width=250>|
|:-:|:-:|:-:|
|일기장 리스트 화면|일기장 작성 화면|키보드에 따른 화면 조정|

<br>

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


<br>

## 📚 참고 링크

[공식 문서]
- [Adaptivity and Layout](https://developer.apple.com/design/human-interface-guidelines/foundations/layout/) <br>
- [UIKit: Apps for Every Size and Shape](https://developer.apple.com/documentation/uikit/uicollectionview) <br>
- [DateFormatter](https://developer.apple.com/documentation/foundation/dateformatter) <br>
- [UITextView](https://developer.apple.com/documentation/uikit/uitextview) <br>

[WWDC]
- [Making Apps Adaptive, Part 1](https://www.youtube.com/watch?v=hLkqt2g-450) <br>
- [Making Apps Adaptive, Part 2](https://www.youtube.com/watch?v=s3utpBiRbB0w) <br>

[그 외 참고문서]
- [How to use DateFormatter in Swift](https://sarunw.com/posts/how-to-use-dateformatter/)
- [iOS에서 키보드에 동적인 스크롤뷰 만들기](https://seizze.github.io/2019/11/17/iOS%EC%97%90%EC%84%9C-%ED%82%A4%EB%B3%B4%EB%93%9C%EC%97%90-%EB%8F%99%EC%A0%81%EC%9D%B8-%EC%8A%A4%ED%81%AC%EB%A1%A4%EB%B7%B0-%EB%A7%8C%EB%93%A4%EA%B8%B0.html)
- [Private & FilePrivate](https://stackoverflow.com/questions/43503274/in-swift-3-is-there-a-difference-between-private-class-foo-and-fileprivate-c) <br>
