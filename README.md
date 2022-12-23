# 📔 Diary 📔

> 프로젝트 기간: 2022-12-19 ~ 2023-01-06 (3주)

## 🗒︎목차

1. [소개](#-소개)
2. [개발환경 및 라이브러리](#-개발환경-및-라이브러리)
3. [팀원](#-팀원)
4. [타임라인](#-타임라인)
5. [파일구조](#-파일구조)
6. [UML](#-uml)
7. [실행화면](#-실행-화면)
8. [트러블 슈팅 및 고민](#-트러블-슈팅-및-고민)
9. [참고링크](#-참고-링크)

---

## 👋 소개

- JSON 데이터로 주어진 일기를 리스트 형태로 보여주고, 새로운 일기 작성 화면을 지원하는 다이어리 앱입니다.
- 새로운 일기를 생성하는 화면에서는 사용자가 입력한 콘텐츠의 크기와 키보드의 화면 표시 여부에 따라 `textView`의 크기가 동적으로 조정됩니다.
- 사용자의 언어 설정에 따라 날짜 표기 형식이 바뀝니다.
- `UITableView`, `AutoLayout/AutoResizing` 개념을 활용해 진행되었습니다.

---

## 💻 개발환경 및 라이브러리

[![swift](https://img.shields.io/badge/swift-5.6-orange)]() [![iOS](https://img.shields.io/badge/iOS_Deployment_Target-15.2-blue)]() [![SwiftLint](https://img.shields.io/badge/SwiftLint-0.50-green)]()

---

## 🧑 팀원

|[SummerCat](https://github.com/dev-summer)|[som](https://github.com/jsa0224)|
|:---:|:---:|
|<img src=https://i.imgur.com/TVKv7PD.png width="200" height="200" >|<img src = "https://i.imgur.com/eSlMmiI.png" width=200 height=200>|

---

## 🕖 타임라인

### STEP-1
- **2022/12/20**
  - `DiaryForm` 데이터 타입 구현 [![feat](https://img.shields.io/badge/feat-green)]()
  - `DiaryListVC`, `RegisterVC`, `DiaryListTableViewCell` 구현 [![feat](https://img.shields.io/badge/feat-green)]()
  - `iOS Deployment Target` 15.2로 변경 [![build](https://img.shields.io/badge/build-purple)]()
  - 키보드가 `textView`를 가리지 않는 기능 구현 [![feat](https://img.shields.io/badge/feat-green)]()
  - `SwiftLint` 적용 [![feat](https://img.shields.io/badge/feat-green)]()
  
- **2022/12/21**
  - 날짜 형식이 사용자의 언어에 맞게 자동으로 변경되도록 수정 [![refactor](https://img.shields.io/badge/refactor-blue)]()
  - JSON 데이터 디코딩 오류 발생 시 얼럿 메시지를 확인하면 앱이 종료되도록 변경 [![refactor](https://img.shields.io/badge/refactor-blue)]()
  - `titleTextView`의 높이가 일정 이상 커질 경우 `titleTextView`의 높이가 더 이상 커지지 않도록 고정하는 기능 구현 [![feat](https://img.shields.io/badge/feat-green)]()
 
 - **2022/12/23**
     - `titleTextView`의 높이가 콘텐트 높이에 따라 최대 높이까지 동적으로 증가하고 감소하도록 수정 [![refactor](https://img.shields.io/badge/refactor-blue)]()

---

## 💾 파일구조
```
Diary
├── Source
│   ├── AppDelegate
│   └── SceneDelegate
└── Resource
    ├── Common
    │   ├── DateFormatterManager
    │   └── JSONDecoderManager
    ├── Model
    │   └── DiaryForm
    ├── View
    │   └── DiaryListTableCell
    └── Controller
        ├── Extension
        │   └── UIViewController+
        ├── DiaryListViewController
        └── RegisterViewController
```

---

## 📊 UML
- 추후 추가 예정

---

## 💻 실행 화면

|전체적인 흐름|제목 텍스트 뷰 높이 & 키보드 레이아웃 동적 구현|
|:--:|:--:|
|<img src=https://i.imgur.com/yv80Llx.gif width="390">|<img src=https://i.imgur.com/urYCyDz.gif width="390">|

---


## 🎯 트러블 슈팅 및 고민

### 동적으로 크기가 변경되는 `textView`에 최대 높이 제약을 적용하기

`titleTextView`가 콘텐트 사이즈에 맞추어 크기가 늘어나고, 일정 크기에 도달하면 더 이상 크기가 늘어나지 않고 스크롤이 되도록 변경해 주었습니다. `titleTextView`에 개행을 많이 포함하고 `bodyTextView`에 텍스트를 입력했을 때 `bodyTextView`가 키보드에 가려질 수 있기 때문입니다.
`textViewDidChange(_:)` 메서드를 활용해서 `textView`의 콘텐트 사이즈의 높이에 따라 텍스트뷰의 높이와 스크롤 가능 여부를 변경하는 조건문을 활용해 레이아웃이 동적으로 변경되도록 구현했습니다.
사용자의 입력에 의해 설정한 최대 크기보다 콘텐트 사이즈가 커지면 최대 크기로 `textView`의 크기가 제한되고 스크롤이 가능해지며, 사용자가 텍스트를 지워 최대 크기보다 콘텐트 사이즈가 작아지면 콘텐트 사이즈에 맞게 `textView`의 크기가 줄어듭니다. (참고:[ Auto Resizing a Dynamic UITextView](https://medium.com/macoclock/auto-resizing-dynamic-uitextview-97d151e59ca0))

**Auto Resizing Dynamic TextView with Max Height**

![Auto Resizing Dynamic TextView](https://i.imgur.com/RIhXRqF.gif)

---

### 스크롤을 내려도 `textView`의 첫째 줄 위의 여백이 일정하게 보이도록 설정하기

`titleTextView`, `bodyTextView`의 스크롤을 내리기 전과 후의 `textView` 바깥 공간과의 여백이 다른 점을 발견했습니다. 스크롤을 내렸을 때  각 `textView`의 첫 줄의 위에 공간이 존재하고, 스크롤을 내리면 그 공간이 사라진다는 것을 뷰 디버거를 통해 알게 되었습니다. 

| 스크롤을 내리지 않았을 때 | 스크롤을 내렸을 때 |
| --- | --- |
| ![](https://i.imgur.com/iaV7HOn.png) | ![](https://i.imgur.com/XMeEX2w.png) |

`textView` 자체에 첫째줄에만 적용되는 `padding` 같은 개념이 존재할 수 있다고 생각해 `UITextView`의 프로퍼티들을 확인해서 [`textContainerInset`](https://developer.apple.com/documentation/uikit/uitextview/1618619-textcontainerinset)이라는 프로퍼티가 존재하며, 기본값이 `(8, 0, 8, 0)`이라는 것을 알게 되었습니다.
각 `textView`의 스크롤을 내려도 `textView` 바깥 공간과의 여백을 일정하게 유지하기 위해 `textContainerInset`을 `(0, 0, 0, 0)`으로 설정했습니다.

**`textContainerInset` 수정 후**
| 스크롤을 내리지 않았을 때 | 스크롤을 내렸을 때 |
| --- | --- |
| ![](https://i.imgur.com/g8XXybD.png) | ![](https://i.imgur.com/ZSSgcIH.png) |

---

### `StackView`의 `subview`에 `translatesAutoresizingMaskIntoConstraints = false`를 왜 하지 않을까?

[`StackView`](https://developer.apple.com/documentation/uikit/uistackview)에 따르면,`StackView`는 `.axis`, `.alignment`, `.distribution` 및 `.spacing` 프로퍼티와 `StackView`의 `frame`(또는 `margin`)을 기반으로 자신의 `arrangedSubviews`의 레이아웃을 결정할 수 있기 때문에, 각 서브뷰의 오토레이아웃을 직접 설정하지 않고도 레이아웃을 지정할 수 있습니다.
위 `view`들은 상위 뷰인 `stackView`에서 주어진 `margin`, `spacing` 외에 별도의 제약조건이 필요하지 않다고 생각해 `translatesAutoresizingMaskIntoConstraints`를 기본값인 `true`로 두어 `stackView`의 프로퍼티에 맞게 `subview`가 오토 리사이징 될 수 있도록 했습니다.

**오토 리사이징에 의해 자동으로 생성된 제약**

![](https://i.imgur.com/5ydGQ8G.png)

---

### 클래스를 `final`로 선언하는 이유

`final` 키워드는 더 이상 해당 클래스에서 하위 클래스로의 전체 클래스 또는 일부가 상속 또는 상속에 따른 재정의가 될 필요가 없다고 판단한 경우에 각 클래스 앞에 추가하여 상속을 방지합니다 (메서드, 프로퍼티 등에도 사용 가능). 
`final`로 선언된 요소들은 직접 호출하는 반면, 그렇지 않은 요소들은 **Virtual Method Table(vtable)** 을 통해 간접 호출되어 직접 호출되는 경우보다 느리게 작동하게 됩니다. `vtable`이란 메서드 오버라이딩에 따라 실행 시점에 어떤 메서드를 실행할 지 결정하는 동적 디스패치를 지원하기 위해 사용하는 메커니즘입니다.
다시 말해, `final` 키워드가 적용된 메서드는 컴파일 시점에 어떤 메서드를 실행할 지 결정할 수 있어(해당 메서드는 더 이상 오버라이딩 되지 않을 것임이 보장되기 때문에) 성능상 이점을 가지게 됩니다. ([WWDC16 - Understanding Swift Performance](https://developer.apple.com/videos/play/wwdc2016/416/))

---

### `LaunchScreen`은 `View`로 분류할 수 있을까?

프로젝트 파일링을 하면서, `LaunchScreen` 파일이 어느 폴더에 분류되는 것이 적합할지에 대한 고민이 생겼습니다. `storyboard`가 존재한다는 점과 `main storyboard`와 유사한 점이 있어 처음에는 `view` 폴더에 넣어야겠다고 생각했습니다. `LaunchScreen`은 사용자가 앱을 실행했을 때 앱의 시작 화면을 담당하는데, 이것의 개념을 `View`와 `ViewController` 중 어느 것으로 생각해야 할 지 고민이 되었습니다. 이에 대한 답을 찾기 위해서는 **`View`의 역할이 무엇인가?** 에 대한 고민이 선행되어야 한다는 것을 알게 되었습니다. 
저희가 생각한 `View`의 역할은 **사용자에게 화면을 보여주는 것**, **사용자와 상호작용 하는 것**입니다. 따라서 **`LaunchScreen`은 `View`로 분류해도 괜찮다**는 결론을 내렸습니다.

---

## 📚 참고 링크

### 공식문서

- [DateFormatter](https://developer.apple.com/documentation/foundation/dateformatter)
- [UIStackView](https://developer.apple.com/documentation/uikit/uistackview)
- [Adaptivity and Layout](https://developer.apple.com/design/human-interface-guidelines/ios/visual-design/adaptivity-and-layout/)
- [UIKit: Apps for Every Size and Shape](https://developer.apple.com/videos/play/wwdc2018/235/)
- [Making Apps Adaptive, Part 1](https://www.youtube.com/watch?v=hLkqt2g-450) / [Script](https://asciiwwdc.com/2016/sessions/222)
- [Making Apps Adaptive, Part 2](https://www.youtube.com/watch?v=s3utpBiRbB0) / [Script](https://asciiwwdc.com/2016/sessions/233)
- [UITextView](https://developer.apple.com/documentation/uikit/uitextview)

### 블로그/기타

- [Move a View Up Only When the Keyboard Covers the Input Field - StackOverflow](https://stackoverflow.com/questions/28813339/move-a-view-up-only-when-the-keyboard-covers-an-input-field)
- [UIKeyboardLayoutGuide - Zedd 블로그](https://zeddios.tistory.com/1282)
- [UITableView Register Cell Identifier - StackOverflow](https://stackoverflow.com/questions/29282447/unable-to-dequeue-a-cell-with-identifier-cell-must-register-a-nib-or-a-class-f)
- [Safe Area와 Layout Margin](https://woozzang.tistory.com/147)
- [UIStackView layoutMargin 적용하기](https://velog.io/@dvhuni/UIStackView-Margin-%EC%A0%81%EC%9A%A9%ED%95%98%EA%B8%B0)
- [How to add leading padding to view added inside an UIStackView - StackOverflow](https://stackoverflow.com/questions/32551890/how-to-add-leading-padding-to-view-added-inside-an-uistackview)
- [Auto Resizing a Dynamic UITextView](https://medium.com/macoclock/auto-resizing-dynamic-uitextview-97d151e59ca0)
