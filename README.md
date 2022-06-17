# 📓 일기장

> 프로젝트 기간: 2022.06.13 ~ 2022.07.01 <br>
> 팀원: [마이노](https://github.com/Mino777), [mmim](https://github.com/JoSH0318), [grumpy](https://github.com/grumpy-sw)
> 리뷰어: ☃️[올라프](https://github.com/1Consumption)

## 🔎 프로젝트 소개
개인의 메모, 일기를 날짜별로 저장하는 일기장 App

## 👨‍👦‍👦 팀원
|마이노|MMIM|Grumpy|
|:---:|:---:|:---:|
|<image width="300" src="https://i.imgur.com/lXxd3Mv.png"/>|<image width="300" src="https://i.imgur.com/0KXcn3Z.jpg"/>|<image width="320" src="https://user-images.githubusercontent.com/63997044/174232212-b7d00822-5848-422d-93bf-8bdefd9bd4bd.png"/>|


## 📺 프로젝트 실행화면
|화면 이동|상세화면 및 수정|
|:-----:|:----------:|
|<image width="300" src="https://i.imgur.com/ZSrR83A.gif"/>|<image width="300" src="https://i.imgur.com/mYUVL7a.gif"/>|
    
|화면 회전|
|:----:|
|<image width="600" src="https://i.imgur.com/ziKOWcp.gif"/>|

## ⏱ 타임라인
|날짜|내용|
|--|--|
|21.06.13|요구사항 파악, 프로젝트 설계|
|21.06.14|STEP1-1, STEP1-2 진행|
|21.06.15|개인공부 진행|
|21.06.16|STEP1 PR 피드백 반영|
|21.06.17|STEP2-1, STEP2-2 진행|
    
## 👀 PR
- [STEP 1](https://github.com/yagom-academy/ios-diary/pull/3)

## 🛠 개발환경 및 라이브러리
- [![swift](https://img.shields.io/badge/swift-5.6-orange)]()
- [![xcode](https://img.shields.io/badge/Xcode-13.4.1-blue)]()
- [![iOS](https://img.shields.io/badge/iOS-15.0-red)]()

## 🔑 키워드
- `MVC`
- `StackView`
- `Json`
- `NavigationBar`
- `TimeInterval`
- `DateFormatter`
- `TableView`
- `NotificationCenter`
- `Keyboard`

## [STEP 1]
    
### 고민한 점
1️⃣ 키보드 hide하는 방법
DetailVC는 모든 영역이 TextView이다. 따라서 키보드를 hide하는 방법에 몇가지 고민을 했다.
1. 키보드를 커스텀하여 inputAccessoryView에 키보드를 hide하는 TollBar를 추가하는 방법
2. gesture recognizer를 이용하여 Pan gesture를 했을 때, 키보드를 hide하는 방법
> 2번 방법은 TextView의 스크롤 gesture와 겹친다. 
> 만약 사용자가 화면을 내리는 gesture를 하게 되면, 사용자가 예상하지 못한 동작을 할 수 있다. 
> 따라서 1번 방법을 선택

2️⃣ 크래시 방지
유효하지 않은 인덱스를 사용할 때 크래시가 나지 않기 위해 subscript를 활용해 크래시를 방지했다.
```swift
extension Collection {
    subscript(safe index: Index) -> Element? {
        return indices.contains(index) ? self[index] : nil
    }
}
```

```swift 
guard let diary = diaryList[safe: indexPath.row] else {
    return
}
```

3️⃣ 편집중인 텍스트가 키보드에 의해 가리지 않게 하는 방법
UITextView의 contentInset을 조정하여 키보드가 화면에 올라왔을 때 텍스트를 가리지 않게 했다.
- 키보드가 올라올 때 UITextView의 bottomAnchor의 constant값을 키보드의 높이만큼 늘인다.
```swift=
detailView.adjustConstraint(by: keyboardSize.height)
```
- 키보드가 내려갈 때 UITextView의 bottomAnchor의 constant값을 0으로 되돌린다.
```swift=
detailView.adjustConstraint(by: .zero)
```



