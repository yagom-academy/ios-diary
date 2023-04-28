# 일기장📝

## 프로젝트 소개
> 일기를 작성하고 리스트를 통해 작성한 일기를 볼 수 있는 어플리케이션
> 
> 프로젝트 기간: 2023.04.24 - 2023.05.13

## 목차 :book:


- [1. 팀원을 소개합니다 👀](#팀원을-소개합니다-) 
- [2. 파일트리 🌲](#file-tree-)
- [3. 타임라인 ⏰](#타임라인-) 
- [4. 실행 화면 🎬](#실행-화면-) 
- [5. 트러블슈팅 🚀](#트러블-슈팅-) 
- [6. 핵심경험 📌](#핵심경험-)
- [7. Reference 📑](#reference-) 

</br>

## 팀원을 소개합니다 👀

|<center>[Rhode](https://github.com/Rhode-park)</center> | <center> [무리](https://github.com/parkmuri)</center> | 
|--- | --- |
|<Img src = "https://i.imgur.com/XyDwGwe.jpg" width="300">|<Img src ="https://i.imgur.com/SqON3ag.jpg" width="300" height="300"/>|


</br>

## File Tree 🌲

```typescript
Diary
├── Diary
│   ├── App
│   │   ├── AppDelegate.swift
│   │   └── SceneDelegate.swift
│   ├── Model
│   │   └── Diary
│   ├── View
│   │   ├── LaunchScreen
│   │   └── DiaryListCell.swift
│   ├── Controller
│   │   ├── DiaryListViewController.swift
│   │   └── DetailDiaryViewController.swift
│   ├── Extra
│   │   └── DiaryDataDecoder.swift
│   ├── Resource
│   │   ├── Info
│   │   └── Assets
│   └── Extension
│       └── Date+.swift
├── Diary
└── .swiftlint
```


</br>

## 타임라인 ⏰

|<center>날짜</center> | <center>타임라인</center> |
| --- | --- |
| **2023.04.24** | - 스토리보드 연결 해제 </br>- DiaryListViewController의 tableView, customCell 구현 </br>- Diary모델 및 Decoder 객체 구현  |
| **2023.04.25** | - SwiftLint 적용 </br> - DetailDiaryViewController구현 및 화면 전환 구현 </br>- NotificationCenter 이용하여 키보드 구현 </br> - NameSpace.swift파일 생성|
| **2023.04.26** | - DetailDiaryViewController에서 키보드 hide를 위한 변수 생성 </br> - textView레이아웃 로직 수정 |
| **2023.04.27** | - DetailDiaryViewController의 viewWillDisappear메서드 삭제 </br> - NSLayoutConstraint constant 활용하여 레이아웃 변경 적용 |
| **2023.04.28** | - NameSpace.swift파일 각 뷰컨트롤러에 private로 선언|

</br>

## 실행 화면 🎬
|<center>일기 리스트</center>|<center>추가 화면</center>|<center>일기 상세</center>|<center>키보드 구현</center>|
|---|---|---|---|
|<img src="https://i.imgur.com/5Mw8FRD.gif" width="250">|<img src="https://i.imgur.com/iYhfFC0.gif" width="250">|<img src="https://i.imgur.com/Fa9YMlu.gif" width="250">|<img src="https://i.imgur.com/CrpyBIy.gif" width="250">|

</br>

## 트러블 슈팅 🚀
### 1️⃣ 키보드가 나오고 들어갈 때 view의 constraint 변경하기
일기를 작성하거나 수정하기 위해 일기의 내용을 터치하면 키보드가 나와서 입력이 가능하도록 구현해야 했습니다. 하지만 키보드가 올라와도 `TextView`의 `bottomAnchor`는 이미 `view.safeAreaLayoutGuide.bottomAnchor`로 제약이 걸려있는 상황이었기 때문에 아래쪽에 있는 내용은 키보드에 가려지게 되었습니다. 
이를 해결하기 위해 키보드가 올라왔을때, `TextView`의 `bottomAnchor`를 키보드의 높이만큼 빼주어 작아진 뷰를 가지게 하고싶었습니다. 
**수정 전**
```swift
// DetailDiaryViewController.swfit
private var bottomConstraint: NSLayoutConstraint?

private func configureConstraint() {
    bottomConstraint = diaryTextView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
    bottomConstraint?.isActive = true
// ...
}

@objc
private func keyboardWillShow(notification: NSNotification) {
    // ...
        UIView.animate(withDuration: 5) {
            self.bottomConstraint?.isActive = false
            self.bottomConstraint = self.diaryTextView.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor, 
                                                                               constant: -changedHeight)
            self.bottomConstraint?.isActive = true
        }
    // ...
}

@objc
private func keyboardWillHide(notification: NSNotification) {
    UIView.animate(withDuration: 5) {
        self.bottomConstraint?.isActive = false
        self.bottomConstraint = self.diaryTextView.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor)
        self.bottomConstraint?.isActive = true
    }
}
```
위의 코드와 같이 작성했을 때, isActive의 반복되는 코드로 가독성이 매우 좋지않아보였습니다. 

**수정 후**
`NSLayoutConstraint`의 `constant`프로퍼티를 알게되어 위의 코드에 적용시켜보았습니다.
```swift
// DetailDiaryViewController.swift
private func configureConstraint() {
    bottomConstraint = diaryTextView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
    bottomConstraint?.isActive = true
    // ...
}

@objc
private func keyboardWillShow(notification: NSNotification) {
    if let keyboardFrame: NSValue =
        notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue,
       let firstWindow = UIApplication.shared.windows.first {
        // ...
        let changedHeight = -(keyboardHeight - firstWindow.safeAreaInsets.bottom)
        bottomConstraint?.constant = changedHeight
    }
}

@objc
private func keyboardWillHide(notification: NSNotification) {
    bottomConstraint?.constant = 0
}        
```
필요하지 않은 코드가 삭제되어 한결 더 가독성이 좋은 코드가 되었습니다.

</br>

## 핵심 경험 📌
<details>
<summary><big>✅ TextView의 활용 </big></summary>

TextView를 사용하여 view에 일기장 내용을 띄우면서도 그 내용을 수정할 수 있게 하였습니다. 
    
```swift
private let diaryTextView: UITextView = {
    let textView = UITextView()
    textView.font = UIFont.preferredFont(forTextStyle: .body)
    textView.adjustsFontForContentSizeCategory = true
    textView.translatesAutoresizingMaskIntoConstraints = false
    textView.text = NameSpace.diaryPlaceholder
    
    return textView
}()
```


</details>

<details>
<summary><big>✅ DateFormatter의 활용 </big></summary>

Date에 extension을 두어 원하는 형식으로 날짜를 변형시켜주었습니다. 
    
```swift
extension Date {
    func convertDate() -> String {
        let dateFormatter = DateFormatter()
        
        dateFormatter.dateFormat = "yyyy년 MM월 dd일"
        
        let convertedDate = dateFormatter.string(from: self)
        
        return convertedDate
    }
}
```
    
</details>

</br>

## Reference 📑
- [🍎 Apple Developer 공식문서 - UITextView ](https://developer.apple.com/documentation/uikit/uitextview)
- [🍎 Apple Developer 공식문서 - DateFormatter ](https://developer.apple.com/documentation/foundation/dateformatter)
- [🍎 Apple Developer 공식문서 - NotificationCenter ](https://developer.apple.com/documentation/foundation/notificationcenter)
- [🍎 Apple Developer 공식문서 - NSNotification-Name-UIKit ](https://developer.apple.com/documentation/foundation/nsnotification/name#3875993)
- [🍎 Apple Developer 공식문서 - NsLayoutConstraint-constant ](https://developer.apple.com/documentation/uikit/nslayoutconstraint/1526928-constant)


