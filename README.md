# 📔 **일기장 "Diary"**
> **프로젝트 기간** : 2022.08.16 화  ~ 2022.08.19 금 </br>**리뷰어** : [Wody](@Wody95)

---
## 🪧 목차
- [📜 프로젝트 소개](#-프로젝트-소개)
- [👥 팀원](#-팀원)
- [💾 개발환경 및 라이브러리](#-개발환경-및-라이브러리)
- [💡 핵심경험](#-핵심경험)
- [🕰 타임라인](#-타임라인)
- [🧑‍💻 코드 설명](#-코드-설명)
- [⛹🏻‍♀️ STEP 1 트러블 슈팅](#%EF%B8%8F-step-1-트러블-슈팅)
- [⌨️ 커밋 규칙](#%EF%B8%8F-커밋-규칙)
- [🔗 참고 링크](#-참고-링크)


<br>

## 📜 프로젝트 소개
> 📔 나만의 일기장을 만들어봅시다~

<br>

## 👥 팀원

| **재재(ZZBAE)** | **그루트(Groot)** |
|:---:|:---:|
|![](https://i.imgur.com/Xa9oBRA.png)|<img src="https://i.imgur.com/3r1YKCE.jpg" width="3500" height="600" />|
|[Github](https://github.com/ZZBAE)|[Github](https://github.com/Groot-94)|

<br>

## 💾 개발환경 및 라이브러리
[![swift](https://img.shields.io/badge/swift-5.0-orange)]() [![xcode](https://img.shields.io/badge/Xcode-13.4.1-blue)]()
<br>
<br>

## 💡 핵심경험
- [x] Date Formatter의 지역 및 길이별 표현의 활용
- [x] Text View의 활용
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


<br>

---

## 🧑‍💻 코드 설명
### UML

**파일구조**
```
📦Diary
 ┣ 📂Diary.xcdatamodeld
 ┃ ┣ 📂Diary.xcdatamodel
 ┃ ┃ ┗ 📜contents
 ┃ ┗ 📜.xccurrentversion
 ┣ 📂Resources
 ┃ ┣ 📂Assets.xcassets
 ┃ ┃ ┣ 📂AccentColor.colorset
 ┃ ┃ ┃ ┗ 📜Contents.json
 ┃ ┃ ┣ 📂AppIcon.appiconset
 ┃ ┃ ┃ ┗ 📜Contents.json
 ┃ ┃ ┣ 📂testSample.dataset
 ┃ ┃ ┃ ┣ 📜Contents.json
 ┃ ┃ ┃ ┗ 📜sample.json
 ┃ ┃ ┗ 📜Contents.json
 ┃ ┣ 📂Base.lproj
 ┃ ┃ ┗ 📜LaunchScreen.storyboard
 ┃ ┣ 📜AppDelegate.swift
 ┃ ┗ 📜SceneDelegate.swift
 ┣ 📂Scene
 ┃ ┣ 📂DiaryDetail
 ┃ ┃ ┗ 📂View
 ┃ ┃ ┃ ┗ 📜DiaryDetailView.swift
 ┃ ┣ 📂DiaryList
 ┃ ┃ ┣ 📂Controller
 ┃ ┃ ┃ ┗ 📜DiaryListViewController.swift
 ┃ ┃ ┣ 📂Model
 ┃ ┃ ┃ ┗ 📜DummyData.swift
 ┃ ┃ ┗ 📂View
 ┃ ┃ ┃ ┗ 📜DiaryTableViewCell.swift
 ┃ ┗ 📂DiaryRegister
 ┃ ┃ ┗ 📂Controller
 ┃ ┃ ┃ ┗ 📜DiaryRegisterViewController.swift
 ┣ 📂TestModel
 ┃ ┗ 📜DiaryTestData.swift
 ┣ 📂extension
 ┃ ┣ 📜DiaryDetailViewController.swift
 ┃ ┗ 📜Double+extension.swift
 ┣ 📂protocol
 ┃ ┗ 📜DataSendable.swift
 ┗ 📜Info.plist
 ```
<br>

<br>

### 요약
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
