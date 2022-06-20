# 일기장

## 소개
> 작성중...
 
일기장 프로젝트입니다.

## 팀원 소개
|iOS|iOS|
|:---:|:---:|
|[Minseong](https://github.com/Minseong-yagom)|[Lingo](https://github.com/llingo)|
|<img width="150" src="https://avatars.githubusercontent.com/u/94295586?v=4"/>|<img width="150" src="https://avatars.githubusercontent.com/u/94151993?v=4"/>|

## 타임라인
|날짜|진행|
|:---:|:---:|
|06.13|일기장 STEP1 진행에 필요한 내용 각자 사전공부|
|06.14|프로젝트 초기 환경설정 및 그라운드 룰|
|06.15|UI 화면 구현 및 PR 제출|
|06.16|부가적인 기능 추가 및 리팩토링 진행|
|06.17|PR 피드백에 대한 리팩토링 진행|

## 프로젝트 구조

> 프로젝트 진행 중...

![](https://i.imgur.com/9HSVWek.png)



## 실행화면 
|앱 시작 화면|메인 ➡️ 상세 페이지: 화면 이동|
|:---:|:---:|
|![](https://i.imgur.com/1rdc0se.gif)|![](https://i.imgur.com/mZOXDKK.gif)|

|상세 페이지: 키보드 동작|상세 페이지: 화면 스크롤|
|:---:|:---:|
|![](https://i.imgur.com/GwlZEkK.gif)|![](https://i.imgur.com/7CcukgS.gif)|

|메인 페이지: 가로모드 변경|상세 페이지: 가로모드 변경|
|:---:|:---:|
|![](https://i.imgur.com/DsP7Kca.gif)|![](https://i.imgur.com/ovY1meA.gif)|

## 트러블 슈팅

**TextView의 contentInset를 주었을 때에 대해**

![](https://i.imgur.com/wcS3Z8V.gif)

`bodyTextView.contentInset`을 키보드의 높이만큼 올려주어 입력 중인 부분이 키보드에 가려지지 않게 하는 과정에서 위 gif를 보면 중간 부분에 커서를 위치시킨 후 입력했을 땐 `contentInset`의 변화에 따른 화면 스크롤이 되지 않고 커서가 키보드와 근접한 상태에서는 스크롤이 자동으로 되는 원리 (즉, 무엇을 기준으로 판단하여 작동하는 건지?)에 대한 문제가 있었다.

> 해결책

UITextView 의 경우는 cursor 의 위치를 기반으로 스크롤이 조절되는 것을 발견
그래서 추론을 해 보면 contentInset 값이 바뀔 때 UITextView 에서 현재 뷰 frame을 기준으로 cursor의 위치를 계산한 뒤에 커서 위치 + 변경되는 contentInset (여기서는 bottom 값)를 했을 때 frame 사이즈를 넘어가면 커서의 위치를 적절하게 스크롤하는 처리가 들어가 있는게 아닌가 추론하였다.

## 참고
- [Adaptivity and Layout](https://developer.apple.com/design/human-interface-guidelines/foundations/layout/)
- [UIKit: Apps for Every Size and Shape](https://developer.apple.com/videos/play/wwdc2018/235/)
- [Making Apps Adaptive, Part 1 / Script](https://www.youtube.com/watch?v=hLkqt2g-450)
- [Making Apps Adaptive, Part 2 / Script](https://www.youtube.com/watch?v=s3utpBiRbB0)
- [DateFormatter](https://developer.apple.com/documentation/foundation/dateformatter)
- [UITextView](https://developer.apple.com/documentation/uikit/uitextview)
