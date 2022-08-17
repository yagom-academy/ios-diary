# 일기장

## 프로젝트 소개
일기장 어플리케이션을 관리해본다.

> 프로젝트 기간: 2022-08-16 ~ 2022-09-02</br>
> 팀원: [수꿍](https://github.com/Jeon-Minsu), [Finnn](https://github.com/finnn1) </br>
리뷰어: [GRENN](https://github.com/GREENOVER)</br>


## 📑 목차

- [🧑🏻‍💻🧑🏻‍💻 개발자 소개](#-개발자-소개)
- [⏱ TimeLine](#-TimeLine)
- [💡 키워드](#-키워드)
- [🤔 핵심경험](#-핵심경험)
- [🗂 폴더 구조](#-폴더-구조)
- [📝 기능설명](#-기능설명)
- [🚀 TroubleShooting](#-TroubleShooting)
- [📚 참고문서](#-참고문서)


## 🧑🏻‍💻🧑🏻‍💻 개발자 소개

|수꿍|Finnn|
|:---:|:---:|
|<image src = "https://i.imgur.com/6HkYdmp.png" width="250" height="250">|<img src="https://i.imgur.com/5EQ0KJy.png" width="250" height="250">
|[수꿍](https://github.com/Jeon-Minsu)|[Finnn](https://github.com/finnn1)|

## ⏱ TimeLine

### Week 1
    
> 2022.8.16 ~ 2022.8.17
    
- 2022.08.16
    - 간단한 자기소개
    - 전반적인 프로젝트 수행 계획 수립
    - 계획을 기반으로 코드 작성
    - `JSON` 샘플 데이터 파싱 구현
    - `UITableView` 구현
    - `TableView`의 `CustomCell` 구현 및 `JSON` 데이터 연동
    - `Text font`가 `Dynamic Size`에 대응하도록 구현
    - `DateFormatter`를 활용한 localize된 날짜 표기형식 구현
    - `UITextView`를 활용한 메모 작성 페이지 구현
    - `UITextView`에 내용 작성시 소프트웨어 키보드가 작성중인 글을 가리지 않도록 수정

- 2022.08.17 
    - 컨벤션 수정 전반적인 및 리팩토링
    - `STEP1 PR` 작성
    
## 💡 키워드

- `JSONDecoder`, `NSDataAsset`, `Parsing`
- `TimeInterval`, `timeIntervalSince1970`
- `DateFormatter`, `Locale`, `TimeZone`, `current`
- `UITableViewDiffableDataSource`
- `keyboardFrameEndUserInfoKey`, `contentInset`, `scrollIndicatorInsets`

    
## 🤔 핵심경험

- [x] Date Formatter의 지역 및 길이별 표현의 활용
- [x] Text View의 활용

## 🗂 폴더 구조

```
.
└── Diary
    ├── AppDelegate
    ├── SceneDelegate
    ├── Models
    │   ├── DiarySampleData
    │   ├── JSONData
    │   ├── Namespaces
    │   ├── Section
    │   └── Extension
    │       ├── Date+Extension
    │       └── Int+Extension
    ├── Views
    │   ├── CustomCell
    │   ├── DiaryContentView
    │   └── DiaryView
    └── Controllers
        ├── DiaryContentsViewController
        └── DiaryViewController
```
    
## 📝 기능설명


**작성한 일기장 목록을 보여주는 TableView 구현**
    
    - JSON 샘플 데이터 파싱 구현
    - UITableView 구현
    - TableView의 CustomCell 구현 및 JSON 데이터 연동
    - Text font가 Dynamic Size에 대응하도록 구현
    - DateFormatter를 활용한 localize된 날짜 표기형식 구현
   
**새로운 일기장 작성을 위한 TextView 구현**
    
    - UITextView를 활용한 메모 작성 페이지 구현
    - UITextView에 내용 작성시 소프트웨어 키보드가 작성중인 글을 가리지 않도록 수정


## 🚀 TroubleShooting

### STEP 1
#### T1. `KeyBoard` 숨김 기능 감지 방법
- 일기장 생성 화면으로 이동하였을 때, `textView`의 `keyboardDismissMode` 프로퍼티를 `interactive`로 설정하니, 드래그가 가능한 상황에서는 화면을 위로 일정 정도 스크롤을 해보니, 키보드가 정상적으로 사라질 수 있었습니다.
- 그러나, 일기장에 아무것도 입력하지 않은 초기 화면인 경우, 입력한 내용이 없기 때문에 스크롤이 불가능하여 키보드가 사라질 수 없었습니다.
- 이에 대하여 고민해본 결과, `textView`의 `alwaysBounceVertical` 프로퍼티를 `true`로 설정하여, 초기 화면에서도 수직 스크롤을 가능하게 하여, 일정 정도 스크롤을 하면 키보드가 정상적으로 사라질 수 있었습니다.


## 📚 참고문서

- [Adaptivity and Layout](https://developer.apple.com/design/human-interface-guidelines/foundations/layout/)
- [UIKit: Apps for Every Size and Shape](https://developer.apple.com/videos/play/wwdc2018/235/)
- [Making Apps Adaptive, Part 1 / Script](https://www.youtube.com/watch?v=hLkqt2g-450)
- [Making Apps Adaptive, Part 2 / Script](https://www.youtube.com/watch?v=s3utpBiRbB0)
- [DateFormatter](https://developer.apple.com/documentation/foundation/dateformatter)
- [UITextView](https://developer.apple.com/documentation/uikit/uitextview)
--- 
    
## 1️⃣ STEP 1

### STEP 1 Questions & Answers

#### Q1. `View`와 `ViewController` 분리로 인한 
- `ViewController`의 기본 `view`를 `DiaryView`로 교체를 하였는데, `diaryView`를 사용하기 위하여, 이를 사용하는 모든 메서드에서 `guard let`을 통한 다운캐스팅이 필요하였습니다. 
- 이 때문에 동일한 코드가 중복적으로 발생하여, 해당 문제를 해결하기 위해 코드의 유연성을 높일 수 있는 방법이 무엇이 있을지 질문드리고 싶습니다.
