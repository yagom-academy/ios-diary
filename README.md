# 📒 일기장 프로젝트

## 📖 목차
1. [소개](#-소개)
2. [Tree](#-tree)
3. [타임라인](#-타임라인)
4. [실행 화면](#-실행-화면)
5. [고민한 점](#-고민한-점)
6. [트러블 슈팅](#-트러블-슈팅)
7. [참고 링크](#-참고-링크)

## 🌱 소개

`Mangdi`와 `junho`가 만든 일기장 앱입니다.
- **KeyWords**
  - `UICollectionViewDiffableDataSource`, `NSDiffableDataSourceSnapshot`
  - `UIContentView`, `UIContentConfiguration`, `Notification`
  - `keyboardLayoutGuide`, `localizing`

## 💻 개발환경 및 라이브러리
[![swift](https://img.shields.io/badge/swift-5.6-orange)]()
[![xcode](https://img.shields.io/badge/Xcode-13.4.1-blue)]()

## 🧑🏻‍💻 팀원
|<img src="https://avatars.githubusercontent.com/u/49121469" width=160>|<img src="https://camo.githubusercontent.com/a482a55a5f5456520d73f6c2debdd13375430060d5d1613ca0c733853dedacc0/68747470733a2f2f692e696d6775722e636f6d2f436558554f49642e706e67" width=160>|
|:--:|:--:|
|[Mangdi](https://github.com/MangDi-L)|[junho](https://github.com/junho15)|

## 🌲 Tree

```
.
├── Diary
│   ├── Base.lproj
│   ├── Controllers
│   │   ├── DiaryListViewController.swift
│   │   └── DiaryRegistrationViewController.swift
│   ├── Extensions
│   │   ├── DateFormatter.swift
│   │   └── Locale.swift
│   ├── Models
│   │   └── Diary.swift
│   ├── SupportFiles
│   │   ├── AppDelegate.swift
│   │   ├── Assets.xcassets
│   │   │   ├── AccentColor.colorset
│   │   │   │   └── Contents.json
│   │   │   ├── AppIcon.appiconset
│   │   │   │   └── Contents.json
│   │   │   ├── Contents.json
│   │   │   └── sample.dataset
│   │   │       ├── Contents.json
│   │   │       └── sample.json
│   │   ├── Diary.xcdatamodeld
│   │   │   └── Diary.xcdatamodel
│   │   │       └── contents
│   │   ├── Info.plist
│   │   ├── SceneDelegate.swift
│   │   ├── en.lproj
│   │   │   └── Localizable.strings
│   │   └── ko.lproj
│   │       └── Localizable.strings
│   └── Views
│       └── DiaryListContentView.swift

```
 
## ⏰ 타임라인

<details>
<summary>Step 1 타임라인</summary>
    
- **22/12/20**
    - SwiftLint 라이브러리 적용
    - MVC 파일 분리 및 Asset에 들어있는 json파일에 맞는 모델타입 구현

- **22/12/22**
    - 일기장 리스트 화면 구현 
        - 스토리보드 제거
        - CollectionView Layout, DataSource, Snapshot 구현
        - Custom ContnetView, ContentConfiguration 구현
    - 일기장 등록 화면구현
        - 키보드가 화면을 가리지 않도록 구현
        - NSLocalizedString 사용하여 구현
    
- **22/12/23**
    - 프로젝트 폴더 정리(Extensions, Models, Views, Controllers, SupportFiles)

</details>


## 📱 실행 화면

<details>
    <summary>Step 1 실행화면</summary>

|화면회전|지역화|
|:--:|:--:|
|![Simulator Screen Recording - iPhone 11 - 2022-12-23 at 14 39 10](https://user-images.githubusercontent.com/49121469/209278369-3e69e3c0-3700-49d8-8fde-8e36b2f0ddd8.gif)|![Simulator Screen Recording - iPhone 11 - 2022-12-23 at 14 52 03](https://user-images.githubusercontent.com/49121469/209279608-581b9718-6c32-4a87-a0a6-f654bbc4eb3c.gif)|
    
</details>

## 👀 고민한 점

### Step 1

- Cell 에 직접 접근하여 Lable 등에 값을 설정하는 기존 방식 대신 [WWDC 2020](https://developer.apple.com/videos/play/wwdc2020/10027/) 에서 소개한 `Configuration` 을 사용하는 방식으로 구현해보았습니다.   
`UIContentView` 프로토콜을 채택하는 `DiaryListContentView` 와 `UIContentConfiguration` 프로토콜을 채택하는 `DiaryListConfiguration` 을 구현하여 사용했습니다.   
기존 방식처럼 직접 Cell에 접근하지 않고 `Configuration` 을 통해서 Cell을 설정해줄 수 있었습니다.   
테이블 뷰와 컬렉션 뷰 셀 모두에서 사용할 수 있고, 가볍고 생성 비용이 적어 성능에 이점이 있다고 합니다.


```swift
let cellRegistration = UICollectionView.CellRegistration<UICollectionViewListCell, Diary.ID> { [weak self] cell, _, itemIdentifier in

    var contentConfiguration = DiaryListConfiguration()
    guard let diary = self?.diary(diaryID: itemIdentifier) else {
        cell.contentConfiguration = contentConfiguration
        return
    }

    contentConfiguration.title = diary.title
    contentConfiguration.body = diary.body
    contentConfiguration.createdAt = diary.createdAt
    cell.contentConfiguration = contentConfiguration
    cell.accessories = [
        UICellAccessory.disclosureIndicator()
    ]
}
    
```
---

- 컬렉션뷰의 셀마다 경계선이 표시되는 줄이 나타나게끔 구현하고 싶었습니다.   
`NSCollectionLayoutSection` 으로 `UICollectionViewCompositionalLayout` 을 만드는 방법 대신 `UICollectionLayoutListConfiguration` 의 `showsSeparators` 프로퍼티를 사용하여 구현할 수 있었습니다.   
[Apple Developer Documentation - Implementing Modern Collection Views](https://developer.apple.com/documentation/uikit/views_and_controls/collection_views/implementing_modern_collection_views) 

```swift
// 기존 방식
let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                      heightDimension: .fractionalHeight(1.0))
let item = NSCollectionLayoutItem(layoutSize: itemSize)
let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                       heightDimension: .estimated(75))
let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize,
                                               subitem: item,
                                               count: 1)
let section = NSCollectionLayoutSection(group: group)
let viewLayout = UICollectionViewCompositionalLayout(section: section)
```
```swift
// 새로운 방식
var config = UICollectionLayoutListConfiguration(appearance: .plain)
config.showsSeparators = true
let viewLayout = UICollectionViewCompositionalLayout.list(using: config)
```

## ❓ 트러블 슈팅

### Step 1

<details>
    <summary> 현재 기기의 Locale 을 확인해서 지역화된 날짜 구현 </summary>

- 시뮬레이터 설정에서 언어를 바꿔가며 테스트하던 중 `Locale.current` 가 제대로 바뀌지 않는 문제가 있었습니다.
- `EditSchema - Options` 에서 `App Language` 를 `Korean` 으로 `App Region` 을 `South Korea` 로 수정한 뒤 `Locale.current` 를 확인해도 `en_KR` 였습니다.
- 사용자가 선호하는 언어의 정렬된 목록을 알려주는 `Locale` 의 타입프로퍼티 `preferredLanguages` 를 활용해서 날짜의 지역화를 구현할 수 있었습니다.
    
```swift
// 수정전
extension DateFormatter {
    static func convertToCurrentLocalizedText(timeIntervalSince1970: Double) -> String {
        let date = Date(timeIntervalSince1970: timeIntervalSince1970)
        let formatter = DateFormatter()
        formatter.dateStyle = .long
        formatter.timeStyle = .none
        formatter.locale = Locale.current // Locale.current 사용
        return formatter.string(from: date)
    }
}
```

```swift
// 수정후
extension Locale {
    static var currentLocale: Locale {
        if let preferredLanguage = Locale.preferredLanguages.first {
            return Locale(identifier: preferredLanguage)
        } else {
            return Locale.current
        }
    }
}

extension DateFormatter {
    static func convertToCurrentLocalizedText(timeIntervalSince1970: Double) -> String {
        let date = Date(timeIntervalSince1970: timeIntervalSince1970)
        let formatter = DateFormatter()
        formatter.dateStyle = .long
        formatter.timeStyle = .none
        formatter.locale = Locale.currentLocale // 새로 추가한 Locale.currnetLocale 사용
        return formatter.string(from: date)
    }
}
```
    
</details>

<details>
    <summary> TextField 와 TextView 의 글자 시작 위치 맞추기</summary>

- titleTextField 와 bodyTextView 의 글자 시작 위치가 서로 달랐습니다.
- 예시 화면과 같이, 둘의 글자 시작 위치가 동일하도록 해주기 위해 텍스트 뷰의 `textContainer.lineFragmentPadding` 프로퍼티에 값을 디폴트 값인 `5` 대신 `0` 으로 설정해 주었습니다.
    
```swift
textView.textContainer.lineFragmentPadding = 0 // 5(디폴트) -> 0
```

|수정 전|수정 후|
|:--:|:--:|
|![](https://i.imgur.com/38sLVy7.png)|![](https://i.imgur.com/8AgMvhc.png)|


</details>


## 🔗 참고 링크

[Apple Developer Documentation - Updating Collection Views Using Diffable Data Sources](https://developer.apple.com/documentation/uikit/views_and_controls/collection_views/updating_collection_views_using_diffable_data_sources)  
[Apple Developer Documentation - Implementing Modern Collection Views](https://developer.apple.com/documentation/uikit/views_and_controls/collection_views/implementing_modern_collection_views)  

---

[🔝 맨 위로 이동하기](#-일기장-프로젝트)
