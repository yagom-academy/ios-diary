# 📔 일기장 프로젝트
> 프로젝트 기간: 2022-06-13 ~ 2022-07-01
> 
> 팀원: [dudu](https://github.com/firstDo) [papri](https://github.com/papriOS) 
> 
> 리뷰어: [린생](https://github.com/jungseungyeo)

## 🔎 프로젝트 소개

> 나의 일기장

## 📺 프로젝트 실행화면



## 👀 PR
- [STEP1](https://github.com/yagom-academy/ios-diary/pull/1)

## 🛠 개발환경 및 라이브러리
- [![swift](https://img.shields.io/badge/swift-5.0-orange)]()
- [![xcode](https://img.shields.io/badge/Xcode-13.0-blue)]()
- [![iOS](https://img.shields.io/badge/iOS-15.0-red)]()

## 🔑 키워드

`SwiftLint`
`UITableView`
`UITableViewDiffableDataSource`
`Date Formatter`
`keyboardLayoutGuide`
`View Drawing Cycle`

## ✨ 구현내용

### DiaryTableViewController

- 일기들을 list 형태로 보여주는 화면

### DirayViewController

- 일기 전문을 보여주는 화면

## 📖 학습내용

- keyboardLayoutGuide
- UITableViewDiffableDataSource / NSDiffableDataSourceSnapshot
- View Drawing Cycle
- ContentOffset, setContentOffset(:)

## 🤔 STEP별 고민한 점 및 해결한 방법

## [STEP 1]

### 1. TextView가 중간부터 시작하는 문제

![](https://i.imgur.com/7WLjXsL.gif)

TextView가 길어지면, 위가 살짝 잘린채로 시작하는 문제가 있었습니다. 처음에는 TextView의 상단이 navigationBar에 가려진건가 싶어서 textView의 top을 view의 safeArea.top에 맞춰봤지만, 문제가 해결되지 않았습니다.

처음에는 저희가 뭔가 잘못한 줄 알았는데 찾아보니 textView는 원래 그렇다고 하더라고요..?
viewDidLoad에서 diaryTextView.contentOffset = .zero로 설정해서 해결했습니다

### 2. TextView가 키보드에 가려지는 문제

원래는 전통적으로 사용하던 KeyboardNotification을 사용하여 해결하려 했으나, iOS15 부터 사용가능한 [KeyboardLayoutGuide](https://developer.apple.com/documentation/uikit/uiview/3752221-keyboardlayoutguide)를 사용해 봤습니다.

Project의 iOS deployment target이 15.2로 설정되어 있어 위의 방식을 사용해보고자 하였고,
이 과정에서 Target의 deployment 버전을 14에서 15로 변경하였습니다.

### 3. 파일 그룹핑 방식

뷰 컨트롤러가 많아질 것을 고려하여, 가독성을 위해 한 화면(Scene)을 기준으로 그룹을 나눠보았습니다. 

