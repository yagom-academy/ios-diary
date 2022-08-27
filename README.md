# 📔 **일기장 "Diary"**
> **프로젝트 기간** : 2022.08.16 화  ~ 2022.08.26 금 </br>**리뷰어** : [Wody](@Wody95)

---
## 🪧 목차
- [📜 프로젝트 소개](#-프로젝트-소개)
- [👥 팀원](#-팀원)
- [💾 개발환경 및 라이브러리](#-개발환경-및-라이브러리)
- [💡 핵심경험](#-핵심경험)
- [🕰 타임라인](#-타임라인)
- [🧑‍💻 코드 설명](#-코드-설명)
- [📱 구현 화면](#-구현-화면)
- [📁 파일 요약 정리](#-파일-요약-정리)
- [⛹🏻‍♀️ STEP 1 트러블 슈팅](#%EF%B8%8F-step-1-트러블-슈팅)
- [⛹🏻‍♀️ STEP 2 트러블 슈팅](#%EF%B8%8F-step-2-트러블-슈팅)
- [⌨️ 커밋 규칙](#%EF%B8%8F-커밋-규칙)
- [🔗 참고 링크](#-참고-링크)


<br>

## 📜 프로젝트 소개
> 📔 나만의 일기장을 만들어봅시다~

<br>

## 👥 팀원

| **재재(ZZBAE)** | **그루트(Groot) (절대권력자)** |
|:---:|:---:|
|![](https://i.imgur.com/Xa9oBRA.png)|<img src="https://i.imgur.com/3r1YKCE.jpg" width="3500" height="400" />|
|[Github](https://github.com/ZZBAE)|[Github](https://github.com/Groot-94)|

<br>

## 💾 개발환경 및 라이브러리
[![swift](https://img.shields.io/badge/swift-5.0-orange)]() [![xcode](https://img.shields.io/badge/Xcode-13.4.1-blue)]()
<br>
<br>

## 💡 핵심경험
- [x] Date Formatter의 지역 및 길이별 표현의 활용
- [x] Text View의 활용
- [x] 코어데이터 모델 생성
- [x] 코어데이터 모델 및 DB 마이그레이션
- [x] 테이블뷰에서 스와이프를 통한 삭제기능 구현
- [x] Text View Delegate의 활용
<br>

<br>

## 🕰 타임라인

**Step 1 첫째 주**
| 날짜 | 내용 |
|:---:|:---|
|**8/16(화)**|명세에 있는 공식문서, WWDC, 영상 등 공부|
|**8/17(수)**|ListView 구현 및 dateFormatter 적용|
|**8/18(목)**|DetailView 구현 및 RegisterView, 키보드 구현|
|**8/19(금)**|Step1 PR 및 리드미작성|

**Step 2 둘째 주**
| 날짜 | 내용 |
|:---:|:---|
|**8/22(월)**|Step1 리팩토링|
|**8/23(화)**|개인공부|
|**8/24(수)**|개인공부 및 Step1 리팩토링|
|**8/25(목)**|Core Data CRUD 구현, DetailView 자동저장 구현 및 RegisterView 자동저장 구현|
|**8/26(금)**|Step2 PR 및 리드미작성|

<br>

---

## 📱 구현 화면

| 일기장 List 화면 | 일기장 Detail 화면 |
|:---:|:---:|
|<img src = "https://i.imgur.com/qXePdQz.png" width="300" height="600">|<img src = "https://i.imgur.com/Zk9kkMR.png" width="300" height="600">|
|List -> Detail 화면 이동|키보드 설정 구현|+ 버튼 -> 새로운 일기장 화면 레이아웃 구현|
|![](https://i.imgur.com/sNqOGqd.gif)|![](https://i.imgur.com/WjP5iA1.gif)|![](https://i.imgur.com/9Ebv1yt.gif)|
| 일기장 생성화면에서 화면이동 시 자동저장|일기장 생성화면에서 백그라운드 전환 시 자동저장|
| <img src = "https://i.imgur.com/zOWFqFf.gif" width="300" height="600">| <img src = "https://user-images.githubusercontent.com/96932116/186932789-dc08854c-8b14-4586-a264-eb49bbf7a833.gif" width="300" height="600">| 
| 일기장에서 화면이동 시 자동저장|일기장 화면에서 백그라운드 전환 시 자동저장 |
| <img src = "https://user-images.githubusercontent.com/96932116/186933221-94aeb437-f30a-451d-8eff-17229f31812b.gif" width="300" height="600">| <img src = "https://user-images.githubusercontent.com/96932116/186933986-0c135d33-8710-494b-b2b8-51c9ab890e07.gif" width="300" height="600">|
| 리스트 화면에서 스와이프를 통한 공유 및 삭제|일기장 화면에서 경고문을 통한 공유 및 삭제 |
| <img src = "https://i.imgur.com/IxTEFur.gif" width="300" height="600">| <img src = "https://i.imgur.com/d42iISE.gif" width="300" height="600">|
<br>

---

<br>

## 🧑‍💻 코드 설명
### 파일구조

```
├── Diary
├── CoreDataManager.swift
├── Diary+CoreDataClass.swift
├── Diary+CoreDataProperties.swift
├── DiaryModel.swift
│   ├── Diary.xcdatamodeld
│   │   └── Diary.xcdatamodel
│   │       └── contents
│   ├── Info.plist
│   ├── Resources
│   │   ├── AppDelegate.swift
│   │   ├── Assets.xcassets
│   │   ├── Base.lproj
│   │   └── SceneDelegate.swift
│   ├── Scene
│   │   ├── DiaryDetail
│   │   │   ├── Controller
│   │   │   │   └── DiaryDetailViewController.swift
│   │   │   └── View
│   │   │       └── DiaryDetailView.swift
│   │   ├── DiaryList
│   │   │   ├── Controller
│   │   │   │   └── DiaryListViewController.swift
│   │   │   ├── Model
│   │   │   │   ├── DiaryData.swift
│   │   │   │   ├── DiaryDataManager.swift
│   │   │   │   └── MockData.swift
│   │   │   └── View
│   │   │       └── DiaryTableViewCell.swift
│   │   └── DiaryRegister
│   │       ├── Controller
│   │       │   └── DiaryRegisterViewController.swift
│   │       └── View
│   │           └── DiaryRegisterView.swift
│   ├── extension
│   │   └── Double+extension.swift
│   └── protocol
│       └── DiaryDataManagerProtocol.swift
├── DiaryTests
│   └── DiaryTests.swift
├── Podfile
├── Podfile.lock
├── Pods
│   ├── SwiftLint
│   │   ├── LICENSE
│   │   └── swiftlint
│   └── Target Support Files
│       ├── Pods-Diary
│       │   ├── Pods-Diary-Info.plist
│       │   ├── Pods-Diary-acknowledgements.markdown
│       │   ├── Pods-Diary-acknowledgements.plist
│       │   ├── Pods-Diary-dummy.m
│       │   ├── Pods-Diary-umbrella.h
│       │   ├── Pods-Diary.debug.xcconfig
│       │   ├── Pods-Diary.modulemap
│       │   └── Pods-Diary.release.xcconfig
│       └── SwiftLint
│           ├── SwiftLint.debug.xcconfig
│           └── SwiftLint.release.xcconfig
└── README.md
```
<br>

<br>

### 📁 파일 요약 정리

<details>
<summary> STEP 1</summary>

## Scene
### **DiaryList** 
#### DummyData
> 일기장 리스트를 테스트 하기위한 Data 구조체
- Sample Json Data를 Decode해서 배열로 반환하는 타입
#### DiaryTableViewCell
> 일기장 List를 구현하기 위한 TableViewCell 타입
#### DiaryListViewController
> TableView를 구현하고 Scene의 전환을 위한 Controller 역할
    
    
### **DiaryDetail** 
#### DiaryDetailViewController
> DiaryListViewController에서 데이터를 전달받아 DiaryDetailView에 전달하는 Controller 역할 
> DataSendable 채택하여 데이터를 전달(Delegation 전달방식 사용)
    
#### DiaryDetailView
> 일기장의 내용을 편집할 수 있는 뷰

### **DiaryRegister**
#### DiaryRegisterViewController
> 새로운 일기장을 생성할 수 있는 뷰 (이번 step에서는 뷰의 layout만 구성)

### **protocol**
#### DataSendable
> Controller간 데이터 전달을 위한 Protocol
    
### **extension**
#### Double+extension
>`convertData()`라는 지역과 언어에 따라 해당 언어를 바꿔주는 DateFormatter 함수
    
### **DiaryTests**
#### DiaryTests
> DummyData의 Json 데이터의 디코딩이 정상적으로 되는지 확인하는 테스트
    

</details>


<details>
<summary> STEP 2</summary>
    
## Scene    
    
### CoreDataManager
> CoreData를 활용하여 사용자가 적는 일기장 내용을 CRUD (Creat, Read, Update, Delete) 해주는 기능을 관리하는 파일
    
### **DiaryRegister** 
#### DiaryRegisterViewController
> 새롭게 적은 일기의 내용을 DiaryListView에 전달하여 추가하는 Controller 역할

#### DiaryRegisterView
> 일기의 내용을 새로 적을 수 있는 뷰
  
#### DiaryDataManagerProtocol
> decoding한 DiaryModel을 타입으로 갖는 diaryItems로 가지고 있는 프로토콜
    
#### **DiaryData**
> 사용자가 일기 내용을 새로 적은 데이터를 담는 구조체
    
#### **DiaryDataManager**
 > DiaryData를 인스턴스화하여 provider이란 프로퍼티로 가지고 있는 구조체

    
</details>


---
<br><br>
## ⛹🏻‍♀️ STEP 1 트러블 슈팅
### TextView에 긴 Text 설정 시 자동 스크롤 때문에 제목이 잘리는 문제가 있었습니다.
- 문제점
    - TextView에 text를 설정했을 때 자동으로 스크롤이 되지만, text의 길이가 화면을 넘지 못해 스크롤이 생기지는 않아 제목이 잘리는 문제가 있었습니다.

- 해결 과정
    - detailTextView를 초기화해주는 클로저에서 contentOffset을 변경해줬지만, 해결하지 못했습니다.
    - 초기화 당시엔 문제가 없지만, Text를 설정해주면서 스크롤이 내려가는 문제가 발생함을 알 수 있었습니다.

- 해결방법
    - text 설정 후 TextView의 Offset을 초기화 해주는 방법으로 문제를 해결하였습니다.
<br>
    ```swift
    detailTextView.contentOffset = CGPoint(x: 0, y: 0)
    ```
|문제화면|해결화면|
|:---:|:---:|
| <img src = "https://i.imgur.com/mwBowzi.png" width="300" height="600">| <img src = "https://i.imgur.com/fhq9Ewg.png" width="300" height="600"> |
<br>
<br>

---

## ⛹🏻‍♀️ STEP 2 트러블 슈팅
### 앱이 백그라운드로 진입하는 경우 일기가 자동저장되게끔 구현을 해주는 방식 고민
- 어떤 방식으로 백그라운드 진입을 확인할 것인가에 대한 고민
    - 1. `applicationDidEnterBackground(_:)` 메서드로 앱이 백그라운드로 갔을 때, 밑의 사진과 같이 `didEnterBackgroundNotification`와 함께 사용하는 방식이 있었습니다.
    ![](https://i.imgur.com/uwU1M6P.png)
    - 2. 또다른 방식으로는 `sceneDelegate` 내의 `sceneDidEnterBackground` 메서드를 사용할 수 있었습니다.
    - 저희는 sceneDelegate에서 navigationController와 rootViewController를 구성했기 때문에 sceneDelegate에의 메서드에서 처리하는게 맞다고 판단했습니다.
- sceneDidEnterBackground를 사용해서 백그라운드 자동저장 기능을 구현 시 모든 화면에서 저장 메서드를 호출하는 문제가 있었습니다.
    - sceneDelegate의 `sceneDidEnterBackground`를 사용하는 방법으로 자동저장 기능을 구현했지만, 모든 화면에서 백그라운드 이동 시 일기장 등록 ViewController에 있는 자동저장 메서드가 호출되는 문제가 있었습니다.
- 현재 window의 `NavigationViewContoller`의 `topViewContoller`을 확인하는 방법으로 저장이 필요한 `ViewContoller`인지 확인해서 호출하는 방법을 사용했습니다.
    ```swift
    func sceneDidEnterBackground(_ scene: UIScene) {
            guard let navigationViewController = window?.rootViewController as? UINavigationController
            else { return }

            let topViewContoller = navigationViewController.topViewController

            switch topViewContoller {
            case let viewController as DiaryRegisterViewController:
                viewController.saveDiaryData()
            case let viewController as DiaryDetailViewController:
                viewController.saveDiaryData()
            default:
                break
            }
        }
    ```



---

<br><br>
## ⌨️ 커밋 규칙

* feat    : 기능 추가 (새로운 기능)
* refactor : 리팩토링 (네이밍 수정 등)
* style   : 스타일 (코드 형식, 세미콜론 추가: 비즈니스 로직에 변경 없음)
* docs    : 문서 변경 (문서 추가, 수정, 삭제)
* test    : 테스트 (테스트 코드 추가, 수정, 삭제: 비즈니스 로직에 변경 없음)
* chore   : 기타 변경사항 (빌드 스크립트 수정 등)
<br>
    
## 🔗 참고 링크

<details>
<summary>[STEP 1]</summary>
    
[Adaptivity and Layout](https://developer.apple.com/design/human-interface-guidelines/foundations/layout/)<br>[Positioning content relative to the safe area](https://developer.apple.com/documentation/uikit/uiview/positioning_content_relative_to_the_safe_area)<br>[Positioning content within layout margins](https://developer.apple.com/documentation/uikit/uiview/positioning_content_within_layout_margins)<br>[Making apps adaptive part 1](https://m.blog.naver.com/horajjan/220799515261)<br>[Making apps adaptive part 2](https://m.blog.naver.com/PostView.naver?isHttpsRedirect=true&blogId=horajjan&logNo=220799565626)<br>[DateFormatter](https://developer.apple.com/documentation/foundation/dateformatter)<br>[UITextView](https://developer.apple.com/documentation/uikit/uitextview)<br>[tableView(_:trailingSwipeActionsConfigurationForRowAt:)](https://developer.apple.com/documentation/uikit/uitableviewdelegate/2902367-tableview)<br>[UITableViewController VS UIViewController + UITableView](https://www.codementor.io/@nguyentruongky/uitableviewcontroller-vs-uiviewcontroller-uitableview-rfxuec34w)<br>[hugging priority, compression priority](https://eunjin3786.tistory.com/43)
    

</details>

<details>
<summary>[STEP 2]</summary>
    
[Core Data](https://developer.apple.com/documentation/coredata)<br>[Setting Up a Core Data Stack Manually](https://developer.apple.com/documentation/coredata/setting_up_a_core_data_stack/setting_up_a_core_data_stack_manually)<br>[UITableViewDelegate](https://developer.apple.com/documentation/uikit/uitableviewdelegate)<br>[tableView(_:trailingSwipeActionsConfigurationForRowAt:)](https://developer.apple.com/documentation/uikit/uitableviewdelegate/2902367-tableview)<br>[UISwipeActionsConfiguration](https://developer.apple.com/documentation/uikit/uiswipeactionsconfiguration)
    
</details>
