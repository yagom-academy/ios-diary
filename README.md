# 일기장 프로젝트 📓
> CoreData를 활용해 일기장을 관리하는 앱
> 
> 프로젝트 기간: 2023.04.24 - 2023.05.13

<br/>

### 핵심 경험
- ✅ Date Formatter의 지역 및 길이별 표현의 활용
- ✅ Text View의 활용
- ✅ UIResponder.keyboardWillShowNotification의 활용
- ✅ Localization의 활용

---
## 목차 📋
1. [팀원 소개](#1-팀원-소개)
2. [타임 라인](#2-타임라인)
3. [프로젝트 구조](#3-프로젝트-구조)
4. [실행화면](#4-실행화면)
5. [트러블 슈팅](#5-트러블-슈팅)
6. [참고자료](#6-참고자료)

---
## 1. 팀원 소개
|Brody|Andrew|
|:--:|:--:|
|<img src="https://avatars.githubusercontent.com/u/70146658?v=4" width="200">|<img src="https://github.com/hyemory/ios-exposition-universelle/blob/step2/images/Andrew.png?raw=true" width="200">|
| [<img src="https://i.imgur.com/IOAJpzu.png" width="22"/> Github](https://github.com/seunghyunCheon) | [<img src="https://i.imgur.com/IOAJpzu.png" width="22"/> Github](https://github.com/Andrew-0411) |


<br/>
<br/>

## 2. 타임라인

<details><summary><big>타임라인</big></summary>

|날짜|진행 내용|
|---|---|
|2023-04-24(월)|리스트 화면 구현|
|2023-04-25(화)|일기장 영역 화면 UI구현|
|2023-04-26(수)|코드 컨벤션 수정 및 코드 정리|
|2023-04-27(목)|CoreData 학습|
|2023-04-28(금)|README 작성, CoreData 학습|

</details>


<br/>
<br/>

## 3. 프로젝트 구조

### 1️⃣ 폴더 구조
```
├── Diary
│   ├── Controller
│   │   ├── HomeDiaryController.swift
│   │   └── ProcessViewController.swift
│   ├── Extension
│   │   ├── ArrayExtension.swift
│   │   └── DateFormatterExtension.swift
│   ├── Model
│   │   ├── DiaryItem.swift
│   │   └── LayoutType.swift
│   ├── Protocol
│   │   └── ReusableIdentifier.swift
│   └── View
│       └── DiaryCell.swift
└── README.md
```

<br/>
<br/>

## 4. 실행화면
|일기장 메인화면 및 생성화면|일기장 수정화면|
|:--:|:--:|
|<img src="https://i.imgur.com/LhrwsnL.gif" width="300">|<img src="https://i.imgur.com/G1ydGGp.gif" width="300">|


<br/>
<br/>

## 5. 트러블 슈팅

### 1️⃣ 범용성을 고려한 DateFormatter 편의 생성자 정의

#### ❓ 문제점
- 기존의 `DateFormatter`는 `static`으로 선언되어있기 때문에 범용성이 없고 `DateFormatter`가 필요없는 부분에서도 메모리에 상주하고 있는 문제가 있었습니다.

#### 📖 해결한 점
- 편의 이니셜라이저를 사용해 파라미터에 따라 다른 `DateFormatter`를 만들었습니다. 

```swift
extension DateFormatter {
    convenience init(languageIdentifier: String, style: DateFormatter.Style = .long) {
        self.init()
        locale = Locale(identifier: languageIdentifier)
        dateStyle = style
    }
}
```

위와같이 수정하니 다음과 같은 장점이 생겼습니다.
- 범용성을 높였습니다.
- 의존성 주입을 통해 테스터빌리티를 높였습니다. 만약 `static`함수만 존재한다면 다양한 상태의 테스트를 진행할 수 없게 됩니다.
- 결합도를 줄였습니다. A, B, C서비스가 하나의 전역함수를 사용하고 있을 때 A서비스의 요구사항이 변경되어 전역함수를 변경시킨다면 B와 C도 영향을 받게 됩니다. 하지만 전역함수를 사용하지않고 의존성 주입을 해서 각각의 서비스에 맞게 인스턴스를 생성시킨다면 유지보수가 훨씬 용이해집니다.

<br/>

### 2️⃣ idetifier Cell
#### ❓ 문제점
```swift
guard let cell = tableView.dequeueReusableCell(
            withIdentifier: "cell",
            for: indexPath)
```
- String 타입의 문자열로 사용되기 때문에 개발자가 실수를 하여도 IDE가 탐지를 할 수 없다는 문제점이 있었습니다.
- Identifier의 문자열을 상수로 만들어서 withIdentifier에 만든 상수값을 넣어주어도 되었지만 프로토콜을 사용하면 상수를 만들지 않아도 되어서 프로토콜을 사용하였습니다.

#### 📖 해결한 점
```swift
public protocol ReusableIdentifier: AnyObject {
    static var identifier: String { get }
}

public extension ReusableIdentifier where Self: UIView {
    static var identifier: String { return String(describing: self) }
}

extension UITableViewCell: ReusableIdentifier { }

guard let cell = tableView.dequeueReusableCell(
            withIdentifier: DiaryCell.identifier,
            for: indexPath)
```
- ReusableIdentfier프로토콜을 채택함으로써 identifier에 들어갈 문자열을 없애고 `DiaryCell.identifier`를 넣어주었습니다.

<br/>
<br/>

### 3️⃣ Localization을 통한 지역화 설정
#### ❓ 문제점
- 사용자의 언어설정에 따라 날짜의 포멧형식을 다르게 주는 방법을 고민했습니다. 처음에는 `DateFormatter`의 `locale`설정에 `Locale.current`를 사용했으나 지역화가 되지않았습니다.

#### 📖 해결한 점
- `Locale.preferredLanguages`를 사용함으로써 문제를 해결했습니다. 해당 프로퍼티는 사용자가 선호하는 언어들을 가져오는 프로퍼티로 배열을 반환하기 때문에 `first`를 통해 첫 번째로 선호하는 언어를 가져와 적용했습니다.
```swift
private let localizedDateFormatter = DateFormatter(
    languageIdentifier: Locale.preferredLanguages.first ?? Locale.current.identifier
)
```

<br/>
<br/>

## 6. 참고자료
- [Apple Developer: Layout](https://developer.apple.com/design/human-interface-guidelines/foundations/layout/)
- [WWDC 2016: Making apps adaptive part 1](https://www.youtube.com/watch?v=hLkqt2g-450&ab_channel=anhpham)
- [WWDC 2016: Making apps adaptive part 2](https://www.youtube.com/watch?v=s3utpBiRbB0&ab_channel=anhpham)
- [WWDC 2018: UIKit: Apps for Every Size and Shape](https://developer.apple.com/videos/play/wwdc2018/235/)
- [WWDC 2019: Making Apps with Core Data](https://developer.apple.com/videos/play/wwdc2019/230/)
- [Apple Developer: DateFormatter](https://developer.apple.com/documentation/foundation/dateformatter)
- [Apple Developer: UITextView](https://developer.apple.com/documentation/uikit/uitextview)
- [Apple Developer: Core Data](https://developer.apple.com/documentation/coredata)
- [Apple Developoer: UITextViewDelegate](https://developer.apple.com/documentation/uikit/uitextviewdelegate)
- [Apple Developoer: UISwipeActionsConfiguration](https://developer.apple.com/documentation/uikit/uiswipeactionsconfiguration)
- [Apple Docs - adjustedcontentinset](https://developer.apple.com/documentation/uikit/uiscrollview/2902259-adjustedcontentinset)
- [Apple Docs - contentInsetAdjustmentBehavior](https://developer.apple.com/documentation/uikit/uiscrollview/2902261-contentinsetadjustmentbehavior)

