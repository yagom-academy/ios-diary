# 일기장 프로젝트 📓
> CoreData를 활용해 일기장을 관리하는 앱
> 
> 프로젝트 기간: 2023.04.24 - 2023.05.12

<br/>

### 핵심 경험
- ✅ Date Formatter의 지역 및 길이별 표현의 활용
- ✅ UITextView의 활용
- ✅ UIResponder.keyboardWillShowNotification의 활용
- ✅ Localization의 활용
- ✅ 코어데이터 모델 생성
- ✅ 코어데이터 모델 및 DB 마이그레이션
- ✅ 테이블뷰에서 스와이프를 통한 삭제기능 구현
- ✅ TextViewDelegate의 활용
- ✅ NSFetchResultsController의 활용
- ✅ 지역화 적용
- ✅ CoreLocalization의 활용
- ✅ CoreData Migration 적용

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
|<img src="https://avatars.githubusercontent.com/u/70146658?v=4" width="200">|<img src="https://github.com/Andrew-0411/ios-diary/assets/45560895/2872b119-d22b-46a7-85c4-d9e0c3dd6da8" width="250">|
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
|2023-05-01(월)|CoreDataStack, CoreDataFetchedResults객체 추가|
|2023-05-02(화)|DiaryService Unit Test, 일기장 자동저장 기능 구현|
|2023-05-03(수)|Activity, Alert 기능 구현|
|2023-05-04(목)|Localizable 기능 추가, 버그 수정|
|2023-05-05(금)|README 작성, 코드컨벤션 정리|
|2023-05-08(월)|CoreDataStack 테스트 코드 작성|
|2023-05-09(화)|CoreLocation, CoreData Migration 학습|
|2023-05-10(수)|WeatherAPI 네트워킹 객체 구성|
|2023-05-11(목)|CoreLocation 객체 구성|
|2023-05-12(금)|날씨 Icon UI에 적용, README 작성|

</details>

<br/>
<br/>

## 3. 프로젝트 구조

### 폴더 구조
```
├── Diary
│   ├── Extension
│   │   ├── ArrayExtension.swift
│   │   ├── DateFormatterExtension.swift
│   │   ├── ProcessViewController.swift
│   │   └── StringExtension.swift
│   ├── Model
│   │   ├── CoreData
│   │   │   ├── CoreDataError.swift
│   │   │   ├── CoreDataManagable.swift
│   │   │   ├── CoreDataManager.swift
│   │   │   ├── DiaryService.swift
│   │   │   └── Extension
│   │   │       └── CoreDataManger+CoreDataManagable.swift
│   │   ├── Diary+CoreDataClass.swift
│   │   ├── Diary+CoreDataProperties.swift
│   │   ├── LocationDataManager.swift
│   │   ├── Network
│   │   │   ├── APIEndpoint.swift
│   │   │   ├── DefaultNetworkProvider.swift
│   │   │   ├── HTTPMethod.swift
│   │   │   ├── NetworkError.swift
│   │   │   └── NetworkProvider.swift
│   │   └── Service
│   │       └── Weather
│   │           ├── DefaultWeatherService.swift
│   │           ├── Endpoint
│   │           │   ├── WeatherImageEndpoint.swift
│   │           │   └── WeatherInformationEndpoint.swift
│   │           ├── Protocol
│   │           │   ├── WeatherAPIEndpoint.swift
│   │           │   └── WeatherAPIInformationOwner.swift
│   │           ├── Response
│   │           │   └── WeatherResponse.swift
│   │           ├── WeatherInformation.swift
│   │           └── WeatherService.swift
│   │───View
│   │   └── DiaryCell.swift
│   ├── Controller
│   │   ├── HomeDiaryController.swift
│   │   └── ProcessViewController.swift
│   ├── Protocol
│   │   └── ReusableIdentifier.swift
│   ├── SceneDelegate.swift
│   ├── Utility
│   │   ├── DecodingUtility.swift
│   │   ├── ImageLoadUtility.swift
│   │   └── JSONDecodingUtility.swift
├── DiaryServiceTests
│   ├── DiaryServiceTests.swift
└───└── Mock
         └── MockCoreDataManager.swift
```

### UML</big></summary>

![](https://github.com/seunghyunCheon/box-office/assets/70146658/1a3573da-6fc8-45e2-a8cb-e03ecdcca4d8)




<br/>
<br/>

## 4. 실행화면
|일기장 생성|일기장 수정|일기장 삭제|
|:--:|:--:|:--:|
|<img src="https://i.imgur.com/yQ6h5RN.gif" width="200">|<img src="https://i.imgur.com/yQ6h5RN.gif" width="200">|<img src="https://i.imgur.com/MX2eJmd.gif" width="200">|

|Localization 적용|더보기->공유, 삭제|위치 정보를 통한 날씨 표시|
|:--:|:--:|:--:|
|<img src="https://i.imgur.com/hHciA5D.gif" width="200">|<img src="https://github.com/yagom-academy/ios-diary/assets/45560895/cce6fab3-33ff-4e8d-a800-b4ca7169436b" width="200">|<img src="https://github.com/Andrew-0411/Study/assets/45560895/c648f1ec-ed3c-4b2c-9079-2e0881296579" width="200">


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

### 4️⃣ NSFetchedResultsController의 사용

#### ❓ 문제점
코어데이터 저장소의 내용을 fetch해서 화면에 보여지게 한 뒤에 CRUD작업을 하는데 있어 다음과 같은 보일러 플레이트 코드가 존재했습니다. 다음은 delete의 예시입니다.
1) 코어데이터 저장소에 특정 ID를 전달해서 delete메서드를 호출하는 코드
2) 뷰컨에 존재하는 데이터배열의 index에 접근해서 제거하는 코드
3) 테이블 뷰를 업데이트하기 위해 deleteRows하는 코드

```swift
func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
    let object = self.list[indexPath.row]

    if self.delete(object: object) {
        self.list.remove(at: indexPath.row)
        self.tableView.deleteRows(at: [indexPath], with: .fade)
    }
}
```
그리고 2번과 3번은 1번이 성공했을 때 실행되어야 하기 때문에 if문을 통해서 직접 제어해야 했습니다. 
기능상 문제는 없지만 만약 이 함수 내부구현이 길어졌을 때 `tableViewDelegate`의 함수의 역할이 많아져서 유지보수하는데 조금 어려울 것이라고 생각했습니다. 

#### 📖 해결한 점
이러한 이유로 찾아본 것이 `NSFetchedResultsController`입니다. 이 컨트롤러는 CoreData에서 가져온 데이터의 결과를 관리하는 컨트롤러인데 코어데이터에 데이터를 CRUD했을 때를 감지할 수 있는 `NSFetchedResultsControllerDelegate`가 존재했습니다. 

이를 사용해서 테이블뷰에서 swipe로 셀을 지웠을 때 `delete`메서드만 사용한 후에 실제로 코어데이터의 저장소에 변경이 생기면 `NSFetchedResultsControllerDelegate`에서 관리하도록 만들었습니다. 
즉 코어데이터의 변경사항에 대한 UI변경사항을 이 객체에서 관리하게 되어 객체 간의 역할을 명확히 나누어서 유지보수에 용이하게 만들었습니다.
```swift
final class HomeDiaryController: UIViewController {
    func tableView(
        _ tableView: UITableView,
        trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath
    ) -> UISwipeActionsConfiguration? {
        let deleteAction = UIContextualAction(style: .destructive, title: "삭제".localized()) { _, _, _ in
            let diary = self.fetchedDiaryResults.fetchedResultsController.object(at: indexPath)
            self.diaryService.delete(id: diary.id)
        }
        
        return UISwipeActionsConfiguration(actions: [deleteAction, shareAction])
    }
    
}

extension HomeDiaryController: NSFetchedResultsControllerDelegate {
    func controller(
        _ controller: NSFetchedResultsController<NSFetchRequestResult>,
        didChange anObject: Any,
        at indexPath: IndexPath?,
        for type: NSFetchedResultsChangeType,
        newIndexPath: IndexPath?
    ) {
        switch type {
        case .insert:
            if let newIndexPath = newIndexPath {
                diaryTableView.insertRows(at: [newIndexPath], with: .automatic)
            }
        case .update:
            if let indexPath = indexPath {
                diaryTableView.reloadRows(at: [indexPath], with: .automatic)
            }
        case .delete:
            if let indexPath = indexPath {
                diaryTableView.deleteRows(at: [indexPath], with: .automatic)
            }
        case .move:
            if let indexPath = indexPath, let newIndexPath = newIndexPath {
                diaryTableView.moveRow(at: indexPath, to: newIndexPath)
                diaryTableView.reloadRows(at: [newIndexPath], with: .automatic)
            }
        }
    }
}
```

<br/>
<br/>

### 5️⃣ CoreData Diary관련 CRUD를 수행하는 객체 생성

#### ❓ 문제점
기존에는 `CoreDataManager`라는 객체 안에서 `Diary`라는 `NSManagedObject`에 대한 정보를 받아서 `CRUD`를 진행했습니다.

하지만 이 방법은 `CoreDataManager`객체가 `Diary`에 강하고 의존하고 있기 때문에 `Diary`에 대해서만 동작하게 되었습니다. 

#### 📖 해결한 점
`DiaryService`라는 클래스를 만들어 `Diary`에 대한 `CRUD`를 이곳에서 관리할 수 있도록 만들었습니다.
```swift
public final class DiaryService {
    let coreDataStack: CoreDataStack
    let managedContext = CoreDataStack.shared.managedContext
    let entityName = "Diary"
    
    public init(coreDataStack: CoreDataStack) {
        self.coreDataStack = coreDataStack
    }
}

extension DiaryService {
    @discardableResult
    public func create(id: UUID, title: String, body: String) -> Result<Diary, CoreDataError> {
        // do something
    }
    
    @discardableResult
    public func update(id: UUID, title: String, body: String) -> Result<Diary, CoreDataError> {
        // do something
    }
    
    @discardableResult
    public func delete(id: UUID) -> Result<Bool, CoreDataError> {
        // do something
    }
}
```

<br/>


**🛠️ 개선해야 할 점**
<br/>
하지만 이 방법은 코어데이터에서 `Diary`에 관한 처리를 보기 편해졌을뿐 범용성에 대한 부분은 향상되지 않았습니다. 
만약 10개의 엔티티가 존재한다면 10개의 Service를 만들어야 하는 상황이었던 것이죠.

이 부분은 추후 여러 코어데이터를 범용성있게 사용하는 사례를 찾아보면서 제네릭과 protocol Extension을 이용해 개선할 예정입니다.


## 6. 참고자료
- [Apple Docs: Layout](https://developer.apple.com/design/human-interface-guidelines/foundations/layout/)
- [WWDC 2016: Making apps adaptive part 1](https://www.youtube.com/watch?v=hLkqt2g-450&ab_channel=anhpham)
- [WWDC 2016: Making apps adaptive part 2](https://www.youtube.com/watch?v=s3utpBiRbB0&ab_channel=anhpham)
- [WWDC 2018: UIKit: Apps for Every Size and Shape](https://developer.apple.com/videos/play/wwdc2018/235/)
- [WWDC 2019: Making Apps with Core Data](https://developer.apple.com/videos/play/wwdc2019/230/)
- [Apple Docs: DateFormatter](https://developer.apple.com/documentation/foundation/dateformatter)
- [Apple Docs: UITextView](https://developer.apple.com/documentation/uikit/uitextview)
- [Apple Docs: Core Data](https://developer.apple.com/documentation/coredata)
- [Apple Docs: UITextViewDelegate](https://developer.apple.com/documentation/uikit/uitextviewdelegate)
- [Apple Docs: UISwipeActionsConfiguration](https://developer.apple.com/documentation/uikit/uiswipeactionsconfiguration)
- [Apple Docs - adjustedcontentinset](https://developer.apple.com/documentation/uikit/uiscrollview/2902259-adjustedcontentinset)
- [Apple Docs - contentInsetAdjustmentBehavior](https://developer.apple.com/documentation/uikit/uiscrollview/2902261-contentinsetadjustmentbehavior)
- [Apple Docs - Core Location](https://developer.apple.com/documentation/corelocation)
- [Apple Docs - Getting the current location of a device](https://developer.apple.com/documentation/corelocation/getting_the_current_location_of_a_device)
- [Apple Docs - Configuring your app to use location services](https://developer.apple.com/documentation/corelocation/configuring_your_app_to_use_location_services)
- [Apple Docs - Requesting authorization to use location services](https://developer.apple.com/documentation/corelocation/requesting_authorization_to_use_location_services)
- [Apple Docs - Using Lightweight Migration](https://developer.apple.com/documentation/coredata/using_lightweight_migration)
