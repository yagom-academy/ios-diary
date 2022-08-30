# 일기장 

## 🙋🏻‍♂️ 프로젝트 소개
Core Data를 활용한 일기장 어플 프로젝트 입니다 

> 프로젝트 기간: 2022-08-16 ~ 2022-09-02</br>
> 팀원: [키위](https://github.com/kiwi1023), [브래드](https://github.com/bradheo65) </br>
리뷰어: [제이슨](https://github.com/ehgud0670)</br>


## 📑 목차

- [🧑🏻‍💻🧑🏻‍💻 개발자 소개](#-개발자-소개)
- [📦 파일 구조](#-파일-구조)
- [📱 동작 화면](#-동작-화면)
- [💡 키워드](#-키워드)
- [🤔 핵심경험](#-핵심경험)
- [📚 참고문서](#-참고문서)
- [📝 기능설명](#-기능설명)
- [🚀 TroubleShooting](#-TroubleShooting)
    - [🚀 STEP 1](#-STEP-1)
    - [🚀 STEP 2](#-STEP-2)


## 🧑🏻‍💻🧑🏻‍💻 개발자 소개

|||
|:---:|:---:|
|<image src = "https://user-images.githubusercontent.com/45350356/174251611-46adf61c-93fa-42a0-815b-2c998af1c258.png" width="250" height="250">|<image src = "https://i.imgur.com/Kv86vCP.jpg" width="250" height="250">
|[브래드](https://github.com/bradheo65)|[키위](https://github.com/kiwi1023)|  

    
## 📦 파일 구조

```
├── AppDelegate.swift![]
├── Assets.xcassets
│   ├── AccentColor.colorset
│   │   └── Contents.json
│   ├── AppIcon.appiconset
│   │   └── Contents.json
│   ├── Contents.json
│   └── sample.dataset
├── Base.lproj
│   └── LaunchScreen.storyboard
├── Controller
│   ├── DiaryDetailViewController.swift
│   ├── DiaryViewController.swift
│   └── MainViewController.swift
├── CoreData.xcdatamodeld
│   └── Model.xcdatamodel
├── Diary.xcdatamodeld
│   └── Diary.xcdatamodel
│       └── contents
├── Info.plist
├── Model
│   ├── CoreData
│   │   ├── Diary+CoreDataClass.swift
│   │   └── Diary+CoreDataProperties.swift
│   ├── CoreDataManager.swift
│   ├── DataManager
│   │   ├── CoreDataManager.swift
│   │   ├── DiaryManager.swift
│   │   ├── Protocol
│   │   │   └── DBMangerable.swift
│   │   └── StubDBManager.swift
│   ├── Extension
│   │   ├── Date + Extension.swift
│   │   ├── Double + Extension.swift
│   │   └── Notification.Name + Extension.swift
│   ├── Json
│   │   ├── DiaryContent.swift
│   │   ├── JSONDecoder + Extension.swift
│   │   └── sample.json
│   └── New Group
├── SceneDelegate.swift
└── View
    ├── DiaryDetailView.swift
    ├── DiaryView.swift
    ├── MainTableViewCell.swift
    └── Protocol
        └── ReuseIdentifying.swift
```
    
    
## 📱 동작 화면

|가로 모드|세로 모드|
|:---:|:---:|
|<image src = "https://user-images.githubusercontent.com/45350356/185554168-e4a1ee8c-58d1-4f02-841d-8268c1517a02.gif" width="250" height="500">|<image src = "https://user-images.githubusercontent.com/45350356/185554478-4cdea87f-4afa-4c0b-a9b6-932b05408d1a.gif" width="400" height="500">|

|백그라운드 전환시 자동 저장|화면 이동시 자동 저장|
|:---:|:---:|
|<image src = "https://i.imgur.com/UUXSauH.gif" width="250" height="500">|<image src = "https://i.imgur.com/sTtW6jh.gif" width="250" height="500">|

|리스트화면 공유 기능|일기작성화면 공유 기능|
|:---:|:---:|
|<image src = "https://i.imgur.com/AyakeB4.gif" width="250" height="500">|<image src = "https://i.imgur.com/7z75WiP.gif" width="250" height="500">|   
    
|리스트화면 삭제 기능|일기작성화면 삭제 기능|
|:---:|:---:|
|<image src = "https://i.imgur.com/E8KN1YB.gif" width="250" height="500">|<image src = "https://i.imgur.com/3IbwUj0.gif" width="250" height="500">|    
    
## 💡 키워드
- JSON
- TableView
- UITextView
- Keyboard layout
- CoreData
    
    
## 🤔 핵심경험
- [x] Date Formatter의 지역 및 길이별 표현의 활용
- [x] Text View의 활용
- [x] 코어데이터 모델 생성
- [x] 코어데이터 모델 및 DB 마이그레이션
- [x] 테이블뷰에서 스와이프를 통한 삭제기능 구현
- [x] Text View Delegate의 활용


## 📚 참고문서
- Adaptivity and Layout
- UIKit: Apps for Every Size and Shape
- Making Apps Adaptive, Part 1 / Script
- Making Apps Adaptive, Part 2 / Script
- DateFormatter
- UITextView
- Core Data
- Making Apps with Core Data
- UITextViewDelegate
- UISwipeActionsConfiguration

    
## 📝 기능설명
- 작성한 일기장의 목록을 보여주는 Table View 구현
- UITextView를 활용하여 일기장 작성기능 구현
- Json Parsing을 통한 Cell과의 Data 연동
- Notification Center를 활용하여 키보드가 작성중인 화면을 가리지 않도록 기능 구현
- CoreData CRUD 
- UITextView `Title`, `Body` 구분 로직 
- TableView Swipe
- UIAlertAction
    
    
## 🚀 TroubleShooting
    
### 🚀 STEP 1

#### T1. 키보드 레이아웃 문제

`UITextView`에 많은 내용이 있을 때 키보드를 사용하게 되면 `UITextView` 내용을 가리는 문제가 발생되었습니다. 해당 문제는 `NotificationCenter` 활용해서 `UITextView` 오토레이아웃 Bottom에 키보드 높이에 대한 제약(AutoLayout)을 설정해서 해결했습니다. 하지만 적용 후 다시 테스트 해보니 내용에 대한 `UITextView` 크기는 적용이 되었지만 키보드가 내려갈 시 `UITextView`가 원래 크기로 돌아가지 않았습니다.
해당 문제에 대해서는 NotificationCenter에서 `UIResponder.keyboardWillShowNotification`만 사용했었는데 추가적으로 `UIResponder.keyboardWillHideNotification`을 사용해서 해결할 수 있었습니다. 

|적용 전|적용 후|
|:---:|:---:|
|<image src = "https://user-images.githubusercontent.com/45350356/185552977-3b9daeda-28e8-45e4-b10a-29f0d10b67a5.gif" width="250" height="500">| <image src = "https://user-images.githubusercontent.com/45350356/185552870-35664bba-0537-405a-99d6-c4f31c11bb55.gif" width="250" height="500">

### 🚀 STEP 2
    
#### T1. 키보드 내려갈시 자동저장 문제

키보드 내려갈 시`CoreData`에 자동저장하게 되는데 문제 발생 현상은 여러 번 키보드가 내려갈 시 중복 으로 저장하는 현상이 발생되었습니다. 발생한 원인을 생각해 본 결과, 새로운 `CoreData` 생성 시 `UUID`가 한 번만 생성되었어야 하는데, 키보드 내려가는 이벤트 시, 생성하고 있어 발생된 문제였습니다. 해결방법으로는 `UUID`가 한 번만 생성하도록 `DiaryViewController`에서 `UUID`만들고 `CoreData`저장 시 해당 `UUID`를 참조하도록 코드를 수정해서 해결해 주었습니다.
    
|적용 전|적용 후|
|:---:|:---:|
|<image src = "https://user-images.githubusercontent.com/45350356/187332064-a2cdbc16-7653-406a-bda5-06f593e70985.gif" width="250" height="500">| <image src = "https://user-images.githubusercontent.com/45350356/187332344-c4f15a7a-2bd2-4d08-94f0-341ae07a3fb9.gif" width="250" height="500">
