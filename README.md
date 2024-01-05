##  일기장

---
### 🔎 목차
- [팀원](#-팀원)
- [타임라인](#-타임라인)
- [시각화 구조](#-시각화-구조)
- [실행화면](#-실행화면)
- [트러블 슈팅 & 고민해본 점](#-트러블-슈팅-&-고민해본-점)
- [참고 링크](#-참고-링크)

---
### 👥 팀원
|Kiseok|Hisop|
|---|---|
|<img src= "https://avatars.githubusercontent.com/u/114901495?v=4" width="200" height="200">|<img src= "https://avatars.githubusercontent.com/u/69287436?v=4" width="200" height="200">|
|[GitHub](https://github.com/carti1108)|[GitHub](https://github.com/Hi-sop)|

### 📅 타임라인
|날짜|내용|
|------|---|
|24.01.02| 프로젝트 구현 시 필요한 내용 개인 공부|
|24.01.03| HomeViewController 구현<br>컨벤션 수정 및 리팩토링|
|24.01.04| DiaryDetailViewController 구현<br>컨벤션 수정 및 리팩토링|
|24.01.05| 컨벤션 수정 및 리팩토링|


### 👀 시각화 구조
#### Class Diagram
- 추후 추가 예정

### 🖥️ 실행화면
|Home|Detail|
|----|------|
|![Simulator Screen Recording - iPhone 15 Pro - 2024-01-05 at 17 22 19](https://github.com/Hi-sop/ios-diary/assets/114901495/33c6fde2-5c0c-47a6-af95-961c369e9bee)|![Simulator Screen Recording - iPhone 15 Pro - 2024-01-05 at 17 29 12](https://github.com/Hi-sop/ios-diary/assets/114901495/0d7b9dfe-939e-4bf0-9510-cd861cced579)|

|keyboard|
|-------|
|![Simulator Screen Recording - iPhone 15 Pro - 2024-01-05 at 17 34 05](https://github.com/Hi-sop/ios-diary/assets/114901495/b2cf4bce-c5da-4c87-a923-c766495c7891)|

### 🔥 트러블 슈팅 & 고민해본 점

#### 키보드 영역 확보

TextView의 입력 영역에 진입했을 때 KeyboardLayout이 TextView의 콘텐츠를 가리게 되므로 이 부분을 수정하고자 했다.

##### NotificationCenter + ContentInset
```swift
private func setUpNotification() {
    NotificationCenter.default.addObserver(
        self,
        selector: #selector(keyboardWillShow),
        name: UIResponder.keyboardWillShowNotification,
        object: nil
    )
}
```
Keyboard가 올라올 때 `UIResponder.keyboardWillShowNotification`이라는 notification을 호출하는 것을 확인했고, 이를 이용하여 keyboardWillShow 메서드를 실행할 수 있도록 했다.

```swift
@objc private func keyboardWillShow(_ notification: Notification) {
    guard let userInfo = notification.userInfo as NSDictionary?,
          var keyboardFrame = (userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue else {
        return
    }
    
    textView.contentInset.bottom = keyboardFrame.size.height
    textView.scrollIndicatorInsets = textView.contentInset
}
```
[contentInset](https://developer.apple.com/documentation/uikit/uiscrollview/1619406-contentinset)을 변경하여 공간을 확보하는 방식으로 구현

##### keyboardLayoutGuide
https://developer.apple.com/videos/play/wwdc2021/10259/
ios15부터 활용 가능하며 더 편리한 방식인 것 같아 keyboardLayoutGuide로 변경

```swift
self.view.keyboardLayoutGuide.topAnchor.constraint(equalTo: textView.bottomAnchor)
```
keyboardLayoutGuide.topAnchor - 키보드가 비활성화일땐 safeArea.bottom과 같게 설정되어있다는 점을 이용했다.

### 📚 참고 링크

[Apple 공식문서 keyboardlayoutguide](https://developer.apple.com/documentation/uikit/keyboards_and_input/adjusting_your_layout_with_keyboard_layout_guide)<br>
[Apple 공식문서 UITextView](https://developer.apple.com/documentation/uikit/uitextview)<br>
[Apple 공식문서 Subscripts](https://docs.swift.org/swift-book/documentation/the-swift-programming-language/subscripts/)
