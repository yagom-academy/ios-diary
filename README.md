# 📓 Dairy

<Img src = "https://cdn.discordapp.com/attachments/1101039125936742460/1147010972960161834/final.png" width="700"/>


> 프로젝트 기간 :  2023.08.28 ~


## 📖 목차

1. [소개](#1.)
2. [팀원](#2.)
3. [타임라인](#3.)
4. [다이어그램](#4.)
5. [실행 화면](#5.)
6. [트러블 슈팅](#6.)
7. [팀 회고](#7.)
8. [참고 링크](#8.)

<br>

<a id="1."></a>

## 1. 📢 소개

나만의 일기를 작성해보세요✏️
    
    - 주요 개념: UITableViewDiffableDataSource, TextView, Keyboard Layout, DateFormatter, AppManager

<br>

<a id="2."></a>

## 2. 👤 팀원

| [Serena 🐷](https://github.com/serena0720) | [Zion 🐨](https://github.com/LeeZion94) |
| :--------: | :--------: | 
| <Img src = "https://i.imgur.com/q0XdY1F.jpg" width="300"/>| <Img src = "https://avatars.githubusercontent.com/u/24710439?v=4" width="300"/>|

<br>

<a id="3."></a>
## 3. ⏱️ 타임라인

|날짜|내용|
|:---:|---|
| **2023.08.29** |▫️ Prototype 구현<br> |
| **2023.08.30** |▫️ Lint 적용 <br> ▫️ MainVC에 TableView 및 TableViewCell 코드 구현 <br> ▫️ AddDiaryVC에 TextView 코드 구현 <br>▫️ DiarySample JSON 모델 추가 <br> ▫️ TableViewDiffableDataSource 적용 <br> ▫️ DateFormatter에 Localization 적용 <br> ▫️ AppManager 구현 <br> ▫️ 순환참조 제거 <br>|


<br>

<a id="4."></a>
## 4. 📊 다이어그램

> 추후 작성 예정

<br>

<a id="5."></a>
## 5. 📲 실행 화면

| 다이어리 화면 구동 | 다이어리 편집 시 키보드 동작 |
| :--------------: | :-------: | 
| <Img src = "https://cdn.discordapp.com/attachments/1147011195086307399/1147021571987345499/Sep-01-2023_13-11-25.gif" width="400"/> | <Img src = "https://cdn.discordapp.com/attachments/1147011195086307399/1147021571521789972/Sep-01-2023_13-13-52.gif" width="400"/>  |



<br>

<a id="6."></a>
## 6. 🛎️ 트러블 슈팅
## 고민한 부분
### 🔥 AppManager Type 구현
- 뷰컨트롤러끼리의 종속성 및 불필요한 의존관계, 뷰컨트롤러의 재사용성을 위해 화면전환 및 의존성을 주입해줄 수 있는 `AppManager Type`을 구현했습니다.
    
    이와 비슷하게 화면 전환을 담당해줄 수 있는 `Coordinator Pattern`을 생각해봤으나 `Coordinator Pattern`에서 사용하는 `Coordinator` 끼리의 상호작용이 필요할 만큼 `App`의 규모나 필요한 화면이 많지 않았기 때문에 필요한 역할만 담당해줄 수 있는 `AppManager Type`을 만들어 관리하게되었습니다.
    
<br>

### 🔥 Keyboard Layout
- 일기장 생성 화면의 `TextView`를 편집할 때, 텍스트가 키보드에 의해 가려지지 않도록 해야했습니다. 이를 해결하기 위해 여러 방법을 고민하였습니다.
    - `TextView`의 `KeyBoard Notification`을 활용하여 `TextView`의 `Bottom Constraint` 변경하는 방법
    - `TextView`의 `KeyBoard Notification`을 활용하여 `TextView`의 `contentInset`을 변경하는 방법
    - `TextView`의 `Bottom Constraint`를 `KeyBoard Layout`의 `TopAnchor`에 맞추는 방법
        > [참고 링크 - iOS keyboard layout guide](https://developer.apple.com/design/human-interface-guidelines/layout#iOS-keyboard-layout-guide)
- KeyBoard Layout을 활용한 방법이 효율적일 것이라 판단하여 이를 사용하였습니다. KeyBoard Notification을 활용하지 않아도 되기 때문에 코드가 보다 간결하게 구현 가능했기 때문입니다.

<br>

### 🔥 Date Formatter Localization
- `Date`를 지역 포멧에 맞게 표현하기 위하여 `Lacale`과 `TimeZone`을 사용하였습니다.
- 사용자가 설정한 `preferredLanguages`를 활용하여 지역 설정을 하여, 해당 언어로 날짜 포맷을 지정할 수 있도록 하였습니다. 또한 `TimeZone`을 사용하여 사용자의 위치에 따른 시간을 업데이트할 수 있도록 하였습니다.
    ```swift
    private let dateFormatter: DateFormatter = {
            let dateFormatter = DateFormatter()
            let localeID = Locale.preferredLanguages.first ?? "kr_KR"
            let deviceLocale = Locale(identifier: localeID).languageCode ?? "KST"

            dateFormatter.locale = Locale(identifier: deviceLocale)
            dateFormatter.timeZone = TimeZone.current
            dateFormatter.dateFormat = "yyyy년 MM월 dd일"
            return dateFormatter
        }()
    ```

<br>

### 🔥 UITableViewDiffableDataSource ItemIdentifier (UUID)
- `UITableViewDiffableDataSource`를 사용하면서 `ItemIdentifier`로 사용하였던 `DiaryContent`가 중복된 `Identifier`가 존재했기 때문에 각각의 `Model`이 `Unique`한 `Identifier`의 특성을 가지게 하기 위해서 모델 각각에서 `UUID`를 가질 수 있도록 했습니다. 

<br>

### 🔥 CompressionResistance, Hugging Priority 사용
- `StackView` 안에 `StackView`를 중첩해서 사용하면서 그 안에 속한 `Label`들의 `Intricsize`를 사용하기 위해서 최대한 고정으로 `Constarints`를 부여하지 않았습니다. 그결과 `previewLabel`의 `contents`의 내용이 상당히 길었기 때문에 같은 `horizontal`로 존재했던 `datelabel`를 `Compression`하게 되었고 그 결과 `dateLabel`의 형상을 화면에서 볼 수 없게 되었습니다.

    이를 해결하기 위해서 `dateLabel`의 `CompressionResistancePriority`를 `previewLabel`에 비해 올렸습니다 따라서 `dateLabel`이 더이상 찌그러지는 형태가 아닐 수 있도록 형상을 잡아주었고 또한 `previewLabel`의 `text`가 충분히 길지 않을 때에는 `horizontal StackView` 내부 컴포넌트들의 크기가 모호해질 수 있으므로 `previewLabel`의 `huggingPriority`를 `datalabel`보다 낮게 주어 `Label` 자체가 늘어날 수 있도록 설정하여 문제를 해결할 수 있었습니다.
 
    <정리 자료>
    [Compression Resistance Priority](https://medium.com/@LeeZion94/compressionresistance-priority-d17c6f407b7f)
    [Hugging Priority](https://medium.com/@LeeZion94/uistackview-alignment-fill-hugging-84af069eb694)

<br>


<a id="7."></a> 
## 7. 💭 팀 회고

<details>
<summary>팀 회고</summary>

> 추후 작성 예정

</details>

<br>

<a id="8."></a>
## 8. 🔗 참고 링크
- [🍎 Apple Developer - UITextView](https://developer.apple.com/documentation/uikit/uitextview)
- [🍎 Apple Developer - UICollectionViewDiffableDataSource](https://developer.apple.com/documentation/uikit/uicollectionviewdiffabledatasource)
- [🍎 Apple Developer - Date](https://developer.apple.com/documentation/foundation/date)
- [🍎 Apple Developer - DateFormatter](https://developer.apple.com/documentation/foundation/dateformatter)
- [📒 Blog - NSDate, DateFormatter](https://velog.io/@dev_jane/NSDate-DateFormatter-사용하여-사용자의-기기에-맞는-날짜-설정하기)
