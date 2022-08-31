
# 📔 일기장

###### tags: `README`

## 목차
* [프로젝트 저장소](#-💾-프로젝트-저장소)
* [팀원](#-👥-팀원)
* [실행화면](#📺-실행-화면)
* [앱구성](#👨‍👩‍👧‍👦-앱-구성)
    * [fileTree](#fileTree)
    * [UI](#UI)
* [개발환경 및 라이브러리](#🛠-개발환경-및-라이브러리)
* [타임라인](#🕖-타임라인:-시간-순으로-프로젝트의-주요-진행-척도를-표시)
    * [week1](#Week-1)
    * [week2](#Week-2)
* [프로젝트 내용](#✏️-프로젝트-내용)
    * [핵심 기능 경험](#💻-핵심-기능-경험)
* [트러블 슈팅](#🏀-TroubleShooting)
* [참고한 페이지](#참고한-페이지)

## 💾 프로젝트 저장소
>**프로젝트 기간** : 2022.08.16 ~ 2022.09.02<br>
**소개** : 텍스트뷰를 통해 입력한 일기장을 코어데이터에 저장하고 리스트를 보여주는 앱 <br>
**리뷰어** : [**쿠마**](https://github.com/leejun6694)

## 👥 팀원
    
| [웡빙](https://github.com/wongbingg) | [언체인](https://github.com/unchain123) |
|:---:|:---:|
|<img src = "https://i.imgur.com/ghuxjis.png" width="250" height="250">|<img src = "https://i.imgur.com/GlPnCo7.png" width="250" height="250">|


---
## 📺 실행 화면

| 새로운 일기생성 | 새로운 일기생성2 | 
|:---:|:---:|
|<img src = "https://i.imgur.com/VfdObZB.gif" width="250" height="500">|<img src = "https://i.imgur.com/ETR7gTZ.gif" width="250" height="500">|

| 일기 공유 | 일기 공유2 | 
|:---:|:---:|
|<img src = "https://i.imgur.com/YxX0yRb.gif" width="250" height="500">|<img src = "https://i.imgur.com/Dd2KeW5.gif" width="250" height="500">|

| 일기 삭제 | 일기 삭제2 | 일기 삭제3 |
|:---:|:---:|:---:|
|<img src = "https://i.imgur.com/GRVDElJ.gif" width="200" height="400">|<img src = "https://i.imgur.com/wMj7Jaf.gif" width="200" height="400">|<img src = "https://i.imgur.com/jJRuBMu.gif" width="200" height="400">|

## 👨‍👩‍👧‍👦 앱 구성

### fileTree
```
└── Diary
    ├── CoreData
    │   ├── Diary+CoreDataClass
    │   ├── Diary+CoreDataProperties
    │   └── CoreDataManager
    ├── DiaryList
    │   ├── DiaryListView
    │   ├── DiaryListViewController
    │   └── DiaryListCell
    ├── Diary
    │   ├── DiaryView
    │   ├── DiaryViewController
    │   └── MyActivityItemSource
    ├── Model
    │   ├── DiaryModel
    │   ├── JsonPaser
    │   ├── NameSpace
    │   └── PageMode
    ├── Extensions
    │   ├── TimeInterval+Extension
    │   └── Notification.Name+Extension
    ├── AppDelegate
    ├── SceneDelegate
    ├── Info.plist
    └── Diary.xcdatamodeld
```
### UI
<img src = "https://i.imgur.com/GmJZ6uC.png" width="500" height="220">

## 🛠 개발환경 및 라이브러리

[![xcode](https://img.shields.io/badge/Xcode-13.4.1-blue)]() [![swiftLint](https://img.shields.io/badge/SwiftLint-0.47.1-green)]()
---

## 🕖 타임라인: 시간 순으로 프로젝트의 주요 진행 척도를 표시

### Week 1
<details>
    
- 2022.08.16(화)
    - GroundRule 작성
    - SwfitLint 적용
    - TableView, Cell 생성
- 2022.08.17(수) - [`STEP1 PR`](https://github.com/yagom-academy/ios-diary/pull/36#event-7219002628)
    - JSONPaser를 통한 JSON파일 등록
    - Diary의 내용을 보는 두번째 뷰 생성
- 2022.08.18(목)
    - CoreData 개인학습
- 2022.08.19(금) - `STEP1 REFACTORING`
    - Step1 리펙토링
    - Readme 작성
    
</details>

### Week 2
<details>
    
- 2022.08.22(월)
    - CoreData구현
    - TableView의 셀데이터를 CoreData로 변경
- 2022.08.23(화)
    - CoreData 세부구현
        - Create
        - Read
        - Update
        - Delete
- 2022.08.24(수)
    - Step2 요구사항 구현 완료 및 리팩터링
- 2022.08.25(목) - [`STEP2 PR`](https://github.com/yagom-academy/ios-diary/pull/46)
    - 네임스페이스 분리, 코드 컨벤션 통일
- 2022.08.26(금)
    - Readme 작성
    
</details>
    
---

## ✏️ 프로젝트 내용

### 💻 핵심 기능 경험

 - [x] Date Formatter의 지역 및 길이별 표현의 활용
 - [x] Text View의 활용

---

## 🏀 TroubleShooting

### 1. 시간표현 오류
- 처음 JSON데이터를 받아와서 시간으로 표현해 주기 위해 decoding을 Date타입으로 받아서 처리했더니 다음과 같이 2051년으로 나왔습니다.
- Date타입의 이니셜라이저가 `timeIntervalSinceReferenceDate`를 기준으로 되면 저희가 받아오는 JSON데이터의 값이 약 50년을 나타내서 이 날짜가 나오는 것처럼 보였습니다
- Date의 디폴트가 `timeIntervalSinceReferenceDate`여서 이렇게 표현 됐다고 판단하고 timeInterval을 extension하여 `timeIntervalSince1970`로 변환하여 해결하였습니다.

| 실제시간보다 30년 후로 나온 사진 |
| -------- |
| <img src=https://i.imgur.com/XnC0clw.png width=300> |

### 2. 파일의 위치 변경에서 오류 
- xcode상에서가 아닌, 실제 파일을 직접 다른 폴더로 옮겨주었는데, 원래 위치에 있던 파일이 없어졌다고 파일이름이 빨간색으로 바뀌기만 하고 실제 옮겨진 파일을 인식하지 못했다. 그래서 해당 커밋을 revert 시키고 이번엔 xcode상에서 파일위치를 옮겨주니 잘 동작을 하였다. 앞으로 파일을 옮길 일이 있으면 꼭 xcode상에서 옮겨야 겠다.


### 3. TextView 에서 행끼리 줄어드는 현상 오류

- attributedString의 사용에서 문제가 발생한 것으로 확인. 제목과 본문을 연결해주기 위해 "\n\n" 문자열 자체를 append 시켜주었더니 오류가 발생했다. 해당 문자열을 append가 아닌 diaryTitle 뒤에 더해주었더니 오류해결
```swift!
let attributedString = NSMutableAttributedString(string: diaryTitle,
                                                         attributes: [NSAttributedString.Key.font: UIFont.preferredFont(forTextStyle: .title1)])
attributedString.append("\n\n") // 이 부분 때문에 오류가 발생
attributedString.append(NSMutableAttributedString(string: diaryBody,
                                                          attributes: [NSAttributedString.Key.font: UIFont.preferredFont(forTextStyle: .body)]))
        
return attributedString
}
```
|오류화면|오류수정화면|
|:--:|:--:|
|<img src="https://i.imgur.com/5bxnHpk.png" width=200>|<img src="https://i.imgur.com/Mqdb5fN.png" width=200>|


### 4. ActivityViewTitle
- ActicityViewController의 Title에 일기의 제목과 본문을 넣으려고 처음엔 아래 처럼 배열을 넣어줬더니 아래의 사진과 같이 윗부분은 Plain Text라고 나오고 저희가 넣어준 제목과 본문은 한줄로 나오는 현상이 발생했습니다.
```swift
UIActivityViewController(activityItems: ["title", body], applicationActivities: nil)
```
- 그래서 찾은 방법이 MyActivityItemSource를 통해서 각각의 상황에 맞는 아이템을 지정해 주는 방법이었습니다. 여기서 우리가 원하는 plain Text의 위치에 제목이 들어가기 위해 MyActivityItemSource프로토콜의 메서드 중 subjectForActivityType을 title로 지정하고 여기에 제목을 넣어주는 방법을 통해 지금의 결과를 얻어 낼 수 있었습니다.

|오류 상황|현재 상황|
|:--:|:--:|
|<img src = "https://i.imgur.com/nI4QX5f.png" width="200" height="200">|<img src = "https://i.imgur.com/amp0N1U.png" width="200" height="200">|
