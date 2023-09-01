# 일기장 📔

## 📖 목차

1. [📢 소개](#1.)
2. [👤 팀원](#2.)
3. [⏱️ 타임라인](#3.)
4. [📊 UML & 파일트리](#4.)
5. [📱 실행 화면](#5.)
6. [🧨 트러블 슈팅](#6.)
7. [🔗 참고 링크](#7.)

<br>

<a id="1."></a>

## 1. 📢 소개
프로젝트 소개
일기를 작성하고 간직하세요!
작성하신 일기는 목록으로 볼 수 있습니다!

> **핵심 개념 및 경험**
> 
> - **DateFormatter**
>   - `locale` 프로퍼티를 이용한 지역화
> - **UITableViewDiffableDataSource**
>   - `DiffableDataSource`를 이용한 애니메이션화된 데이터 바인딩
> - **UITextView**
>   - `UITextView`를 이용한 텍스트 편집과 보기
> - **keyboardWillShowNotification**
>   - `keyboardWillShow` 노티를 이용한 키보드가 나타났을 때 동작 설정

<br>

<a id="2."></a>

## 2. 👤 팀원

| [Erick](https://github.com/h-suo) |
| :--------: | 
| <Img src = "https://user-images.githubusercontent.com/109963294/235300758-fe15d3c5-e312-41dd-a9dd-d61e0ab354cf.png" width="350"/>|

<br>

<a id="3."></a>
## 3. ⏱️ 타임라인

> 프로젝트 기간 :  2023.08.28 ~ 2023.09.15

|날짜|내용|
|:---:|---|
| **2023.08.28** |▫️ `sample` 데이터를 디코딩할 DTO 생성 <br> ▫️ 일기 목록을 보여주는 `DiaryListViewController` UI 세팅 <br>|
| **2023.08.29** |▫️ 일기를 반환 및 저장하는 `DiaryStorageProtocol` 생성 <br> ▫️ 날짜를 포멧하는 `DateFormatManager` 구현 <br> ▫️ `TableViewCell` 생성 및 데이터 바인딩 <br>|
| **2023.08.30** |▫️ 일기를 보여주는 `DiaryViewController` 생성 <br> ▫️ 키보드가 나타났을 때`TextView`도 따라 올라가는 로직 구현 <br>|
| **2023.08.31** |▫️ 데이터 바인딩에 실패했을 때 `Alert`이 뜨도록 구현 <br> ▫️ README 작성 <br>|

<br>

<a id="4."></a>
## 4. 📊 UML & 파일트리

### UML

- **추후 추가 예정**

<br>

### 파일트리
```
Diary
├── Application
│   ├── AppDelegate.swift
│   └── SceneDelegate.swift
├── Model
│   ├── DTO
│   │   └── Diary.swift
│   ├── DateFormatManager.swift
│   ├── DiaryEntry.swift
│   ├── LocaleDateFormatter
│   │   ├── LocaleDateFormatterProtocol.swift
│   │   └── UserDateFormatter.swift
│   └── Storage
│       ├── AssetDiaryStorage.swift
│       └── DiaryStorageProtocol.swift
├── Controller
│   ├── DiaryListViewController.swift
│   └── DiaryViewController.swift
├── View
│   └── DiaryTableViewCell.swift
├── Error
│   └── StorageError.swift
├── Util
│   └── Extension
│       ├── UIAlertController+.swift
│       └── UITextView+.swift
└── Resource
    ├── Assets.xcassets
    ├── Base.lproj
    │   └── LaunchScreen.storyboard
    └── Info.plist
```

<br>

<a id="5."></a>
## 5. 📱 실행 화면
| 목록화면에서 일기 화면으로 넘어가기 | 키보드가 올라왔을 때 |
| :--------------: | :-------: |
| <Img src = "https://github.com/h-suo/ios-diary/assets/109963294/42b8c4fc-adf5-4896-94a6-7b4eb6cf715f" width="300"/> | <Img src = "https://github.com/h-suo/ios-diary/assets/109963294/f4b7daf6-6d54-48b2-a752-c7e8754ba724" width="300"/>  |

<br>

<a id="6."></a>
## 6. 🧨 트러블 슈팅

### 1️⃣ 프로토콜의 활용

#### 🔥 문제점
일기 목록을 보여주는 `DiaryListViewController`가 일기를 가져오기 위한 객체를 가지고 있어야 했습니다.
초기에는 실제 객체를 가지고 있도록 했지만 추후 일기를 가져오는 객체가 변경될 때 `Controller`의 코드가 모두 수정되어야 한다는 문제가 있었습니다.

#### 🧯 해결방법
프로토콜을 활용하면 이를 해결할 수 있을 거라 생각하여 일기를 반환하고 저장하는 `DiaryStorageProtocol`을 만들어 `DiaryListViewController`가 해당 타입을 가지고 있도록 하여 추후 일기를 전달하는 객체가 변경되더라도 `Controller`의 코드가 수정되지 않도록 했습니다.

```swift
protocol DiaryStorageProtocol {
    func diaryEntrys() throws -> [DiaryEntry]
    func storeDiary(_ diary: DiaryEntry)
}
```

<br>

### 2️⃣ Date 지역화

#### 🔥 문제점
날짜를 표시할때 지역화를 해주지 않는다면 사용자가 언어와 지역을 바꾸더라도 해당 설정에 맞게 텍스트가 변하지 않는 문제가 있었습니다.

#### 🧯 해결방법
`DateFormatter`의 `locale` 프로퍼티와 `timeZone` 프로퍼티를 `current`로 설정하여 언어와 지역이 바뀌더라도 날짜 포멧이 자동으로 바뀔 수 있도록 했습니다.

```swift
let userLocale = Locale.current
let userTimeZone = TimeZone.current

let dateFormatter = DateFormatter()
dateFormatter.locale = Locale(identifier: userLocale.identifier)
dateFormatter.setLocalizedDateFormatFromTemplate("dd MMM yyyy")
dateFormatter.timeZone = TimeZone(identifier: userTimeZone.identifier)
```

<br>

### 3️⃣ keyboardWillShow

#### 🔥 문제점
키보드가 올라왔을 때 `TextView`가 가려지는 문제가 있었습니다.

<Img src = "https://github.com/h-suo/ios-diary/assets/109963294/33be182b-dfff-45c2-8607-a9167e100c87" width="300"/>

> 커서가 키보드 아래 있는 상태 아래 있는 상태

#### 🧯 해결방법
`keyboardWillShowNotification`을 이용해서 키보드가 보일 때 키보드의 높이 만큼 `TextView`의 `Inset` `bottom`을 띄어 `TextView`가 가려지지 않도록 설정했습니다.

```swift
func addObserveKeyboardNotification() {
    NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_:)), name: UIResponder.keyboardWillShowNotification, object: nil)
}

@objc private func keyboardWillShow(_ notification: Notification) {
    if let keyboardFrame = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect {
        let keyboardHeight = keyboardFrame.height

        self.contentInset = UIEdgeInsets(top: .zero, left: .zero, bottom: keyboardHeight, right: .zero)
    }
}
```
- `keyboardWillShowNotification`를 관찰하여 신호가 발생했을 때 `keyboardWillShow(_:)`를 실행
- `keyboardFrameEndUserInfoKey`로 노티의 `userInfo`에서 `frame`을 가져와 그 높이로 `Inset`설정

<br>

<a id="7."></a>
## 7. 🔗 참고 링크
- [🍎Apple: locale](https://developer.apple.com/documentation/foundation/dateformatter/1411973-locale)
- [🍎Apple: setLocalizedDateFormatFromTemplate](https://developer.apple.com/documentation/foundation/dateformatter/1417087-setlocalizeddateformatfromtempla)
- [🍎Apple: timezone](https://developer.apple.com/documentation/foundation/dateformatter/1411406-timezone)
- [🍎Apple: keyboardWillShowNotification](https://developer.apple.com/documentation/uikit/uiresponder/1621576-keyboardwillshownotification)
- [🍎Apple: keyboardFrameEndUserInfoKey](https://developer.apple.com/documentation/uikit/uiresponder/1621578-keyboardframeenduserinfokey)
