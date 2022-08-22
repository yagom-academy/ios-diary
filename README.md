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
    * [week1](#week-1)
* [트러블 슈팅](#-트러블-슈팅)
* [참고 문서](#-참고-문서)

<br>

## 👥 팀원
    
| [현이](https://github.com/seohyeon2) | [예톤](https://github.com/yeeton37) |
|:---:|:---:|
|<img src = "https://i.imgur.com/0UjNUFH.jpg" width="200" height="230">|<img src = "https://i.imgur.com/TI2ExtK.jpg" width=200 height = 230>|

<br>

## 📺 실행 화면

| 메인 화면 | 일기장 작성 화면 |
|:---:|:---:|
|<img src = "https://i.imgur.com/XQ0vRmR.gif" width=200 height=400>|<img src = "https://i.imgur.com/YSyuW5Z.gif" width=200 height=400>|

<br>

## 🛠 개발 환경
[![swift](https://img.shields.io/badge/swift-5.6-orange)]()
[![xcode](https://img.shields.io/badge/Xcode-13.4.1-blue)]()
[![swiftLint](https://img.shields.io/badge/SwiftLint-13.2-green)]()

<br>

## 💻 핵심 경험
- [x] Date Formatter의 지역 및 길이별 표현의 활용
- [x] Text View의 활용

<br>

## 🕖 타임 라인

### Week 1
- **2022-08-16 (화)**
  - 일기장 STEP 1: Layout 공식문서 공부

- **2022-08-17 (수)**
  - 일기장 STEP 1-1: 메인화면 UI 구현 및 지역별로 작성일자 표현 다르게 구현

- **2022-08-18 (목)**
  - 일기장 STEP 1-2: 일기장 작성 UI 구현 및 키보드 이벤트 구현
  
- **2022-08-19 (금)**
  - 일기장 STEP 1: 리팩토링 및 Readme.md 작성 

<br>

## 🔧 구현 내용

|구현 위치(파일명)|핵심 구현 내용|
|:--|:--|
|`SceneDelegate`|`UIWindow`를 이용하여 스토리보드 없이 화면 구현|
|`DetailDiaryViewController`|`NotificationCenter`를 이용한 키보드 이벤트 구현 |
|`MainViewController`|`UITableViewDiffableDataSource`와 `snapshot`을 이용해서 데이터 관리|
|`JSONData`|json파일을 decoder 해주는 `parse` 메서드 구현|
|`DiarySample`|견본 JSON 데이터의 매핑 타입 구현|
|`DiaryTableViewCell`|customViewCell 구현|
|`DateFormatter + Extention`|사용자 지역에 맞게 작성일자를 표기해주는 `format`구현|

<br>

## 🚀 트러블 슈팅

### 1. 중복 데이터로 인한 오류
- 오류 내용
    >Terminating app due to uncaught exception 'NSInternalInconsistencyException', 
reason: 'Fatal: supplied item identifiers are not unique. Duplicate identifiers:
- 문제 상황
    - 견본 JSON 데이터에 중복된 데이터가 존재하여 앱 실행과 동시에 앱이 종료 되었습니다.

- 해결 방법
    - `let id = UUID()` 
    - 위 코드를 매핑 타입에 추가하여 데이터마다 고유번호를 지정해줌으로써 해결했습니다.

---

## 🔗 참고 문서

- [Adaptivity and Layout](https://developer.apple.com/design/human-interface-guidelines/foundations/layout/)
- [UIKit: Apps for Every Size and Shape](https://developer.apple.com/videos/play/wwdc2018/235/)
