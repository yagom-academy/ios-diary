# 일기장 README.md

## 프로젝트 저장소
> 프로젝트 기간: 2022-08-16 ~ 2022-09-02</br>
> 팀원: [바드](https://github.com/bar-d), [본프](https://github.com/apwierk2451)</br>
리뷰어: [@Jason](https://github.com/ehgud0670)</br>
그라운드롤: [GroundRule - Wiki](https://github.com/bar-d/ios-diary/wiki/GroundRule)

## 📑 목차
- [개발자 소개](#개발자-소개)
- [프로젝트 소개](#프로젝트-소개)
- [폴더 구조](#폴더-구조)
- [구현화면](#구현화면)
- [키워드](#키워드)
- [참고문서](#참고문서)
- [핵심경험](#핵심경험)
- [기능설명](#기능설명)
- [1️⃣ Step1_Wiki](#1️⃣-step1_wiki)
- [2️⃣ Step2_Wiki](#2️⃣-step2_wiki)
- [3️⃣ Step3_Wiki](#3️⃣-step3_wiki)
- [TroubleShooting](#troubleshooting)
## 개발자 소개
|[바드](https://github.com/bar-d)|[본프](https://github.com/apwierk2451)|
|:---:|:---:|
| <img src = "https://i.imgur.com/k9hX1UH.png" width="250" height="250">| <img src = "https://i.imgur.com/ZLDLlML.png" width="250" height="250"> |




## 프로젝트 소개
- 코어 데이터를 이용한 일기장 데이터 관리

## UML
### [ClassDiagram]


## 폴더 구조
```
├── Diary
│   ├── DiaryEntity+CoreDataClass.swift
│   ├── DiaryEntity+CoreDataProperties.swift
│   ├── Extension
│   │   ├── Array+Extension.swift
│   │   ├── Date+Extension.swift
│   │   └── TimeInterval+Extension.swift
│   ├── JSONModel
│   │   └── Diary.swift
│   ├── Manager
│   │   ├── CoreDataManager.swift
│   │   └── KeyboardManager.swift
│   │   └── MockDiaryManager.swift
│   ├── Protocol
│   │   ├── DataManagable.swift
│   │   ├── DataSendable.swift
│   │   └── ReuseIdentifiable.swift
│   ├── Resources
│   │   ├── AppDelegate.swift
│   │   ├── Assets.xcassets
│   │   │   └── sample.json
│   │   ├── Info.plist
│   │   └── SceneDelegate.swift
│   └── Scene
│       ├── DiaryDetail
│       │   ├── Controller
│       │   │   └── DiaryDetailViewController.swift
│       │   ├── Model
│       │   └── View
│       │       └── DiaryDetailTextView.swift
│       ├── DiaryList
│       │   ├── Controller
│       │   │   └── DiaryListViewController.swift
│       │   ├── Model
│       │   │   ├── Enum
│       │   │       └── Section.swift
│       │   └── View
│       │       └── DiaryListCollectionViewCell.swift
│       └── DiaryRegistration
│           ├── Controller
│           │   └── DiaryRegistrationViewController.swift
│           ├── Model
│           └── View
│               └── DiaryRegistrationView.swift
```
## 구현화면
|||
|:---:|:---:|
|다크모드 구현|일기장 등록 뷰|
| <img src = "https://i.imgur.com/4jtnPkd.gif" width="300" height="600">| <img src = "https://i.imgur.com/5ChVRpB.gif" width="300" height="600"> |
|일기장 디테일 뷰 키보드|일기장 등록 뷰 키보드|
| <img src = "https://i.imgur.com/s0eAKyv.gif" width="300" height="600">| <img src = "https://i.imgur.com/5ChVRpB.gif" width="300" height="600"> |
|일기장 개행 처리|얼럿 공유버튼을 눌렀을 때|
| <img src = "https://i.imgur.com/qDgWehW.gif" width="300" height="600">| <img src = "https://i.imgur.com/lJtrtxC.gif" width="300" height="600"> |  
|일기장에 아무것도 입력안했을 때|일기장 순서 변경|
| <img src = "https://i.imgur.com/KJJcaSQ.gif" width="300" height="600">| <img src = "https://i.imgur.com/2uJKsHw.gif" width="300" height="600"> |  

||
|:---:|
|일기장 리스트 뷰 오토레이아웃|
| <img src = "https://i.imgur.com/RV2EkpM.gif" width="600" height="600">|
|일기장 디테일 뷰 오토레이아웃|
| <img src = "https://i.imgur.com/g9vHt84.gif" width="600" height="600">|

## 키워드
- AutoLayout
- UICollectionView
- UICollectionViewCompositionalLayout
- DateFormatter
- TextViewDelegate
- UISwitch
- UIApplication
- keyboardDismissMode
- CoreData

## 참고문서
- [Adaptivity and Layout](https://developer.apple.com/design/human-interface-guidelines/ios/visual-design/adaptivity-and-layout/)
- [UIKit: Apps for Every Size and Shape](https://developer.apple.com/videos/play/wwdc2018/235/)
- [Making Apps Adaptive, Part 1 / Script](https://www.youtube.com/watch?v=hLkqt2g-450)
- [Making Apps Adaptive, Part 2 / Script](https://www.youtube.com/watch?v=s3utpBiRbB0)
- [DateFormatter](https://developer.apple.com/documentation/foundation/dateformatter)
- [UITextView](https://developer.apple.com/documentation/uikit/uitextview)


## 핵심경험
- [x] Date Formatter의 지역 및 길이별 표현의 활용
- [x] Text View의 활용
- [x] 코어데이터 모델 생성
- [x] 코어데이터 모델 및 DB 마이그레이션
- [ ] 테이블뷰에서 스와이프를 통한 삭제기능 구현
- [x] Text View Delegate의 활용
- [ ] Open API의 활용
- [ ] Core Location의 활용

## 부가경험
- [ ] Attributed String 활용
- [ ] Serach Controller 활용
- [x] 라이트모드/다크모드 구현
- [x] 접근성 구현
- [x] 지역화 구현


## 기능설명

### JSONModel
- **`Json Data decoding을 위한 타입 구현`**
    - JSONModel

### Extension
- **`extension을 통한 사용자 정의 함수 구현`**
    - Date+extension 
        - `convertToCurrentTime() -> String`
    - TimeInterval+extension
        - `convert1970DateToString() -> String`
        
### CoreDataManager
- **`CoreData를 관리해주는 CoreDataManager class 구현`**
- 
### KeyboardManager
- **`keyboard를 관리해주는 KeyBoardManager class 구현`**
   
### DataSendable
- **`delegate 패턴을 이용해 Controller 간 데이터를 전달하기 위한 Protocol 구현`**

### ReuseIdentifiable
- **`해당 클래스에 identifier가 필요하다면 identifer를 타입 이름으로 추가해주는 프로토콜 구현`**

### Array+extension
- **`indexPath값을 안전하게 꺼내줄 수 있도록 Array의 extension get(index: Int) -> Element?함수 구현`**
- 
### Scene
#### 1. DiaryList
##### DiaryListCollectionViewCell
- **`사용자 정의 Cell을 통한 일기장 정보를 전달해 주는 셀 구현`**
    
##### UISwitch
- **`UISwitch를 통한 다크모드 전환 스위치 구현`**

##### UICollectionViewDelegate
- **`UICollectionViewDelegate를 통한 뷰 컨트롤러 사이의 데이터 전달 및 전환방식 구현`**

##### UIRefreshControl
- **`데이터의 새로고침 기능을 구현하기 위한 UIRefreshControl 사용`**

- **`수정이 필요한 상품정보를 입력받는 뷰 구현`**

#### 2. DiaryDetail
##### DiaryDetailTextView
- **`작성된 일기를 보여주고 수정 가능한 UITextView 구현`**

##### DiaryDetailController
- **`Delegate패턴을 이용하여 전달 받은 데이터를 뷰에 구현`**


#### 3. DiaryRegistration
##### DiaryRegistrationTextView
- **`DiaryDetailTextView를 상속받아 일기를 작성하는 UITextView 구현`**
##### DiaryViewController
- **`일기를 작성하고 작성된 일기 내용을 CoreData에 저장하는 기능 구현`**

## [1️⃣ Step1_Wiki](https://github.com/bar-d/ios-diary/wiki/Step1)
## [2️⃣ Step2_Wiki](https://github.com/bar-d/ios-diary/wiki/Step2)
## [3️⃣ Step3_Wiki](https://github.com/bar-d/ios-diary/wiki/Step3)
## [TroubleShooting](https://github.com/bar-d/ios-diary/wiki/TroubleShooting)
