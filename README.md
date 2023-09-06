# 일기장[STEP1-1]

> 📌 sample.dataset을 활용하여 화면에 제목, 작성일자, 한줄 미리보기가 보여지는 일기장 앱입니다.

## 📚 목차</br>
- [팀원소개](#-팀원-소개)
- [파일트리](#-파일트리)
- [시각화된 프로젝트 구조](#시각화된-프로젝트-구조)
- [타임라인](#-타임라인)
- [실행화면](#-실행화면)
- [트러블 슈팅](#-트러블-슈팅)
- [참고자료](#-참고자료)

## 🧑‍💻 팀원 소개</br>
| <img src="https://github.com/devKobe24/images/blob/main/%E1%84%86%E1%85%AE%E1%86%AB.jpeg?raw=true" width="200" height="200"/> | <img src="https://github.com/devKobe24/BranchTest/blob/main/IMG_5424.JPG?raw=true" width="200" height="200"/> |
| :-: | :-: |
| [**Moon(문)**](https://github.com/hojun-jo) | [**Kobe(코비)**](https://github.com/devKobe24) |

## 🗂️ 파일트리</br>
```
.
├── Diary
│   ├── Model
│   │   ├── DTO
│   │   │   └── Diary.swift
│   │   ├── DiaryDateFormatter.swift
│   │   ├── Error
│   │   │   └── DecodeError.swift
│   │   └── Protocol
│   │       └── IdentifierGenerator.swift
│   └── View
│   │   └── LaunchScreen.storyboard
│   │   └── DiaryTableViewCell.swift
│   ├── Controller
│   │   └── DiaryMainViewController.swift
│   ├── Resource
│   │   └── Assets.xcassets
│   │       ├── AccentColor.colorset
│   │       │   └── Contents.json
│   │       ├── AppIcon.appiconset
│   │       │   └── Contents.json
│   │       ├── Contents.json
│   │       └── sample.dataset
│   │           ├── Contents.json
│   │           └── sample.json
│   ├── Application
│   │   ├── AppDelegate.swift
│   │   └── SceneDelegate.swift
│   ├── Extension
│   │   └── UITableViewCell+.swift
│   └── SwiftLint
└── README.md
```

## 🗺️ 시각화된 프로젝트 구조</br>
<img src = "https://github.com/devKobe24/images/blob/main/Diary(STEP1-1).png?raw=true">

## ⏰ 타임라인</br>
프로젝트 진행 기간 | 23.08.29.(화) ~ 23.09.01.(금)

| 날짜 | 진행 사항 |
| -------- | -------- |
| 23.08.29.(화)     |  SwiftLint 적용.<br/>테이블 뷰 생성, Autolayout 적용.<br/>DiaryTableViewCell 생성 및 구현.<br/>UITableViewCell Extension 구현.<br/>Main.storyboard 삭제.<br/>DiaryTableViewCell UI 수정<br/>네비게이션 아이템 추가<br/>DateFormatter extension 구현|
| 23.08.30.(수)     | Diary DTO 생성<br/>DecodeError 생성 및 구현<br/>샘플 에셋 추가<br/>샘플 데이터 디코딩<br/>NSAttributedString 반환 함수 수정<br/>fetchDate 함수 생성 및 구현.<br/>formatCreatedAt 함수 생성 및 구현.<br/>DiaryDateFormatter 생성 및 구현
| 23.08.31.(목)     | Step 1-1 및 개념 학습<br/>
| 23.09.01(금)     | README 작성.<br/>


## 📺 실행화면</br>
- STEP1-1 일기장 시뮬레이터 실행화면 🎬 </br>
<img src = "https://github.com/devKobe24/images/blob/main/Diary-Step-1-1.gif?raw=true">

## 🔨 트러블 슈팅 
### 1️⃣ **StackView 내부에서 Label의 Height가 잡히지 않는 현상.**</br>
### 🔒 **문제점** 🔒</br>

**🚨 StackView 내부에서 Label의 Height가 잡히지 않는 현상이 있었습니다.</br>height is ambiguous for UILabel 경고가 생겨 트러블 슈팅을 진행하게 되었습니다.**</br>

### 🔑 **해결방법** 🔑</br>
**🙋‍♂️ diaryTitle과 dateAndPreview의 content hugging priority 가 같아 생기는 현상이였습니다.</br>따라서 diaryTitle에 .defaultHigh + 1 값을 주었고, dateAndPreview에는 .defaultHigh값을 주어 각각 다른 content hugging priority값을 주어 해결하였습니다.**

```swift!
import UIKit

class DiaryTableViewCell: UITableViewCell {
    private let diaryTitle: UILabel = {
        let label = UILabel()
        label.font = UIFont.preferredFont(forTextStyle: .title2)
        label.setContentHuggingPriority(.defaultHigh + 1, for: .vertical)
        
        return label
    }()
    
    private let dateAndPreview: UILabel = {
        let label = UILabel()
        label.font = UIFont.preferredFont(forTextStyle: .body)
        label.setContentHuggingPriority(.defaultHigh, for: .vertical)
        
        return label
    }()
}
```

### 2️⃣ **NSAttributedString이 적용되지 않는 현상.** </br>
### 🔒 **문제점** 🔒</br>
**🚨 [__NSCFConstantString renderingMode]: unrecognized selector sent to instance 0x10aa5a2e8 에러가 발생했습니다.
원인은 NSAttributedString.Key.font에 필요한 타입이 UIFont였으나 UIFont.TextStyle을 사용 중이었습니다.**

```swift!
private func convertAttributedString(text: String, font: UIFont.TextStyle) -> NSAttributedString {
    let attributes = [NSAttributedString.Key.font: font as Any] as [NSAttributedString.Key : Any]
    let attributedString = NSAttributedString(string: text, attributes: attributes)

    return attributedString
}
```

### 🔑 **해결방법** 🔑</br>
🙋‍♂️**NSAttributedString.Key.font에 UIFont 타입으로 전달하여 해결했습니다.**</br>

```swift
private func convertAttributedString(text: String, font: UIFont) -> NSAttributedString {
    let attributes = [NSAttributedString.Key.font: font as Any] as [NSAttributedString.Key : Any]
    let attributedString = NSAttributedString(string: text, attributes: attributes)

    return attributedString
}
```

### 3️⃣ NSAttributedString의 가운데 정렬
### 🔒 **문제점** 🔒</br>
**🚨 문자열 자체의 모양이 아래 이미지와 같기 때문에 UILabel의 baselineAdjustment로 가운데 정렬을 맞출 수 없었습니다.**
<img src = "https://github.com/devKobe24/images/blob/main/NSAttributedString%E1%84%86%E1%85%AE%E1%86%AB%E1%84%8C%E1%85%A6%E1%84%8C%E1%85%A5%E1%86%B7.png?raw=true"></br>

### 🔑 **해결방법** 🔑</br>
**🙋‍♂️NSAttributedString.Key.baselineOffset을 이용해 작은 문자 부분의 baseline을 올리는 것으로 해결했습니다.**</br>
<img src = "https://github.com/devKobe24/images/blob/main/NSAttributedString%E1%84%92%E1%85%A2%E1%84%80%E1%85%A7%E1%86%AF%E1%84%8C%E1%85%A5%E1%86%B7.png?raw=true"></br>

```swift
private func attributedDateAndPreview(data: Diary, font: UIFont) -> NSMutableAttributedString {
    let text = "\(formatCreatedAt(data.createdAt)) \(data.body)"
    let attributedString = NSMutableAttributedString(string: text)
    let attributes: [NSAttributedString.Key: Any] = [
        .font: font,
        .baselineOffset: 2
    ]

    attributedString.addAttributes(attributes, range: (text as NSString).range(of: data.body))

    return attributedString
}
```

## 📑 참고자료
- [📃 Adaptivity and Layout](https://developer.apple.com/design/human-interface-guidelines/layout)
- [📃 UIKit: Apps for Every Size and Shape](https://www.wwdcnotes.com/notes/wwdc18/235/)
- [🎥 Making apps adaptive part 1](https://www.youtube.com/watch?v=hLkqt2g-450)
- [🎥 Making apps adaptive part 2](https://www.youtube.com/watch?v=s3utpBiRbB0)
- [📃 DateFormatter](https://developer.apple.com/documentation/foundation/dateformatter)
- [📃 UITextView](https://developer.apple.com/documentation/uikit/uitextview)
