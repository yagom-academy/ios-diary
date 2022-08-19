
# 📔 일기장

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
| DiaryListView | DiaryView |
|:---:|:---:|
|<img src = "https://i.imgur.com/wDn7Jth.gif" width="250" height="500">|<img src = "https://i.imgur.com/jxKxTVD.gif" width="250" height="500">

## 👨‍👩‍👧‍👦 앱 구성

### fileTree
```
└── Diary  
    ├── .swiftlint
    └── Diary
        ├── Extensions
        │   └── TimeInterval+Extension
        ├── DiaryList
        │   ├── DiaryListCell
        │   ├── DiaryListView
        │   └── DiaryListViewController
        ├── Diary
        │   ├── DiaryView
        │   └── DiaryViewController
        ├── Model
        │   ├── DiaryModel
        │   ├── JsonParser
        │   └── NameSpace
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
    
---

## ✏️ 프로젝트 내용

### 💻 핵심 기능 경험

 - [x] Date Formatter의 지역 및 길이별 표현의 활용
 - [x] Text View의 활용

---

### 🏀 TroubleShooting

1. 시간표현 오류
- 처음 JSON데이터를 받아와서 시간으로 표현해 주기 위해 decoding을 Date타입으로 받아서 처리했더니 다음과 같이 2051년으로 나왔습니다.
- Date타입의 이니셜라이저가 `timeIntervalSinceReferenceDate`를 기준으로 되면 저희가 받아오는 JSON데이터의 값이 약 50년을 나타내서 이 날짜가 나오는 것처럼 보였습니다
- Date의 디폴트가 `timeIntervalSinceReferenceDate`여서 이렇게 표현 됐다고 판단하고 timeInterval을 extension하여 `timeIntervalSince1970`로 변환하여 해결하였습니다.

| 실제시간보다 30년 후로 나온 사진 |
| -------- |
| <img src=https://i.imgur.com/XnC0clw.png width=300> |

2. 파일의 위치 변경에서 오류 
- xcode상에서가 아닌, 실제 파일을 직접 다른 폴더로 옮겨주었는데, 원래 위치에 있던 파일이 없어졌다고 파일이름이 빨간색으로 바뀌기만 하고 실제 옮겨진 파일을 인식하지 못했다. 그래서 해당 커밋을 revert 시키고 이번엔 xcode상에서 파일위치를 옮겨주니 잘 동작을 하였다. 앞으로 파일을 옮길 일이 있으면 꼭 xcode상에서 옮겨야 겠따



