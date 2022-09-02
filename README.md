# 📔 일기장

## 🪧 목차
- [📜 프로젝트 소개](#-프로젝트-소개)
- [📱 실행 화면](#-실행-화면)
- [💡 핵심경험](#-핵심경험)
- [🗂 폴더 구조](#-폴더-구조)
- [🧑‍💻 코드 설명](#-코드-설명)
- [⚡️ STEP 1 트러블 슈팅](#%EF%B8%8F-step-1-트러블-슈팅)
- [⚡️ STEP 2 트러블 슈팅](#%EF%B8%8F-step-2-트러블-슈팅)
- [⚡️ STEP 3 트러블 슈팅](#%EF%B8%8F-step-3-트러블-슈팅)
- [🔗 참고 링크](#-참고-링크)

<br>

## 📜 프로젝트 소개
내가 쓴 일기를 CoreData를 사용하여 저장하고 수정, 삭제할 수 있는 일기장입니다. 

> 프로젝트 기간: 2022-08-16 ~ 2022-09-02</br>
> 팀원:  [주디](https://github.com/Judy-999), [백곰](https://github.com/Baek-Gom-95) </br>
리뷰어: [찰리](https://github.com/kcharliek)</br>

<br>

## 🧑🏻‍💻🧑🏻‍💻 개발자 소개

|[주디](https://github.com/Judy-999)|[백곰](https://github.com/Baek-Gom-95)|
|:---:|:---:|
|<img src = "https://i.imgur.com/SdlGVLc.jpg" width="250" height="250"> | <img src = "https://i.imgur.com/c17eEk8.jpg" width="250" height="250"> |
	
<br>
	
## 📱 실행 화면
| 일기장 목록 화면 |+ 버튼 터치 시 추가화면으로 이동 | 글자 입력 및 키보드에 따른 텍스트뷰 변화 |
| :--------: | :--------: | :--------: |
| ![](https://i.imgur.com/yTb46gz.gif) |![](https://i.imgur.com/pQ2J1J0.gif)| ![](https://i.imgur.com/PcdFBvV.gif)|

| 일기장 생성 | 일기장 편집 | 비어있는 경우 알림 |
| :--------: | :--------: | :--------: |
| ![](https://i.imgur.com/s97AIrp.gif) |![](https://i.imgur.com/dOyAx8r.gif)| ![](https://i.imgur.com/i1eBMgg.gif)|
| 자동으로 커서 세팅 및 키보드 올라옴 | 내용을 터치하면 편집 가능 | 제목 또는 내용이 비어있는 상태로 되돌아갈 때 얼럿 |

| 스와이프로 삭제 및 공유 | 더보기 버튼으로 삭제 | 백그라운드 자동저장 |
| :--------: | :--------: | :--------: |
| ![](https://i.imgur.com/nKyrKlU.gif) |![](https://i.imgur.com/YxZO1KM.gif)| ![](https://i.imgur.com/RisAp7b.gif)|

| 일기장 목록 날씨 | 일기장 편집 날씨 | 
| :--------: | :--------: | 
|![](https://i.imgur.com/IxdNTDn.png) | ![](https://i.imgur.com/Pg2uR5f.png)| 

<br>

## 💡 핵심경험
- [x] Date Formatter
- [x] Text View
- [x] CoreData
- [x] CoreData Model 및 DB Migration
- [x] TableView Swipe
- [x] Text View Delegate
- [x] Open API
- [x] Core Location

<br>


## 🗂 폴더 구조

```
.
├── Application
│   ├── AppDelegate.swift
│   └── SceneDelegate.swift
├── Controller
│   ├── DiaryTableViewController.swift
│   └── ManageDiaryViewController.swift
├── CoreData
│   └── DiaryDataManager.swift
├── Extension
│   └── View + Extension.swift
├── Info.plist
├── Model
│   ├── DateManager.swift
│   ├── DiaryItem.swift
│   ├── JSON
│   │   ├── JSONDiary.swift
│   │   ├── JSONError.swift
│   │   └── JSONManager.swift
│   ├── ReuseIdentifying.swift
│   └── Weather
│       ├── Weather.swift
│       ├── WeatherError.swift
│       └── WetherDecoder.swift
├── Network
│   └── WeatherSessionManager.swift
├── Protocol
│   └── DataManageable.swift
├── Resource
│   ├── Assets.xcassets
│   │   ├── AccentColor.colorset
│   │   │   └── Contents.json
│   │   ├── AppIcon.appiconset
│   │   │   └── Contents.json
│   │   ├── Contents.json
│   │   └── sample.dataset
│   │       ├── Contents.json
│   │       └── sample.json
│   ├── Base.lproj
│   │   ├── LaunchScreen.storyboard
│   │   └── Main.storyboard
│   │   └── Diary.xcdatamodel
│   │       └── contents
│   └── Model.xcdatamodeld
│       └── Model.xcdatamodel
│           └── contents
└── View
    ├── DiaryListCell.swift
    ├── ManageDiaryView.swift
    └── NavigationTitleView.swift
```

<br>

## 🧑‍💻 코드 설명
- `WeatherSessionManager`: 날씨API 를 통해 정보를 얻어오는 코드입니다.
- `DataManageable`: 데이터관리 프로토콜 입니다
- `DiaryDataManager`: CoreDataFramwork의 기능을 사용하는 코드입니다.
- `Weather`: 날씨API 를 통해 받아오는 데이터모델입니다
- `WeatherError`: 날씨API 관련 작업중 일어날수있는 에러타입을 정리했습니다.
- `WeatherDecoder`: 날씨API를 통해 받아온 데이터를 Decode 해줍니다.
- `JSONParser`: JSON 타입의 데이터를 Parsing 합니다.
- `JSONError`: Parsing 도중에 일어날수있는 에러타입을 정리했습니다.
- `JSONDiary`: JSON 파싱 모델 입니다.
- `DiaryItem`: CoreData에 저장될 데이터의 모델 입니다.
- `ReuseIdentifying`: Cell의 이름을 Identifier로 가지게 합니다.
- `DateManager`: 날짜를 나타내는 데이터를 원하는 날짜포맷으로 변경합니다.
- `DiaryListCell`: 일기장 리스트 화면의 Cell을 구현합니다.
- `ManageDiaryView`: 일기장 생성 및 편집 뷰를 구현합니다.
- `NavigationTitleView`: 네비게이션 타이틀 뷰를 만들어줍니다.
- `DiaryTableViewController`: 일기장 리스트 뷰를 관리하는 컨트롤러 입니다.
- `ManageDiaryViewController`: 일기장 생성 및 편집 뷰를 관리하는 컨트롤러 입니다.
- `CoreDataFramework`: CoreData의 CRUD기능을 가지고있는 프레임워크 입니다.


<br><br>

## ⚡️ STEP 1 트러블 슈팅 
👉 [STEP 1 트러블 슈팅 보러가기](https://github.com/Judy-999/ios-diary/wiki/STEP-1-%ED%8A%B8%EB%9F%AC%EB%B8%94-%EC%8A%88%ED%8C%85)

<br><br>

## ⚡️ STEP 2 트러블 슈팅 

👉 [STEP 2 트러블 슈팅 보러가기](https://github.com/Judy-999/ios-diary/wiki/STEP-2-%ED%8A%B8%EB%9F%AC%EB%B8%94-%EC%8A%88%ED%8C%85)

<br><br>

## ⚡️ STEP 3 트러블 슈팅 

👉  [STEP 3 트러블 슈팅 보러가기](https://github.com/Judy-999/ios-diary/wiki/STEP-3-%ED%8A%B8%EB%9F%AC%EB%B8%94-%EC%8A%88%ED%8C%85)

<br><br>


## 🔗 참고 링크


<details>
<summary>[STEP 1]</summary>
	
[Adaptivity and Layout](https://developer.apple.com/documentation/coredata)<br>
[UIKit: Apps for Every Size and Shape](https://developer.apple.com/videos/play/wwdc2018/235/)<br>
[Making Apps Adaptive, Part 1 / Script](https://asciiwwdc.com/2016/sessions/222)<br>
[Making Apps Adaptive, Part 2 / Script](https://www.youtube.com/watch?v=s3utpBiRbB0)<br>
[DateFormatter](https://developer.apple.com/documentation/foundation/dateformatter)<br>
[UITextView](https://developer.apple.com/documentation/uikit/uitextview)<br>
[키보드에 동적인 스크롤뷰](https://seizze.github.io/2019/11/17/iOS에서-키보드에-동적인-스크롤뷰-만들기.html)<br>
[UITextField Left padding 넣어주기 ](https://developer-fury.tistory.com/46)<br>
[키보드야 텍스트 가리지마](https://velog.io/@cherrish_red/iOS-%ED%82%A4%EB%B3%B4%EB%93%9C%EC%95%BC-%ED%85%8D%EC%8A%A4%ED%8A%B8-%EA%B0%80%EB%A6%AC%EC%A7%80%EB%A7%88)<br>
[timeIntervalSince1970](https://developer.apple.com/documentation/foundation/date/1779963-timeintervalsince1970)<br>
[UITextView](https://developer.apple.com/documentation/uikit/uitextview)<br>
[DateFormatter](https://developer.apple.com/documentation/foundation/dateformatter)<br>
[Create space at the beginning of a UITextField](https://stackoverflow.com/questions/25367502/create-space-at-the-beginning-of-a-uitextfield/27066764#27066764)<br>
[cell 이름으로 register하기](https://github.com/SwifterSwift/SwifterSwift/blob/master/Sources/SwifterSwift/UIKit/UICollectionViewExtensions.swift#L118)<br>
</details>

<details>
<summary>[STEP 2]</summary>
    
[공유하기 버튼](https://royhelen.tistory.com/25)<br>
[FrameWork 만들기](https://www.google.com/url?sa=t&rct=j&q=&esrc=s&source=web&cd=&cad=rja&uact=8&ved=2ahUKEwiIys_Z4uP5AhXZQPUHHTO6AbUQFnoECAkQAQ&url=https%3A%2F%2Fzeddios.tistory.com%2F987&usg=AOvVaw2zfaIUqh_b6GyA2rlZDq_h)<br>
[FrameWork 만들기2](https://www.google.com/url?sa=t&rct=j&q=&esrc=s&source=web&cd=&cad=rja&uact=8&ved=2ahUKEwiCkbaM4-P5AhUMDd4KHSUbCdMQFnoECDgQAQ&url=https%3A%2F%2Ftaeminator1.tistory.com%2F38&usg=AOvVaw1JiLEm2nAOqLXNOEa_ALcC)<br>
[CoreData](https://www.google.com/url?sa=t&rct=j&q=&esrc=s&source=web&cd=&cad=rja&uact=8&ved=2ahUKEwiLkM6l4-P5AhXZVd4KHaOoBJAQFnoECAoQAQ&url=https%3A%2F%2Ficksw.tistory.com%2F224&usg=AOvVaw1rAKCD2RAGhfPSGU20cLCN)<br>
[CoreData2](https://www.google.com/url?sa=t&rct=j&q=&esrc=s&source=web&cd=&cad=rja&uact=8&ved=2ahUKEwiLkM6l4-P5AhXZVd4KHaOoBJAQFnoECAcQAQ&url=https%3A%2F%2Fzeddios.tistory.com%2F987&usg=AOvVaw2zfaIUqh_b6GyA2rlZDq_h)<br>
</details>


<details>
<summary>[STEP 3]</summary>
    
[날씨API 사용법](https://velog.io/@dlskawns96/Swift-%EA%B0%84%EB%8B%A8%ED%95%9C-%EB%82%A0%EC%94%A8-%EC%95%B1-%EB%A7%8C%EB%93%A4%EC%96%B4%EB%B3%B4%EA%B8%B0-01-Swift-OpenWeatherMap) <br>

[날씨 API 데이터 불러오기](https://www.google.com/url?sa=t&rct=j&q=&esrc=s&source=web&cd=&cad=rja&uact=8&ved=2ahUKEwjQ9I-eq_X5AhVa_WEKHZtSAlQQFnoECAwQAQ&url=https%3A%2F%2Fhongssup.tistory.com%2F33&usg=AOvVaw1VCezoyqDgrOqShXPGtrkz)<br>

[Open API](https://devmjun.github.io/archive/OpenWeather)<br>
    
[Swift 현재 위치 받아오기 (위도, 경도)](https://swift-it-world.tistory.com/24)<br>

[CoreData 이미지 저장](https://developer-p.tistory.com/148)<br>
</details>
