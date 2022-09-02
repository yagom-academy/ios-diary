# 📘 일기장

<br>

## 💾 프로젝트 소개
>**프로젝트 기간** : 2022-08-16 ~ 2022-09-02<br>
**소개** : 그날 겪은 일이나 생각이나 느낌을 적는 일기장 앱입니다. <br>
**리뷰어** : [**제이크**](https://github.com/jryoun1)

<br>

## 목차
* [팀원](#-팀원)
* [실행 화면](#-실행-화면)
* [개발 환경](#-개발-환경)
* [핵심 경험](#-핵심-경험)
* [타임 라인](#-타임-라인)
    * [week2](#week-2)
    * [week3](#week-3)
* [폴더 구조](#-폴더-구조)
* [구현 내용](#-구현-내용)
* [트러블 슈팅](#-트러블-슈팅)
* [참고 문서](#-참고-문서)

<br>

## 👥 팀원
    
| [현이](https://github.com/seohyeon2) | [예톤](https://github.com/yeeton37) |
|:---:|:---:|
|<img src = "https://i.imgur.com/0UjNUFH.jpg" width="200" height="230">|<img src = "https://i.imgur.com/TI2ExtK.jpg" width=200 height = 230>|

<br>

## 📺 실행 화면

| 메인 화면 | 얼럿 화면 |
|:---:|:---:|
|<img src = "https://i.imgur.com/XQ0vRmR.gif" width=200 height=400>|<img src = "https://i.imgur.com/9WikuB9.png" width=200 height=400>|
| 일기장 추가 화면 | 일기장 수정 화면 |
|<img src = "https://i.imgur.com/dyWwzfX.gif" width=200 height=400>|<img src = "https://i.imgur.com/3plNOYs.gif" width=200 height=400>|
| 일기장 공유 화면 | 일기장 삭제 화면 |
|<img src = "https://i.imgur.com/11Cxkam.gif" width=200 height=400>|<img src = "https://i.imgur.com/ziIy5or.gif" width=200 height=400>|

<br>

## 🛠 개발 환경
[![swift](https://img.shields.io/badge/swift-5.6-orange)]()
[![xcode](https://img.shields.io/badge/Xcode-13.4.1-blue)]()
[![swiftLint](https://img.shields.io/badge/SwiftLint-13.2-green)]()

<br>

## 💻 핵심 경험
- [x] 코어데이터 모델 생성
- [x] 테이블뷰에서 스와이프를 통한 삭제기능 구현
- [x] CoreData관련 메서드 프레임워크화
- [x] DiffableDataSource의 process
- [x] UX를 고려한 코드 작성 

<br>

## 🕖 타임 라인

### Week 2
- **2022-08-22 (월)**
  - 데이터 전달 방식 프로토콜을 이용한 방식으로 수정 및 개인 공부

- **2022-08-23 (화)**
  - 일기장 STEP 2-1: CoreData Entity 생성

- **2022-08-24 (수)**
  - 일기장 STEP 2-1: CoreData Create와 Delete 구현
  
- **2022-08-25 (목)**
  - 일기장 STEP 2-2: CoreData Update 구현 및 일기장 자동 저장 구현

- **2022-08-26 (금)**
  - 일기장 STEP 2-2: Error 구현 및 백그라운드 진입 시 자동저장 되는 기능 구현  
  
### Week 3
- **2022-08-29 (월)**
  - CoreData 관련 메서드 프레임워크화 공부

- **2022-08-30 (화)**
  - CoreData 관련 메서드 프레임워크화 공부

- **2022-08-31 (수)**
  - diffableDataSource 이슈 해결
  
- **2022-09-01 (목)**
  - 일기장 저장 시, 실패하는 케이스 처리
 
- **2022-09-02 (금)**
  - 피드백 바탕으로 전반적인 코드 수정

<br>


## 🗂 폴더 구조

```swift
.
└── Diary/
    ├── Diary
    ├── info.plist
    ├── Resources/
    │   ├── LaunchScreen
    │   └── Assets
    └── Sources/
        ├── AppDelegate
        ├── SceneDelegate
        ├── Util/
        │   ├── Common/
        │   │   └── Enum/
        │   │       └── Section
        │   │   └── Extension/
        │   │       └── UIViewController + extension
        │   │   └── Error/
        │   │       └── CoreDataError
        │   │   └── Protocol/
        │   │       ├── ReuseIdentifying
        │   │       ├── SendDataDelegate
        │   │       └── CoreDataProcessing
        │   └── JSONData
        ├── Controllers/
        │   ├── DiaryDetailViewController
        │   └── DiaryListTableViewController
        ├── Views/
        │   └── DiaryTableViewCell
        └── Models/
            ├── DiaryContents + CoreDataClass
            ├── DiaryContents + CoreDataProperties
            ├── DiarySample
            └── DataManager
```

<br>

## 🔧 구현 내용

|구현 위치(파일명)|핵심 구현 내용|
|:--|:--|
|`CoreDataError`|`CoreData` 관련 에러 타입 구현|
|`ReuseIdentifying`|`Identifier` 네임스페이스 처리를 위한 프로토콜 구현|
|`SendDataDelegate`| 뷰컨트롤러간 데이터 전달해주는 프로토콜 구현|
|`CoreDataProcessing`| `CoreData` 관련 메서드 구현|
|`DiaryDetailViewController`|일기 생성 및 업데이트 기능, 액티비티뷰, 알림창 구현|
|`DiaryListTableViewController`|스와이프 시 일기 삭제되는 기능 구현|
|`SceneDelegate`|백그라운 진입 시 자동 저장되는 기능 구현|
|`Diary`|`DiaryContents` Entities 구현|
|`DataManager`|`DiffableDataSource`와 `DiffableDataSourceSnapshot`을 가지고 있는 싱글톤 구현|
|`Section`|`DiffableDataSource`에서 사용할 섹션 열겨형 정의|


<br>

## 🚀 트러블 슈팅

### 1. DiffableDataSource의 dequeueReusableCell 호출 이슈
- 문제 상황
    - cell에 보여지는 데이터가 수정될 때마다, `dequeueReusableCell` 메서드를 호출해야지만 cell에 반영됐습니다.
    - 이 때문에 `dequeueReusableCell`메서드를 `viewDidLoad` 가 아닌 `viewWillAppear`나 `viewDidAppear` 에 위치시켜 화면이 다시 나타날 때마다 실행해야지만 cell이 제대로 바뀌었습니다.
    - 예시) `dequeueReusableCell`메서드를 `viewDidLoad` 호출 시킬 시, cell에 수정된 내용이 반영안됨
<img src = "https://i.imgur.com/4G85SCL.gif" width=200 height=400>
- 디버그 오류 내용
> [UIDiffableDataSource]
>
> Diffable data source detected an attempt to insert or append 1 item identifier that already exists in the snapshot. 
The existing item identifier will be moved into place instead, but this operation will be more expensive.
For best performance, inserted item identifiers should always be unique. 
Set a symbolic breakpoint on BUG_IN_CLIENT_OF_DIFFABLE_DATA_SOURCE__IDENTIFIER_ALREADY_EXISTS to catch this in the debugger. 
Item identifier that already exists ...

- 원인
    - 데이터 수정 시에도 snapshot에 변경된 데이터를 추가하고 있기 때문에 기존에 추가된 데이터랑 충돌이 났습니다.
    - 이 충돌로 인해, snapShot에 반영은 되었지만, dataSource는 이미 cell에 보여준 것으로 인식하여 `dequeueReusableCell` 메서드를 수동적으로 호출해줘야만 했습니다.

- 해결 방안
    - snapshot에 데이터를 `append`하는 경우(새로운 일기 생성)와 snapShot에 데이터를 `reload`(일기 생성 외) 해주는 경우를 나누어주었습니다.

### 2. UX를 고려하여 셀에 보여지는 title과 body 수정
- 문제 상황
    - 프로젝트 요구서에는 `/n/n`을 기준으로 `title`과 `body`를 나누어주도록 나와있었습니다. 
    - `\n\n`이 없는 경우에는 제대로 저장이 되지 않는 상황이 발생했습니다.


#### PR 질문사항
> 요구서의 예시 화면을 참고하여, `textView`에서 `\n\n`을 기준으로 `title`과 `body`를 구분해주었습니다. `textView`에 `\n\n`이 없는 경우 CoreData에 제대로 저장되지 않는 오류가 발생했습니다.
>
>이 오류를 해결하기 위해 `\n\n`으로 `components` 해 주었을 경우, 배열의 개수가 2개 이상인지 확인하는 코드를 추가하여, 2개 미만이면 임의로 데이터를 넣어주도록 했습니다. 
또한 `title`에 `\n`이 들어간 경우, 셀에서 제목이 잘리는 현상이 발생해 `\n` 대신 `" "` 공백으로 바꿔주었습니다. 사용자 입력을 임의로 바꿔줌으로써 사용자가 원하는 결과를 충족시켜주지 못할 수도 있을 것 같아 좋은 코드라는 생각이 들지 않습니다..😓 더 나은 방식으로 `title`과 `body`를 구분하고, 예외처리를 해 주고 싶은데 어떤 아이디어로 접근해보면 좋을지 궁금합니다!

#### 리팩토링한 결과

`/n/n`이 없더라도 구분을 해서 저장해주도록 사용자 UX를 고려하여 추가적으로 리팩토링을 해보았습니다.

- 예시 
    - `\n\n\n\n\n 예톤과 현이의 일기장 \n` 
- 고민 사항
    - \n이 리스트에서 해당 일기장의 제목으로 보여져야하는지
    - 예톤과 현이의 일기장이 제목으로 보여져야하는지
    - 일기장 상세에 들어왔을 때 `\n\n\n\n\n` 들이 보여지고 예톤과 현이의 일기장이 나와야하는지


- 해결안
- > `일기의 맨 첫 줄은 일기의 제목이 되고, 그 다음 줄부터 본문이 됩니다.` 
- 위 명세와 문자만 셀에 보여지는 것이 사용자가 가장 기대하는 UX가 아닐까 싶었습니다.
- 제이크의 조언에 따라 다음과 같이 리팩토링을 진행하여 고민을 해결했습니다.
- list에서 보여져야하는 제목
    - `예톤과 현이의 일기장`
- 일기 상세로 들어왔을 때
    - `\n\n\n\n\n`이 나타난 이후 예톤과 현이의 일기장이 보여짐

---

### 🔗 참고 문서

- [UICollectionViewDiffableDataSource](https://developer.apple.com/documentation/uikit/uicollectionviewdiffabledatasource)
- [NSDiffableDataSourceSnapshot](https://developer.apple.com/documentation/uikit/nsdiffabledatasourcesnapshot)
- [Core Data](https://developer.apple.com/documentation/coredata)
- [Making Apps with Core Data](https://developer.apple.com/videos/play/wwdc2019/230/)

- [UIActivityViewController](https://developer.apple.com/documentation/uikit/uiactivityviewcontroller)

- [LocalizedError](https://developer.apple.com/documentation/foundation/localizederror)

- [resignFirstResponder](https://developer.apple.com/documentation/uikit/uiresponder/1621097-resignfirstresponder)
