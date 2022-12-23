# 📔 일기장
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
- 코어데이터를 활용해 데이터를 구축하고, UI를 구현해 일기장 애플리케이션을 제작하는 프로젝트 입니다.
- 코어데이터, UICollectionView 개념을 기반으로 제작되었습니다.

---

## 💻 개발환경 및 라이브러리
[![swift](https://img.shields.io/badge/swift-5.6-orange)]()
[![iOS](https://img.shields.io/badge/iOS_Deployment_Target-14.0-blue)]()

---

## 🧑 팀원
|애쉬|애종|
|:---:|:---:|
|<img src= "https://avatars.githubusercontent.com/u/101683977?v=4" width ="200">|<img src = "https://i.imgur.com/HWcJ7i7.jpg" width=200 height=200>|


---

## 🕖 타임라인

### STEP-1
- 2022.12.20
  - swiftLint 적용 [![feat](https://img.shields.io/badge/feat-green)]()
  - ViewController 정의 [![feat](https://img.shields.io/badge/feat-green)]()
  - CollectionViewCell의 `configureContents()` 메서드 추가 [![feat](https://img.shields.io/badge/feat-green)]()
  - JSON데이터를 담을 Diary 타입 정의 [![feat](https://img.shields.io/badge/feat-green)]()

- 2022.12.21
  - ErrorType 타입 정의 및 알럿으로 에러 처리 기능 추가 [![feat](https://img.shields.io/badge/feat-green)]()
  - addDiaryView에서 키보드가 올라올 때 화면이 같이 올라가는 기능 구현 [![feat](https://img.shields.io/badge/feat-green)]()
  - 접근제어자 추가 및 AddDiaryView 내 ScrollView 삭제 [![refactor](https://img.shields.io/badge/refactor-blue)]()

- 2022.12.22
  - AddKeyboardNotification 프로토콜 정의 및 DiaryListViewController가 해당 프로토콜 준수하도록 리팩토링 [![refactor](https://img.shields.io/badge/refactor-blue)]()
  - collectionView가 오토리사이징 마스트가 아닌 오토레이아웃 제약을 사용하도록 수정 [![refactor](https://img.shields.io/badge/refactor-blue)]()
  - ErrorType을 DiaryError로 리네이밍 [![refactor](https://img.shields.io/badge/refactor-blue)]()
  - ErrorAlert 타입 정의 및 AddKeyboardNotification 프로토콜 파일 분리 [![refactor](https://img.shields.io/badge/refactor-blue)]()

- 2022.12.23
  - STEP1 `README.md` 업데이트 [![docs](https://img.shields.io/badge/docs-yellow)]()

---

## 💾 파일구조
```
Diary
├── Errors
│   └── DiaryError
├── Model
│   ├── Diary
│   └── ErrorAlert
├── View
│   ├── ListCollectionViewCell
│   └── AddDiaryView
├── Controller
│   ├── DiaryListViewController
│   └── AddDiaryViewController
└── Extensions
    ├── AddKeyboardNotification
    ├── JSONDecoder+Extension
    └── DateFormatter+Extension
```

---

## 📊 UML
![](https://i.imgur.com/t2uDfsz.jpg)

---

## 💻 실행 화면
| 메인 일기장 화면 | 일기 추가 화면 | 키보드 표시/숨김 기능 |
|:----:|:----:|:----:|
|![일기장 - 메인 일기장 화면](https://i.imgur.com/jwZvR30.png)|![일기장 - 일기 추가 화면](https://i.imgur.com/uw41pJN.gif)|![일기장 - 키보드 표시/숨김 기능](https://i.imgur.com/LjQgJEc.gif)|

| [가로 모드] 메인 화면 | [가로 모드] 일기 추가 화면 |
|:----:|:----:|
|![메인일기장 화면 - 가로모드](https://i.imgur.com/2Wk06zm.png)|![일기장 추가 화면 - 가로모드](https://i.imgur.com/qePeOGP.png)|

---

## 🎯 트러블 슈팅 및 고민

<details>
<summary>1. 사용자의 지역포맷에 따라 날짜를 표현하는 방법에 대한 고민</summary>
<div markdown="1">

- 유저의 언어 설정에 접근하는 방법을 사용해 Locale을 설정하고, 해당 Locale로 지역화된 날짜를 표시할 수 있도록 하였습니다.

```swift
let localeLanguage = Locale.preferredLanguages.first
DateFormatter().locale = Locale(identifier: localeLanguage ?? "ko-kr")
```

</div>
</details>
</br>

<details>
<summary>2. textView에서 사용자가 입력하는 부분이 키보드에 가려지는 문제</summary>
<div markdown="1">
    
 - 해당 문제를 해결하기 위해 총 3가지 방법을 시도해보았습니다.
    - view의 frame.y 를 이동시키기
      첫 번째 view의 frame을 올라가도록 변경하니 textView의 text가 네비게이션 바를 가려 이 방법은 적합하지 않다고 생각했습니다.
    - keyboardLayoutGuide 적용하기
        ```swift
        view.scrollView.bottomAnchor.constraint(equalTo: view.keyboardLayoutGuide.topAnchor, 
                                            constant: -10)
        ```
        위의 방법으로 비교적 간단하게 구현할 수 있었지만 iOS15버전부터 사용가능하기 때문에 다른 방법을 통해서도 해당기능을 구현할 줄 알아야 된다고 생각했습니다.
 - textView의 contentInset 변경하기
    - 현재 저희 코드에서 사용한 방법입니다. notification center를 통해 키보드가 나타날 때 키보드의 높이를 구하고, textView아래에 키보드의 높이만큼 여백을 추가해줬습니다.

</div>
</details>
</br>

<details>
<summary>3. 일기 추가 화면으로 전환시 textView 상단의 일부가 가려져서 보이는 문제</summary>
<div markdown="1">
    
  - 기존에는 아래 이미지와 같이 일기 추가 화면으로 전환했을 때, textView의 상단이 가려진 채로 전환되는 문제가 있었습니다.
    ![](https://i.imgur.com/b2lxdRL.png)
  - 해당 문제에 대해 확인해보니 UITextView는 기본값으로 마진을 가지고 있다는 것을 공식문서에서 확인할 수 있었습니다.
    ```swift
    This property provides text margins for text laid out in the text view. By default the value of this property is (8, 0, 8, 0).
    ```
  - 마진을 제거하기 위해 아래의 코드를 사용해 문제를 해결했습니다.
    ```swift
    self.textView.textContainerInset = .zero
    ```

</div>
</details>
</br>
    
---

## 📚 참고 링크
- [Adaptivity and Layout](https://developer.apple.com/design/human-interface-guidelines/ios/visual-design/adaptivity-and-layout/)
- [공식문서 - DateFormatter](https://developer.apple.com/documentation/foundation/dateformatter)
- [wwdc2019 - Localization](https://developer.apple.com/videos/play/wwdc2019/403/)
