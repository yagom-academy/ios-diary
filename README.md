# 📔 일기장

> 프로젝트 기간: 2022.06.13 ~ 2022.07.01 
> 팀원: [우롱차](https://github.com/dnwhd0112), [Red](https://github.com/cherrishRed) 리뷰어: [웨더](https://github.com/SungPyo)

## 목차 

## 프로젝트 소개 
📔 일기장
나만의 일기를 만들어 보세요!
저장을 깜빡하셨다구요? 걱정 없습니다. 
자동저장 됩니다!

## 타임라인
- [x] 첫째주 : 화면구성, 키보드, Core Data CRUD 구현
- [ ] 둘째주 : 
- [ ] 셋째주 : 


## 프로젝트 구조

보류

## 프로젝트 실행 화면
![](https://i.imgur.com/tJfrO7x.gif)

## 🚀 트러블 슈팅
### STEP1
* 키보드 올라오고 내려가는거에 따른 View 변경
* iOS 낮은 버전 시뮬레이터 실행

### 키보드 올라오고 내려가는거에 따른 View 변경
`🤔문제` 
아래 코드와 같이 키보드 관련하여 레이아웃을 주면 textFied 나 textView 가 키보드에 가려지지 않게 알아서 bottom 레이아웃을 수정한다.
```swift
textView.bottomAnchor.constraint(equalTo: keyboardLayoutGuide.topAnchor).isActive = true
```
하지만 위의 기능은 iOS 15버전부터 지원하기 때문에 낮은 버전에서는 실행되지 않았다.

`😆해결`
`if #available(iOS 15.0, *)`를 사용해서 iOS 15.0 보다 버전이 낮다면, Notification을 이용해 키보드가 나타날 때, 메서드를 통해서 아래의 오토레이아웃을 적용해 주었다.

```swift
textViewBottomConstraint = textView.bottomAnchor.constraint(
            equalTo: safeAreaLayoutGuide.bottomAnchor,
            constant: -height // 여기서 height 는 키보드의 높이
        )
```
이때 기존에 적용된 오토레이아웃을 해제해줘야되기 때문에 변수로 관리를 해야한다.

```swift
@objc private func keyBoardShow(notification: NSNotification) {
    guard let userInfo: NSDictionary = notification.userInfo as? NSDictionary else {
        return
    }
    guard let keyboardFrame = userInfo.value(forKey: UIResponder.keyboardFrameEndUserInfoKey) as? NSValue else {
        return
    }
    let keyboardRectangle = keyboardFrame.cgRectValue
    let keyBoardHeight = keyboardRectangle.height
    detailView.changeTextViewHeight(keyBoardHeight)
}
```
키보드의 높이는 Notification 을 이용하면 위의 코드처럼 가져올 수 있다. 

### iOS 낮은 버전 시뮬레이터 실행
`🤔문제`
낮은 버전의 iOS 시뮬레이터를 돌릴 수가 없었다.

`😆해결`
![](https://i.imgur.com/UmDj211.png)
위쪽 시뮬레이터 선택하는 창에서 Download Simulators 를 선택하여 낮은 버전의 시뮬레이터를 설치하면 된다. 하지만 빌드되는 버전에 설정에 따라 실행이 되지 않을수도 있으니 주의해야한다.

🛑 이부분 해결하고 다시 작성하기

### STEP2
* Core Data Fetch 문제

### Core Data Fetch 문제
`🤔문제`
![](https://i.imgur.com/5ItH8hw.png)
설명 : CoreData에서 fetch로 가져온 데이터 배열을 바로 접근할려고할때 생기는 문제.(다른 팀들에는 이러한 문제가 없었다. 오류문도 Expected DiaryData but found DiaryData로 이상하다.) 

`😆해결`
이를 해결하기 위해 `as [AnyObjcet]`으로 형변환을 시켰다.

🛑 궁극적인 해결을 하고 다시 작성해 보자...
왜 우리만 이런 오류가 생길까...

## ✏️ 학습내용
* CoreData
* KeyBoard
