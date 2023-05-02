# 일기장 📕

> **소개: 코어데이터를 활용하여 일기장 앱을 만드는 프로젝트**


</br>

## 목차
1. [팀원](#1-팀원)
2. [타임라인](#2-타임라인)
3. [프로젝트 구조](#3-프로젝트-구조)
4. [실행화면](#4-실행-화면)
5. [트러블슈팅](#5-트러블-슈팅)

<br>

## 1. 팀원

|[레옹아범](https://github.com/fatherLeon)| [kaki](https://github.com/kak1x) |
| :--------: | :--------: |
|<img height="180px" src="https://raw.githubusercontent.com/Rhode-park/ios-rock-paper-scissors/step02/image/leonFather.jpeg">| <img height="180px" src="https://i.imgur.com/KkFB7j3.png"> |

<br>

## 2. 타임라인
#### 프로젝트 진행 기간 : 23.04.24 (월) ~ 23.04.28 (금)

| 날짜 | 타임라인 |
| --- | --- |
|23.04.24 (월)| 프로젝트 초기 세팅 및 컨벤션 합의, SwiftLint 적용 |
|23.04.25 (화)| DiaryViewController, DiaryInfoTableViewCell 구현 |
|23.04.26 (수)| DiaryDetailViewController 구현, 코드 컨벤션 수정 |
|23.04.27 (목)| 전체 코드 리팩토링 및 Keyboard 화면 가림 방지 로직 변경 |
|23.04.28 (금)| 코드 컨벤션 수정, README 작성 |

<br>

## 3. 프로젝트 구조

#### 폴더구조

``` swift
Diary
    ├── .swiftlint.yml
    ├── Model
    |    └── Diary
    ├── View
    |    └── DiaryInfoTableViewCell
    ├── Controller
    |    ├── DiaryViewController
    |    └── DiaryDetailViewController
    ├── Etc
    |    ├── ReuseIdentifiable
    |    ├── ArrayExtension
    |    └── DateExtension
    ├── AppDelegate
    ├── SceneDelegate
    ├── Assets
    ├── LaunchScreen
    ├── Info
    └── Diary.xcdatamodeld
```

</br>

## 4. 실행 화면

|**일기장 초기 화면**|**기존 일기 조회 페이지**|**새로운 일기 작성 페이지**|
|:-----:|:-----:|:-----:|
| <img src = "https://user-images.githubusercontent.com/51234397/235034788-8dd64d8c-4567-4b78-b062-f31cb8d1bf86.gif" width = "300">|<img src = "https://user-images.githubusercontent.com/51234397/235034793-62ef393a-fe30-4887-b3b6-1fbb2c44a5e5.gif" width = "300"> |<img src = "https://user-images.githubusercontent.com/51234397/235034796-8a0f2b3d-cc71-4ff4-af6e-350c07718e21.gif" width = "300">|

<br>

## 5. 트러블 슈팅

### 1️⃣ 편집중인 텍스트가 키보드에 의해 가려지는 문제

```swift
extension DiaryDetailViewController: UIViewController {
    private func setUpNotification() {
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(showKeyboard),
            name: UIResponder.keyboardWillShowNotification,
            object: nil
        )
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(hideKeyboard),
            name: UIResponder.keyboardWillHideNotification,
            object: nil
        )
    }
    
    @objc private func showKeyboard(_ notification: Notification) {
        guard let userInfo = notification.userInfo,
              var keyboardFrame = userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect else { return }
        
        keyboardFrame = view.convert(keyboardFrame, from: nil)
        var contentInset = textView.contentInset
        contentInset.bottom = keyboardFrame.size.height
        textView.contentInset = contentInset
        textView.scrollIndicatorInsets = textView.contentInset
    }
    
    @objc private func hideKeyboard(_ notification: Notification) {
        textView.contentInset = UIEdgeInsets.zero
        textView.scrollIndicatorInsets = textView.contentInset
    }
}
```

* 수정하고 싶은 텍스트 뷰 내용을 클릭할 경우 키보드에 의해 해당 내용이 가려지는 문제가 있었습니다.
* 이를 해결하기 위해 `UIResponder`의 Keyboard관련 `Notification`을 사용하여 키보드가 나타나고 사라질때 알림을 받아 처리하는 방식으로 구현하였습니다.
* 그러나, 코드의 길이가 길고 가독성을 해치는 부분이 많아 아래와 같이 구현하였습니다.

### ⚒️ 해결방법
```swift
NSLayoutConstraint.activate([
    diaryTextView.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor),
    diaryTextView.leadingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leadingAnchor),
    diaryTextView.trailingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.trailingAnchor),
    diaryTextView.bottomAnchor.constraint(equalTo: self.view.keyboardLayoutGuide.topAnchor)
])
```
- iOS 15 버전부터 지원하는 `keyboardLayoutGuide`를 사용하여 매우 간단하게 이를 구현할 수 있었습니다.
- 이를 사용하기 위해 프로젝트의 `Minimum Deployments`를 iOS 15.0로 설정해주었습니다.
- diaryTextView의 `bottomAnchor`를 `keyboardLayoutGuide.topAnchor`쪽에 constraint을 맞춰주는 것만으로 사용이 가능했습니다.
