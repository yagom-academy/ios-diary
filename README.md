# 📕Diary

- **프로젝트 기간** : 2023.08.28 ~ 2023.09.15
- **프로젝트 팀원** : [hoon 🐝](https://github.com/Hoon94), [Karen 🦦](https://github.com/karenyang835)
- **프로젝트 리뷰어** : [July 🍀](https://github.com/July911)

## 🔖 목차 
1. [프로젝트 소개](#1.)
2. [실행 화면](#2.)
3. [시각적 프로젝트 구조](#3.) 
4. [트러블 슈팅](#4.)
5. [참고 링크](#5.)

---

</br>

<a id="1."></a>
## 1. 💬 프로젝트 소개
> `CoreData`를 활용하여 만든 일기장 앱으로 수정이 간편하고, 날짜별로 일기장 검색이 가능합니다.

[![Xcode](https://img.shields.io/badge/Xcode-14.3.1-blue?style=flat&logo=Xcode&logoColor=)]() [![swift](https://img.shields.io/badge/swift-5.6-red?style=flat&logo=Swift&logoColor=)]() [![IOS](https://img.shields.io/badge/iOS-15.0+-orange?style=flat&logo=Apple&logoColor=white)]()

---
</br>

<a id="2."></a>

## 2.📱실행 화면
| Diary - 화면 동작 |Diary - 키보드 동작 / 새 일기장 |
| :-: |:-: |
|<img src="https://github.com/karenyang835/pr-exercise/assets/124643896/a1d1cc15-1bde-4478-90c7-17c56aa4cee7" style="zoom:70%;" />|<img src="https://github.com/karenyang835/pr-exercise/assets/124643896/08efdbae-f95e-42eb-a651-9c93ae420bc8" style="zoom:70%;" />| 

| Diary - 가로 화면 (Dynamic type) |
| :-: |
|<img src="https://github.com/karenyang835/pr-exercise/assets/124643896/1f931584-8060-4f96-ba0a-029aebb94b9c" style="zoom:80%;" />|


---

</br>


<a id="3."></a>
## 3. 📊 시각적 프로젝트 구조
</br>

### 📂 폴더 구조

```swift
┌── Diary
│   ├── Model
│   │   └── DiaryModel
│   ├── View
│   │   ├── main
│   │   ├── LaunchScreen
│   │   └── DiaryCell
│   ├── Controller
│   │   ├── DiaryViewController
│   │   └── DiaryDetailViewController
│   ├── Extension
│   │   └── DateFormatter+
│   ├── Application
│   │   ├── AppDelegate
│   │   └── SceneDelegate
│   └── Resource
│       ├── Assets
│       └── Info
│
└── README.md
```

---

</br>



<a id="4."></a>

## 4. 🚨 트러블 슈팅

### 1️⃣ 지역별 현지화

#### ⛔️ 문제점
- 다이어리의 작성 일자에 대한 날짜 표현 형식을 사용자에 맞게 표현해 주기 위한 방법이 필요했습니다. JSON 파일에 저장된 날짜는 시스템 시간으로 1970년을 기준으로 한 `Double` 타입의 값이었기 때문에 사용자에게 표현하는 형식을 선택해야 했습니다.


#### ✅ 해결 방법
- JSON 파일에서 받아온 날짜를 디바이스의 지역에 맞는 형식으로 표현해 주기 위해 아래와 같이 Locale을 사용하였습니다.

    ```swift
    extension DateFormatter {
        static let diaryFormatter = {
            let formatter = DateFormatter()
            formatter.dateStyle = .long
            formatter.locale = Locale.current

            return formatter
        }()
    }

    // 적용
    let date = Date(timeIntervalSince1970: diaryModel[indexPath.row].date)
    let formattedDate = DateFormatter.diaryFormatter.string(from: date)
    ```

    지역에 맞게 날짜의 형식을 변경해 주는 diaryFormatter를 사용하여 JSON 데이터를 디코딩 한 값인 date(Double 타입)을 매개변수로 전달하였습니다.

---

</br>





<a id="5."></a>

## 5.🔗 참고 링크

🍎 [Swift API Design Guidelines](https://www.swift.org/documentation/api-design-guidelines/) <br>
🍏 [Apple Developer - UINavigationController](https://developer.apple.com/documentation/uikit/uinavigationcontroller)<br>
🍏 [Apple Developer - UITextView](https://developer.apple.com/documentation/uikit/uitextview)<br>
🍏 [Apple Developer - UIKeyboardLayoutGuide](https://developer.apple.com/documentation/uikit/uikeyboardlayoutguide/)<br>
🍏 [Apple Developer - Date](https://developer.apple.com/documentation/foundation/date)<br>
🍏 [Apple Developer - DateFormatter](https://developer.apple.com/documentation/foundation/dateformatter)<br>
🍏 [Apple Developer - Adding support for languages and regions](https://developer.apple.com/documentation/xcode/adding-support-for-languages-and-regions)<br>
🍏 [Apple Developer - Locale](https://developer.apple.com/documentation/foundation/locale)<br>
<img src="https://hackmd.io/_uploads/Sy8AUS4Lh.png" width = 20 /> [BLOG : 김종권의 iOS 앱 개발 알아가기 - SwiftLint 적용 방법](https://ios-development.tistory.com/1199)<br>
<img src="https://hackmd.io/_uploads/Sy8AUS4Lh.png" width = 20 /> [BLOG : Dr.kim의 나를 위한 블로그 - 화면에 딱 맞는 UITextView 만들기](https://hereismyblog.tistory.com/34)<br>
<img src="https://hackmd.io/_uploads/Sy8AUS4Lh.png" width = 20 /> [BLOG : Hacking with Swift - Fixing the keyboard: NotificationCenter
](https://www.hackingwithswift.com/read/19/7/fixing-the-keyboard-notificationcenter)<br>

---

</br>
