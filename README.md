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
  - 
- **2022-08-26 (금)**
  - 일기장 STEP 2-2: Error 구현 및 백그라운드 진입 시 자동저장 되는 기능 구현
<br>


## 🗂 폴더 구조

```swift
.
└── Diary/
    ├── info.plist
    ├── Resources/
    │   ├── LaunchScreen
    │   └── Assets
    └── Sources/
        ├── AppDelegate
        ├── SceneDelegate
        ├── Util/
        │   ├── Common/
        │   │   └── Protocol/
        │   │       ├── ReuseIdentifying
        │   │       ├── SendDataDelegate
        │   │       └── CoreDataProcessing
        │   └── JSONData
        ├── Controllers/
        │   ├── DetailDiaryViewController
        │   └── DiaryListTableViewController
        ├── Views/
        │   └── DiaryTableViewCell
        └── Models/
            ├── DiaryContents + CoreDataClass
            ├── DiaryContents + CoreDataProperties
            └── DiarySample
```

<br>

## 🔧 구현 내용

|구현 위치(파일명)|핵심 구현 내용|
|:--|:--|
|`CoreDataError`|`CoreData` 관련 에러 타입 구현|
|`ReuseIdentifying`|`Identifier` 네임스페이스 처리를 위한 프로토콜 구현|
|`SendDataDelegate`| 뷰컨트롤러간 데이터 전달해주는 프로토콜 구현|
|`CoreDataProcessing`| `CoreData` 관련 메서드 구현|
|`DetailDiaryViewController`|일기 생성 및 업데이트 기능, 액티비티뷰, 알림창 구현|
|`DiaryListTableViewController`|스와이프 시 일기 삭제되는 기능 구현|
|`SceneDelegate`|백그라운 진입 시 자동 저장되는 기능 구현|
|`Diary`|`DiaryContents` Entities 구현|

<br>

## 🚀 트러블 슈팅

### 1. 데이터 삭제 시 UI에 바로 적용되지 않는 문제
- 구현하고자 했던 기능
    - 두 번째 뷰컨의 일기장 작성 화면에서 일기장을 `delete`하면 두 번째 뷰컨이 `pop` 되고, `pop`이 되어 첫 번째 뷰컨으로 돌아왔을 때 일기장이 바로 삭제가 되어있어야 합니다.
- 구현 실패 과정
    - 첫 번째 뷰컨으로 돌아왔을 때 삭제가 된 화면이 바로 나타나지 않았고, 다시 앱을 재실행할 때만 삭제된 것이 제대로 나타났습니다.
- 저희가 생각한 실행 흐름
    -  삭제 버튼을 누를 시 `Core Data`의 `context`에서 삭제가 되고 ➡️ 바뀐 내용을`context`에 저장하고 ➡️ `fetch`를 통해 삭제된 데이터를 가져오고 ➡️ 이를 `snapshot`에 `append`해주고 ➡️ `dataSource`에 `snapshot`을 `apply` 해줍니다.
    - 하지만, 위의 순서로 코드를 구현하니 제대로 작동되지 않았습니다. 이유를 찾아보니 데이터 삭제시 스냅샷에서도 `deleteItems` 메서드를 통해 데이터를 삭제해주는 과정이 추가로 더 필요한 것을 알게 되었습니다. 
- 해결 방법
    - 위의 이유를 통해 다음과 같은 코드를 추가해 줌으로서 UI에 바로 적용되지 않는 문제를 해결했습니다
    
```swift
snapshot.deleteAllItems()
snapshot.appendSections([.main])
```
    
    
추후 PR 리팩토링 후 수정
---

### 🔗 참고 문서

- [UICollectionViewDiffableDataSource](https://developer.apple.com/documentation/uikit/uicollectionviewdiffabledatasource)
- [NSDiffableDataSourceSnapshot](https://developer.apple.com/documentation/uikit/nsdiffabledatasourcesnapshot)
- [Core Data](https://developer.apple.com/documentation/coredata)
- [Making Apps with Core Data](https://developer.apple.com/videos/play/wwdc2019/230/)


