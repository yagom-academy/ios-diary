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
    
    - 주요 개념: UITableViewDiffableDataSource, TextView, Keyboard Layout, DateFormatter, AppManager, CoreData, ActivityViewController, AlertController

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
| **2023.09.01** |▫️ ReuseIdentifiable 프로토콜 구현<br> ▫️ CompressionPriority, HuggingPriority를 setUpConstriants로 위치 변경<br> |
| **2023.09.06** |▫️ CoreData과 DiaryCoreData 생성 및 CRUD 구현 <br> ▫️ ActivityViewControllerShowable, AlertControllerShowable 타입 구현 <br>  ▫️ ViewController에 Showable Type 적용|
| **2023.09.07** |▫️ AppManager에 DiaryDataManager 주입 <br> ▫️ DiarySample 삭제 및 DiaryEntity 타입 적용 <br>|
| **2023.09.12** |▫️ viewWillAppear 시 dataFetch <br> ▫️ DiaryDetailViewController Update, Delete 구현 <br> ▫️ TextView EndEditing 시, background 시 Save로직 추가 <br> ▫️ NotificationCenter Observer 등록 <br> ▫️ diffableDataSource delete시 bottom Constraint 충돌해결 <br> ▫️ 사용하지 않는 model 삭제 <br> |
| **2023.09.14** |▫️ title만 존재할경우 body도 title처럼 나오는 이슈 수정 <br> ▫️ insertData로직 추가 및 data Create반환 값 삭제, DiaryCoreDataManager 삭제 <br> ▫️ insertData 에러 수정 <br> ▫️ CoreData 수정 및 DiaryContentsDTO 생성 <br> ▫️ DiaryDetailViewController UseCase 생성 및 적용 <br> ▫️ CoreDataManagerType 생성 및 적용 <br> ▫️ Save, Delete 시 에러 수정|

<br>

<a id="4."></a>
## 4. 📊 다이어그램
 <Img src = "https://hackmd.io/_uploads/BkBd5dbyT.png" width="700"/> 

<br>

<a id="5."></a>
## 5. 📲 실행 화면

| 다이어리 화면 구동 | 다이어리 편집 시 키보드 동작 | 다이어리 생성 |
| :--------------: | :-------: | :-------: | 
| <Img src = "https://cdn.discordapp.com/attachments/1147011195086307399/1147021571987345499/Sep-01-2023_13-11-25.gif" width="250"/> | <Img src = "https://cdn.discordapp.com/attachments/1147011195086307399/1147021571521789972/Sep-01-2023_13-13-52.gif" width="250"/>  | <Img src = "https://media.discordapp.net/attachments/1147011195086307399/1152122056062795856/Sep-15-2023_14-44-27.gif?width=640&height=1330" width="250"/> |
| **선택 시 편집화면 이동** | **다이어리 화면 share** | **다이어리 화면 delete** |
| <Img src = "https://media.discordapp.net/attachments/1147011195086307399/1152122054389288970/cellselect.gif?width=640&height=1330" width="250"/> | <Img src = "https://media.discordapp.net/attachments/1147011195086307399/1152122055257489428/Sep-15-2023_14-45-44.gif?width=640&height=1330" width="250"/> | <Img src = "https://media.discordapp.net/attachments/1147011195086307399/1152122055660150824/Sep-15-2023_14-45-21.gif?width=640&height=1330" width="250"/>  |
 | **다이어리 편집 시 Backgound 저장** | **다이어리 편집 화면 share** | **다이어리 편집 화면 delete**|
 | <Img src = "https://media.discordapp.net/attachments/1147011195086307399/1152122054020169739/background.gif?width=640&height=1330" width="250"/>| <Img src = "https://media.discordapp.net/attachments/1147011195086307399/1152122054821290045/Sep-15-2023_14-46-31.gif?width=640&height=1330" width="250"/> | <Img src = "https://media.discordapp.net/attachments/1147011195086307399/1152122053554622494/secondDleeler.gif?width=640&height=1330" width="250"/>  |


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
    
### 🔥 ViewController에서의 DiaryCoreDataManager에 대한 의존성
- ViewController(이하 VC)는 VC를 띄우는 데 있어서 필요한 데이터가 아닌 다른 것들을 의존하게 된다면 재사용성이 많이 떨어질 수 밖에 없다고 생각합니다. 따라서 이를 위해 상위 타입인 AppManager를 만들게 되었습니다. 

    하지만 과제를 추가적으로 진행해나가면서 VC에 진입할 때 마다 fetch한 데이터를 갱신하고, Delete기능들 등이 추가되면서 DiaryCoreDataManager를 직접적으로 VC에서 주입했다면 재사용성은 떨어져도 코드의 가독성 및 이후의 유지 보수 관련해서는 더 쉽게 이해할 수 있는 코드가 되지않을까? 라고 생각했습니다. 그렇게 생각한 이유는 DiaryCoreDataManager를 주입받지 않았을 때 발생하는 AppManager와의 많은 소통때문이라고 생각합니다. 따라서 ViewController의 재사용성을 살리면서 불필요하게 많아진 상위 타입으로의 소통을 변경할 수 있는 방법을 생각해봐야했습니다.
    
- UseCase Type을 만들어서 위와 같은 문제점을 해결할 수 있었습니다.
ViewController에서 View를 띄우는 로직 및 이벤트를 받아 처리하는 로직 이외의 모든 로직을 UseCase로 넘겨주어 처리하게 했습니다. 따라서 UseCase가 DiaryCoreDataManager를 주입받아 CRUD를 담당하는 기능들을 처리할 수 있도록 했고 이에 따라 ViewController에서는 상위 타입과 소통을 하는 것이 아닌 ViewController에서 가지고 있는 UseCase와 소통함에 따라 의사소통 방식의 개선으로 인해 가독성이 상승했습니다.
또한, ViewController에서는 View를 띄우거나, 사용자로부터 이벤트를 받아 처리하는 로직외의 모든 부분들을 UseCase에서 담당하게 되면서 ViewController의 재사용성도 챙길 수 있게 되었습니다.

<br>

### 🔥 TableView delete 한 후 Scroll할 때의 Constraint 충돌
- 현재 TableView에서는 DiffableDataSource을 활용하여 Cell을 관리하고 있습니다. Cell을 Swipe 했을 때 존재하는 Delete 기능을 사용하여 Cell을 삭제하고 스크롤시 아래와 같은 오류가 발생했습니다.
```swift
2023-09-12 16:28:45.001423+0900 Diary[23292:2537329] [LayoutConstraints] Unable to simultaneously satisfy constraints.
	Probably at least one of the constraints in the following list is one you don't want. 
	Try this: 
		(1) look at each constraint and try to figure out which you don't expect; 
		(2) find the code that added the unwanted constraint or constraints and fix it. 
(
    "<NSLayoutConstraint:0x600001ee8820 V:|-(5)-[UIStackView:0x154928590]   (active, names: '|':UITableViewCellContentView:0x1549293b0 )>",
    "<NSLayoutConstraint:0x600001ee8870 UIStackView:0x154928590.bottom == UITableViewCellContentView:0x1549293b0.bottom - 5   (active)>",
    "<NSLayoutConstraint:0x600001ee9630 'UIView-Encapsulated-Layout-Height' UITableViewCellContentView:0x1549293b0.height == 0   (active)>"
)

Will attempt to recover by breaking constraint 
<NSLayoutConstraint:0x600001ee8870 UIStackView:0x154928590.bottom == UITableViewCellContentView:0x1549293b0.bottom - 5   (active)>

Make a symbolic breakpoint at UIViewAlertForUnsatisfiableConstraints to catch this in the debugger.
The methods in the UIConstraintBasedLayoutDebugging category on UIView listed in <UIKitCore/UIView.h> may also be helpful.
```
- 오류 내용을 분석한 결과 Cell이 화면에 보이지 않을 때 발생하는 Constraint(UIView-Encapsulated-Layout-Height)와 제가 부여한 Cell이 Constraints가 충돌하여 나타나는 오류로 보였습니다. 
    따라서 해당 오류를 해결하기 위해서 bottomConstraint에 대한 Priority를 999로 낮춰서 constraint가 충돌하는 것을 해결할 수 있었습니다.
    
    파악한 오류의 원인만 봐서는 누구나 경험할 수 있는 오류라고 판단됩니다. 그렇게 생각한 이유는 화면에 보이지 않을 때의 셀의 제약조건을 height == 0으로 준다면 어떤 조건이라도 충돌이 발생할 수 있기 때문입니다.
    
[문제에 대한 질문: StackOverFlow](https://stackoverflow.com/questions/77043899/using-uitableviewdiffabledatasource-in-uitableview-add-or-deletecell-warning)
오류해결 커밋: (https://github.com/yagom-academy/ios-diary/commit/bc89e580507d90d480db6a61672760fc5ee205ae)

<br>

### 🔥 DiaryDetailViewController에서 delete시 save 중복
- `CoreData`의 `content`를 `delete`한 후 이를 `context`에 `save`하는 로직을 구현하였습니다. 이때 하기와 같은 에러가 발생하였습니다.
    > [error] error: Mutating a managed object 0xaef4c17744feb12c <x-coredata://AEDDFE8E-AD18-4A2B-85FE-C6974CD59837/DiaryEntity/p117> (0x6000013d75c0) after it has been removed from its context.
- 오류 원인을 `save()`의 공식 문서에서 알 수 있게 되었습니다.
    > Always verify that the context has uncommitted changes (using the hasChanges property) before invoking the save: method. Otherwise, Core Data may perform unnecessary work.
    > `save`메서드는 호출하기 전 `context`의 변동사항을 체크하는데, 변동사항이 없을 시 `save`를 호출하는 것은 불필요한 작업이 됩니다.
    [AppleDeveloper - save()](https://developer.apple.com/documentation/coredata/nsmanagedobjectcontext/1506866-save)
    
    이를 기반으로 디버깅을 한 결과 `delete` 시 `save`가 연달아 `두 번` 호출되는 것을 확인할 수 있었습니다. 두번째 화면인 `DiaryDetailViewController`에서 `delete`와 `save`를 한 후 첫번째 화면으로 바로 넘기는데, 첫번째 화면이 띄워지는 과정에서 데이터를 `fetch`하고 `save`를 호출하고 있었습니다.
    
    이에 `save` 호출이 중복되지 않게 코드 수정을 하여 에러 발생을 방지하였습니다.

<br>

### 🔥 Protocol을 활용하여 중복코드 삭제 및 수평적 확장
- `share`와 `delete` 기능 관련 `AlertController`와 `ActivityViewController` 코드가 각 `ViewController`에서 중복되었습니다. 하여 중복코드를 삭제하면서 `UIViewController`에 `Alert/Activity Controller`의 역할을 확장시킬 수 있도록 하고자 하였습니다.

    각각 `AlertControllerShowable`, `ActivityViewControllerShowable` 프로토콜을 생성하였습니다. `extension`에 `기본 구현`을 함으로 코드의 중복을 삭제시킬 수 있었습니다.

    프로토콜을 사용하면 수평적 기능 확장이 가능하게 된다는 장점이 존재합니다. 하지만 무분별하게 확장사용하는 것을 제한할 수 있도록 `where Self`를 사용하여 `UIViewController`에서만 기능 확장 사용이 가능하도록 하였습니다.

<br>

### 🔥 DiaryDetailViewController에 entity 주입
- `diary text`를 작성하는 도중 앱이 `background`로 가는 경우 `저장`이 될 수 있도록 구현하고자 하였습니다. 이때 `text`가 있는 경우 새롭게 `create`를 하거나 `update`를 하여 변경된 내용을 저장하고자 하였습니다.

    저희는 `entity`의 유무로 `create`와 `update`의 기준을 나누었기 때문에, 앱 사용 도중 최초 저장을 하게 되면 `create` 로직을 타고 새로운 `content`를 생성하였습니다. 하지만 `background`에 있던 앱을 다시 `foreground`로 가져와 수정을 완료하여 저장하고자 할 때 `entity`가 없기 때문에 다시 `create`로직을 타는 문제가 생겼습니다.

    이를 해결하고자 기존의 `DiaryCoreDataManager`의 `createDiaryData` 메서드가 `entity`를 반환하도록 수정하여 `create` 시 `DiaryDetailViewController`에 주입해주었습니다. 이로서 `text`가 있는 경우 중간에 앱이 `background`로 가게되면 바로 `entity`를 `create`하여 새로운 `entity`를 `DiaryDetailViewController`에 주입하였습니다. 이렇게 하여 추가 수정을 완료하여 저장하게 되면 `entity`가 있다고 판단하여 `update`로직을 탈 수 있도록 하였습니다.

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
- [🍎 Apple Developer - Core Data](https://developer.apple.com/documentation/coredata)
- [🍎 Apple Developer - Making Apps with Core Data](https://developer.apple.com/videos/play/wwdc2019/230
- [🍎 Apple Developer - UITextViewDelegate](https://developer.apple.com/documentation/uikit/uitextviewdelegate)
- [🍎 Apple Developer - UISwipeActionsConfiguration](https://developer.apple.com/documentation/uikit/uiswipeactionsconfiguration)
- [📒 Blog - NSDate, DateFormatter](https://velog.io/@dev_jane/NSDate-DateFormatter-사용하여-사용자의-기기에-맞는-날짜-설정하기)
- [📒 Blog - Core Data](https://zeddios.tistory.com/987)
