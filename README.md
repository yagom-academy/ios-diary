# 일기장

## 프로젝트 소개
일기장 어플리케이션을 관리해본다.

> 프로젝트 기간: 2022-08-16 ~ 2022-09-02</br>
> 팀원: [수꿍](https://github.com/Jeon-Minsu), [Finnn](https://github.com/finnn1) </br>
리뷰어: [GRENN](https://github.com/GREENOVER)</br>


## 📑 목차

- [🧑🏻‍💻🧑🏻‍💻 개발자 소개](#-개발자-소개)
- [⏱ TimeLine](#-TimeLine)
- [💡 키워드](#-키워드)
- [🤔 핵심경험](#-핵심경험)
- [🗂 폴더 구조](#-폴더-구조)
- [📝 기능설명](#-기능설명)
- [🚀 TroubleShooting](#-TroubleShooting)
- [📚 참고문서](#-참고문서)


## 🧑🏻‍💻🧑🏻‍💻 개발자 소개

|수꿍|Finnn|
|:---:|:---:|
|<image src = "https://i.imgur.com/6HkYdmp.png" width="250" height="250">|<img src="https://i.imgur.com/5EQ0KJy.png" width="250" height="250">
|[수꿍](https://github.com/Jeon-Minsu)|[Finnn](https://github.com/finnn1)|

## ⏱ TimeLine

### Week 1
    
> 2022.08.16 ~ 2022.08.19
    
- 2022.08.16
    - 간단한 자기소개
    - 전반적인 프로젝트 수행 계획 수립
    - 계획을 기반으로 코드 작성
    - `JSON` 샘플 데이터 파싱 구현
    - `UITableView` 구현
    - `TableView`의 `CustomCell` 구현 및 `JSON` 데이터 연동
    - `Text font`가 `Dynamic Size`에 대응하도록 구현
    - `DateFormatter`를 활용한 localize된 날짜 표기형식 구현
    - `UITextView`를 활용한 메모 작성 페이지 구현
    - `UITextView`에 내용 작성시 소프트웨어 키보드가 작성중인 글을 가리지 않도록 수정

- 2022.08.17 
    - 컨벤션 수정 전반적인 및 리팩토링
    - `STEP1 PR` 작성
    
- 2022.08.18
    - `System Appearance`를 고려한 테마 색상 구현
    - `TableView Delegate`를 활용한 `Cell deselect` 구현
    - `Parsing Error handling`

- 2022.08.19
    - `CoreData` 관리를 위한 `Manager` 타입 선언
    - `CoreDataManager`를 사용해 `CRUD` 기능 구현
    - 전체적인 데이터 로직을 `JSON`에서 `CoreData` 기반으로 변경
    
### Week 2

> 2022.08.22 ~ 2022.08.24
    
- 2022.08.22
    - 일기장 `Content` 페이지 구성
    - `NSFetchedResultsControllerDelegate`를 활용한 저장 로직 구현
    - `View LifeCycle`에 따른 로직 수정
    
- 2022.08.23
    - `SearchController`를 사용해 `SearchBar` 구현
    - `TableView`에서 `Swipe`로 공유 및 삭제가 가능하도록 함.
    - 전반적인 컨벤션 수정 및 리팩토링
    
- 2022.08.24
    - 전반적인 컨벤션 수정 및 리팩토링
    - `STEP 2 PR` 작성
    
- 2022.08.25
    - 검색시 `SearchBar` 색상 오류 수정
    - `ViewContext` 커스텀으로 처리
    - `fetch` 방식을 `UUID`로 변경
    
- 2022.08.26
    - `body`가 없을 경우 저장되지 않았던 문제 수정
    - 스크롤시 `searchBar`가 숨겨지도록 변경
    
### Week 3

> 2022.08.29 ~ 2022.08.30
    
- 2022.08.29
    - `OpenWeatherAPI` `fetching`을 위한 `DataType` 정의
    - `Weather` 데이터 처리를 위한 `Manager` 타입 정의
    - `CoreData`에 날씨 정보 `Attributes` 추가
    
- 2022.08.30
    - `CoreLocation`을 통해 사용자에게 위치 정보 요청
    - 위치 정보를 기반으로 `Weather` 데이터 다운로드
    - 날씨 아이콘을 각 셀에 적용
    - 전반적인 컨벤션 수정 및 리팩토링
    - `STEP 3 PR` 작성
    
## 💡 키워드

- `JSONDecoder`, `NSDataAsset`, `Parsing`
- `TimeInterval`, `timeIntervalSince1970`
- `DateFormatter`, `Locale`, `TimeZone`, `current`
- `UITableViewDiffableDataSource`
- `keyboardFrameEndUserInfoKey`, `contentInset`, `scrollIndicatorInsets`
- `CoreData`, `NSPersistentStoreCoordinator`, `NSPersistentContainer`, `NSPersistentStore`, `NSManagedObjectContext`
- `Entity`, `NSFetchRequest`, `NSPredicate`, `NSSortDescriptor`
- `NSFetchedResultsController`, `performFetch`, `fetchedObjects`
- `NSFetchedResultsControllerDelegate`
- `Snapshot`, `appendItems`, `insertItems`, `deleteItems`, `reloadSections`
- `UISearchController`, `searchResultsUpdater`, `hidesSearchBarWhenScrolling`
- `DataSource`, `itemIdentifier`
- `Action Sheet`, `Alert`
- `UISwipeActionsConfiguration`, `performsFirstActionWithFullSwipe`
- `UIActivityViewController`, `activityItems`, `applicationActivities`
- `NSMutableAttributedString`, `firstIndex`, `utf16Offset`, `NSMakeRange`, `substring`
- `Notification`, `willResignActiveNotification`
- `Tuple`
- `Core Location`, `CLLocationManagerDelegate`, `CLLocationManager`, `authorizationStatus`
- `requestLocation`, `CLLocation`, `coordinate`, `latitude`, `longitude`
- `Open API`, `Networking`

    
## 🤔 핵심경험

- [x] Date Formatter의 지역 및 길이별 표현의 활용
- [x] Text View의 활용
- [x] 코어데이터 모델 생성
- [x] 코어데이터 모델 및 DB 마이그레이션
- [x] 테이블뷰에서 스와이프를 통한 삭제기능 구현
- [x] Open API의 활용
- [x] Core Location의 활용

## 🗂 폴더 구조

```
.
├── Diary
│   ├── Controllers
│   │   ├── DiaryContentsViewController.swift
│   │   └── DiaryListViewController.swift
│   ├── Error
│   │   ├── APIError.swift
│   │   ├── FetchingError.swift
│   │   ├── GPSError.swift
│   │   └── ParsingError.swift
│   ├── Extension
│   │   ├── Date+Extension.swift
│   │   ├── Int+Extension.swift
│   │   ├── UIViewController+Extension.swift
│   │   └── URLComponents+Extension.swift
│   ├── Models
│   │   ├── DiarySampleData.swift
│   │   ├── JSONData.swift
│   │   └── WeatherDataEntity.swift
│   ├── Namespaces
│   │   ├── ActionSheet.swift
│   │   ├── Alert.swift
│   │   ├── AssetData.swift
│   │   ├── DiaryCoreData.swift
│   │   ├── HTTPMethod.swift
│   │   ├── NavigationItem.swift
│   │   ├── NewLine.swift
│   │   ├── SearchControllerItem.swift
│   │   ├── SystemImage.swift
│   │   └── WeatherURLQueryItem.swift
│   ├── Resources
│   │   ├── API
│   │   │   ├── APIClient.swift
│   │   │   ├── APIConfiguration.swift
│   │   │   └── APIProtocol
│   │   │       ├── APIProtocol.swift
│   │   │       └── GETProtocol.swift
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
│   │   ├── Base.lproj
│   │   │   └── LaunchScreen.storyboard
│   │   ├── CoreData
│   │   │   ├── CoreDataManager.swift
│   │   │   ├── Diary+CoreDataClass.swift
│   │   │   └── Diary+CoreDataProperties.swift
│   │   ├── Diary.xcdatamodeld
│   │   │   └── Diary.xcdatamodel
│   │   │       └── contents
│   │   ├── Info.plist
│   │   ├── SceneDelegate.swift
│   │   ├── URLComponentsBuilder.swift
│   │   └── WeatherManager
│   │       ├── WeatherDataAPIManager.swift
│   │       └── WeatherImageAPIManager.swift
│   └── Views
│       ├── DiaryContentView.swift
│       ├── DiaryListCell.swift
│       └── DiaryListView.swift
└── README.md
```
    
## 📝 기능설명

### STEP 1
    
**작성한 일기장 목록을 보여주는 TableView 구현**
    
    - JSON 샘플 데이터 파싱 구현
    - UITableView 구현
    - TableView의 CustomCell 구현 및 JSON 데이터 연동
    - Text font가 Dynamic Size에 대응하도록 구현
    - DateFormatter를 활용한 localize된 날짜 표기형식 구현
   
**새로운 일기장 작성을 위한 TextView 구현**
    
    - UITextView를 활용한 메모 작성 페이지 구현
    - UITextView에 내용 작성시 소프트웨어 키보드가 작성중인 글을 가리지 않도록 수정
    
### STEP 2

**각 Cell을 터치 할 경우 해당 메모를 불러오는 기능**
    
    - `UITableViewDelegate`의 `didSelectRowAt` 메서드 사용
    - 해당 `cell`의 `indexPath`에 해당하는 `diary` 데이터 추출 
    - 네비게이션 컨트롤러를 이용하여 프로퍼티 주입
    
**메모 작성 및 수정시 자동 저장 기능 구현**
    
    - `TableView` 리스트로 이동 시
    - 키보드가 내려갈 경우
    - 앱이 `ResignActive` 상태로 넘어갈 경우

**메모 작성중 우측 상단 버튼을 터치하면 Share 및 Delete 가 가능하도록 구현**
    
    - `UIAlertController`(`ActionSheet`) 사용
    - `Share` 시, `UIActivityViewController Present`
    - `Delete` 시, `Alert` 띄우기
        - 삭제 액션 클릭 시, 이전 뷰로 이동 및 코어데이터 내 해당 일기 삭제
    
**TableView 리스트에서 Swipe Gesture를 통해 Share 및 Delete가 가능하도록 구현**
    
    - UITableViewDelegate 내 trailingSwipeActionsConfigurationForRowAt 메서드 사용
    - UISwipeActionsConfiguration 내 share 및 delete 메서드 구현
        - 각 기능 메서드는 위의 메모 작성중 우측 상단 버튼에 사용된 메서드와 유사
    
**TableView 에서 원하는 일기를 검색할 수 있도록 SearchBar 구현**
    
    - `UISearchController` 생성 후, `navigationItem`에 적용
    - `UISearchResultsUpdating` 내 `updateSearchResults` 메서드 사용
        - 원하는 일기 검색 시, `title`과 `body`에 해당 내용이 포함되어 있는 일기만을 `Core Data`에서 `fetch`
        - 일기 검색 초기화 시, 다시 모든 일기를 `Core Data`에서 `fetch`

### STEP 3
    
**현재 사용자의 위치(Core Location)를 기반으로 현재 날씨정보(Open Weather API) 가져오기**
    
    - Open Weather API 데이터를 fetch해오는 WeatherDataAPIManager 정의
    - CLLocationManager 인스턴스를 생성하여 requestLocation 메서드 호출
    - CLLocationManagerDelegate 프로토콜을 통한 Location 업데이트 시
        - WeatherDataAPIManager를 통해 Weather Data 가져오기
        - diary의 main, icon 프로퍼티 할당
    

## 🚀 TroubleShooting

### STEP 1
#### T1. `KeyBoard` 숨김 기능 감지 방법
- 일기장 생성 화면으로 이동하였을 때, `textView`의 `keyboardDismissMode` 프로퍼티를 `interactive`로 설정하니, 드래그가 가능한 상황에서는 화면을 위로 일정 정도 스크롤을 해보니, 키보드가 정상적으로 사라질 수 있었습니다.
- 그러나, 일기장에 아무것도 입력하지 않은 초기 화면인 경우, 입력한 내용이 없기 때문에 스크롤이 불가능하여 키보드가 사라질 수 없었습니다.
- 이에 대하여 고민해본 결과, `textView`의 `alwaysBounceVertical` 프로퍼티를 `true`로 설정하여, 초기 화면에서도 수직 스크롤을 가능하게 하여, 일정 정도 스크롤을 하면 키보드가 정상적으로 사라질 수 있었습니다.

### STEP 2
#### T1. TableView snapShot 업데이트 에러

- 아래와 같이, `NSFetchedResultsControllerDelegate`를 채택하여 `NSFetchedResultsController`에 변화가 감지될 때, `controllerWillChangeContent` 메서드 내에서 `tableView`의 `beginUpdates` 메서드를 시작으로, `controllerDidChangeContent` 메서드 내 `tableView`의 `endUpdates` 메서드에 다다를 때까지, 감지한 `insert`, `delete`, `update`에 대한 내용을 `snapShot`에 적용하고, `dataSource`에서 `snapShot`을 `apply`를 하고자 하였습니다.
    
- **기존 코드 :**
    ```swift
    extension DiaryListViewController: NSFetchedResultsControllerDelegate {
        func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
            diaryView.tableView.beginUpdates()
        }
        
        func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
            
            ...
            
            switch type {
            case .insert:
                
                ...
                
                snapShot.insertItems([diaryData], beforeItem: lastDiaryData)
            case .delete:
                snapShot.deleteItems([diaryData])
            case .update:
                snapShot.reloadSections([.main])
            default:
                break
            }
            
            dataSource?.apply(snapShot)
        }
        
        func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
            diaryView.tableView.endUpdates()
        }
    }
    ```
- 하지만, 위의 경우 `DiaryListViewController`에서는 아무 문제가 없었지만, 다음 뷰컨트롤러인 `DiaryContentViewController`에서 `DiaryListViewController`로 돌아올 때, `DiaryListViewController`에서는 화면이 표시되기 전에, `tableView`의 `UI`에 관한 내용에 영향을 미쳐 콘솔로그에 에러 메시지가 나타났습니다.
    
- 해당 문제상황을 `tableView`를 다시 그리는 과정이 `DiaryListViewController`로 돌아온 이후에 수행되어야 하는데, 돌아오기 전에 수행되어 에러 메시지가 나온 것이라 판단을 내렸습니다. 이에, 영향을 주는 메서드를 확인해본 결과, `beginUpdate`, `endUpdates`, `dataSource`의 `apply` 메서드가 영향을 미치고 있었습니다.
    
- `beginUpdate`, `endUpdates`의 경우 `tableView`를 변경하는 메소드들을 여러번 호출해야 하는 경우 필요한 메서드였습니다. 하지만 일기장의 경우, 일기장 저장, 업데이트, 삭제가 각각 독립적으로 호출되고 있기 때문에 해당 메서드를 사용할 필요가 없었습니다. 이에 해당 메서드를 제거하였습니다.
    
- 다음으로, `dataSource`의 `apply` 메서드는 일기장 저장 및 업데이트의 경우는 결국 `DiaryListViewController`로 돌아오니, `viewDidDisappear`에서 `apply` 메서드를 호출하였고, 삭제의 경우는 `DiaryListViewController` 내 `swipeConfiguration`을 통해서도 이루어지므로, `viewDidDisappear`을 호출하지 않기 때문에, `deleteDiary` 메서드가 호출될 때, 바로 `apply` 메서드를 사용하여 문제를 해결하였습니다.

- **수정 코드 :**
    
    ```swift
    final class DiaryListViewController: UIViewController {
            override func viewDidAppear(_ animated: Bool) {
                    super.viewDidAppear(animated)
            
            dataSource?.apply(snapshot)
            }
    
            private func deleteDiary(createdAt date: Date) {
            do {
                try CoreDataManager.shared.delete(createdAt: date)
                dataSource?.apply(snapshot)
            } catch {
                presentErrorAlert(error)
            }
        }
    }
    
    extension DiaryListViewController: NSFetchedResultsControllerDelegate {
        func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
            
            switch type {
            case .insert:
                
                ...
                
                snapShot.insertItems([diaryData], beforeItem: lastDiaryData)
            case .delete:
                snapShot.deleteItems([diaryData])
            case .update:
                snapShot.reloadSections([.main])
            default:
                break
            }
    
        // dataSource?.apply(snapShot) 메서드 삭제
        }
    }
    ```

#### T2. SearchBar에서 검색시 올바르게 뜨지 않는 문제
- `SearchBar`에서 일기장을 검색 할 경우 검색된 내용의 개수는 맞았지만, 검색된 데이터가 다르게 뜨는 문제가 발생했습니다.

- 원인을 분석해 본 결과 현재 프로젝트에서 `NSFetchedResultsController`를 사용하고 있는데, `dataSource` 내부에서 `Cell`을 `dequeue`하는 과정에서도 `NSFetchedResultsController` 내부의 `fetch`를 하는 메서드를 사용했기 때문이었습니다.

- 결과적으로 `dataSource` 내부에서는 `snapshot`으로부터 전달받은 `item`을 할당해주니 정상적으로 해결되었습니다.
    
- **기존 코드 :**
```swift
private func configureDataSource() {
    configureSnapshot()
    
    let tableView = diaryView.tableView
    
    dataSource = UITableViewDiffableDataSource<Section, DiaryData>(
        tableView: tableView,
        cellProvider: { tableView, indexPath, item in
            guard let cell = tableView.dequeueReusableCell(
                withIdentifier: DiaryListCell.identifier,
                for: indexPath
            ) as? DiaryListCell else {
                return nil
            }
            
            let diary = self.fetchResultsController.object(at: indexPath)
            cell.titleLabel.text = diary.title
            cell.dateLabel.text = diary.createdAt?.localizedString
            cell.bodyLabel.text = diary.body
            cell.accessoryType = .disclosureIndicator
            
            return cell
        }
    )
}
```
- **수정 코드 :**
```swift
private func configureDataSource() {
    let tableView = diaryView.tableView
        
    dataSource = UITableViewDiffableDataSource<Section, Diary>(
        tableView: tableView,
        cellProvider: { tableView, indexPath, item in
            guard let cell = tableView.dequeueReusableCell(
                withIdentifier: DiaryListCell.identifier,
                for: indexPath
            ) as? DiaryListCell else {
                return nil
            }
            
            cell.titleLabel.text = item.title
            cell.dateLabel.text = item.createdAt?.localizedString
            cell.bodyLabel.text = item.body
            cell.accessoryType = .disclosureIndicator
            
            return cell
        }
    )
    
    dataSource?.apply(snapshot)
}
```
    
### STEP 3
#### T1. 일기의 `Title`과 `Body` 구분 로직
- `Title`과 `Body`를 구분하는 이전 로직을 검토해본 결과, `Body`가 없이 `Title`로만 일기를 구성하였을 때도, 일기가 저장되는 것이 옳은 일기장 어플리케이션 구현이라고 판단하였습니다. 이러한 생각을 바탕으로, 로직을 수정하던 중, `Body`의 경우 개행이 2번된 경우, 일기장 리스트 화면에서 `Body`의 내용물이 아닌, 개행으로 인한 빈 내용이 표시되는 문제가 발생하였습니다.
    
- 이를 해결하기 위하여 다음과 같이 코드를 수정해보았습니다. 먼저, `diaryContentView` 내 `textView`의 `text`를 옵셔널 바인딩 후, 개행을 기준으로 `split`을 진행하였습니다. 그리고 `split`된 문자열 배열의 첫번째 구성요소는 `title`에 해당할 것이므로, `title`에 담았고, `title` 값이 없을시, `textView`의 값은 유의미한 글자가 없는 값이므로 `nil` 처리를 하여 일기를 `save`하지 않도록 처리하였습니다. 그리고 만일 `splitText`의 `count`가 1보다 크지 않으면, 선행 조건에서 이어진 경우이기에, `count`가 1인 경우이므로, `title`만 있는 경우이기에 `(String(title), DiaryCoreData.emptyBody)`로 타이틀과 빈 바디를 반환하였습니다. 그리고 전체 `diaryConentViewText`에서 `body`가 시작되는 인덱스부터를 범위로 삼아 `body`를 추출하였습니다.

- 코드
```swift
private func extractTitleAndBody() -> (String, String)? {
    guard let diaryConentViewText = diaryContentView.textView.text else {
        return nil
    }
    
    let splitedText = diaryConentViewText.split(separator: NewLine.lineFeed)
    
    guard let title = splitedText.first else {
        return nil
    }
    
    guard splitedText.count > 1 else {
        return (String(title), DiaryCoreData.emptyBody)
    }
    
    let body = diaryConentViewText[splitedText[1].startIndex...]
    
    return (String(title), String(body))
}
```
    
    
## 📚 참고문서

- [Adaptivity and Layout](https://developer.apple.com/design/human-interface-guidelines/foundations/layout/)
- [UIKit: Apps for Every Size and Shape](https://developer.apple.com/videos/play/wwdc2018/235/)
- [Making Apps Adaptive, Part 1 / Script](https://www.youtube.com/watch?v=hLkqt2g-450)
- [Making Apps Adaptive, Part 2 / Script](https://www.youtube.com/watch?v=s3utpBiRbB0)
- [DateFormatter](https://developer.apple.com/documentation/foundation/dateformatter)
- [UITextView](https://developer.apple.com/documentation/uikit/uitextview)
- [Core Data](https://developer.apple.com/documentation/coredata)
- [Making Apps with Core Data](https://developer.apple.com/videos/play/wwdc2019/230/)
- [UITextViewDelegate](https://developer.apple.com/documentation/uikit/uitextviewdelegate)
- [UISwipeActionsConfiguration](https://developer.apple.com/documentation/uikit/uiswipeactionsconfiguration)
- [Dynamic Type Sizes](https://developer.apple.com/design/human-interface-guidelines/foundations/typography/)
- [Open Weather - Current weather data](https://openweathermap.org/current)
- [Core Location](https://developer.apple.com/documentation/corelocation)
    - [Getting the User’s Location](https://developer.apple.com/documentation/corelocation/getting_the_user_s_location)
    - [Adding Location Services to Your App](https://developer.apple.com/documentation/corelocation/adding_location_services_to_your_app)
    - [Requesting Authorization for Location Services](https://developer.apple.com/documentation/corelocation/requesting_authorization_for_location_services)
- [Using Lightweight Migration](https://developer.apple.com/documentation/coredata/using_lightweight_migration)

    
--- 
    
## 1️⃣ STEP 1

### STEP 1 Questions & Answers

#### Q1. `View`와 `ViewController` 분리로 인한 문제
- `ViewController`의 기본 `view`를 `DiaryView`로 교체를 하였는데, `diaryView`를 사용하기 위하여, 이를 사용하는 모든 메서드에서 `guard let`을 통한 다운캐스팅이 필요하였습니다. 
- 이 때문에 동일한 코드가 중복적으로 발생하여, 해당 문제를 해결하기 위해 코드의 유연성을 높일 수 있는 방법이 무엇이 있을지 질문드리고 싶습니다.

#### A1. `View`와 `ViewController` 분리로 인한 문제

- 해당 `DiaryContentView`를 `loadView` 메서드에서가 아닌 해당 클래스에서 전역적으로 사용할 수 있도록 프로퍼티로 빼서 주입하면 됩니다. 즉, 해당 클래스를 생성할때 `DiaryContentView` 타입의 `diaryContentView` 프로퍼티를 클래스가 가질 수 있도록 주입받거나 내부에서 정의 및 생성해주고, 그 뒤 `loadView`에서 `view = diaryView`와 같은 형태로 해당 클래스에서의 `view` 값을 넣어주면 바인딩 및 다운 캐스팅은 하지 않아도 되기에 코드 중복은 피할 수 있습니다.
 

- 코드
    
    ```swift
    final class DiaryContentsViewController: UIViewController {
        private let diaryContentView = DiaryContentView()
    
        override func loadView() {
            view = diaryContentView
            ...
        }
    
        ...
    
        @objc private func keyboardWillShow(_ notification: Notification) {
            ...
            
            diaryContentView.textView.contentInset = contentInset
            diaryContentView.textView.scrollIndicatorInsets = contentInset
        }
        
        @objc private func keyboardWillHide() {
            ...
            
            diaryContentView.textView.contentInset = contentInset
            diaryContentView.textView.scrollIndicatorInsets = contentInset
        }
    }
    ```
    
## 2️⃣ STEP 2
    
### STEP 2 Questions & Answers

#### Q1. NSFetchResultsController 메서드 현업 사용 여부
- `Core Data`를 활용하는 방법으로, 단독으로 `Core Data`의 `persistentContainer`나 `viewContext`를 이용하여 `CRUD` 작업을 수행할 수 있지만, `NSFetchResultsController`로도 처리가 가능하다는 것을 배웠습니다.
    
- `NSFetchResultsController`는 코어 데이터 `fetch` `request`의 결과를 관리하고 사용자에게 데이터를 표시하는 데 사용하는 컨트롤러로, `Core Data`만 단독으로 사용할 땐 데이터를 추가 또는 삭제를 한 뒤 데이터가 사용되는 `TableView` 등에 직접 `reloadData()`를 호출해서 수동으로 `UI` 업데이트를 해줘야 하지만, `NSFetchedResultsController`를 사용하면 `NSFetchedResultsControllerDelegate`를 활용하여 `Core Data`의 `context`를 본인이 모니터링해서 `saveContext()`가 호출될 때마다 대신 업데이트를 합니다.
    
- 이에 저희는 `TableView`를 활용할 때는, `NSFetchResultsController`를 사용하는 것이 더욱 편리하다고 생각하여 이를 이번 프로젝트에 적용해보았습니다. 현업에서는 코어 데이터를 사용할 때, `NSFetchResultsController`를 적극적으로 사용하는지 여쭈어보고 싶습니다.

#### A1. NSFetchResultsController 메서드 현업 사용 여부
    
- 현업에서 사용 여부를 물어보시면 두괄식으로 먼저 말씀드리면 조건이 있는 예쓰였다. 지금처럼 로컬 DB를 활용해야 하는 경우에서 `CoreData`를 사용한다고 치면 지금 같은 상황에서는 이미 잘 만들어놓은 `NSFetchResultsController`라는 `API`를 사용하지 않을 이유가 없다고 한다. 그 이유는 이번 스텝2를 진행하며 느꼈던 장점이 답이 될 수 있다. 그럼 왜 조건이 있는 예쓰라고 했는지 의문이 들 수 있다. 거기에 대한 대답은 일단 당연히 이건 모든 조직마다 현업마다 다르겠지만 그린의 경우 `CoreData` 대신 주로 `Realm`이라는 라이브러리를 사용한다고 한다. `Realm`을 사용하면 좀 더 편리하고 직관적으로 사용할 수 있다고 한다. 그렇기에 현업에서 `CoreData`를 사용한다면 `NSFetchResultsController`를 상황에 맞게 활용하겠지만 애초에 다른 로컬 `DB` 라이브러리를 활용한다면 사용하지 않을 것이다. 
    
#### Q2. `appDelegate.persistentContainer.viewContext.save()` vs `appDelegate.saveContext()`
- `CoreData`를 처리할 때 처음에는 `persistentContainer` 내부에 있는 `viewContext.save()`를 통해 직접 저장을 처리하고, 그에 따른 에러를 처리했었습니다.
- 그런데 `CoreData`를 생성할 때 `AppDelegate.swift` 파일 내부에 `appDelegate.saveContext()`라는 메서드가 기본적으로 생성된다는 것을 깨닫고, 애플에서 기본적으로 만들주는 코드이기 때문에 사용하는 것이 좋지 않을까 하는 생각에 해당 메서드를 통해 `CoreData`에 데이터가 저장이 되도록 처리했습니다.
- `appDelegate.saveContext()` 메서드의 내부 구현을 보니 결국엔 `viewContext.save()`를 통해서 저장되는 것 같은데, 에러가 발생할 경우 `fatalError`를 발생시는 것을 확인했습니다.
    
- **AppDelegate 폴더 내부의 saveContext() 메서드 정의부 :**
```swift
// MARK: - Core Data Saving support

func saveContext() {
    let context = persistentContainer.viewContext
    if context.hasChanges {
        do {
            try context.save()
        } catch {
            let nserror = error as NSError
            fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
        }
    }
}
```

- 애플에서 기본적으로 제공해주고 있는 `saveContext()` 메서드를 사용해서 처리하는 것이 좋을지, 아니면 직접 `context.save()`를 호출해서 데이터 저장 후, 에러를 별도로 직접 처리해주는 것이 좋은지 궁금합니다! 🙏
    
#### A2. `appDelegate.persistentContainer.viewContext.save()` vs `appDelegate.saveContext()`
    
- 그린의 경우 가령 이 부분 뿐만 아니라 최대한 커스텀하게 처리해주는걸 선호한다고 리뷰해주었다. 이유는 에러 처리를 명확하게 우리가 원하는 방식으로 해주는게 더 적절하다고 생각하기 때문이었다. fatalError 자체는 기본적으로 애플에서 흔히 뭐 없을때 그냥 작성한 느낌으로 사용될 때가 많다고 한다. 사실 앱 크래쉬를 내지 않아도 되는것인데도 약간 관습처럼 넣는 경우가 많다. 그렇기에 애플의 기본 API를 그렇게 많이 신뢰하면서 따르지는 않는다 한다. 그렇기에 답은 직접 필요한 메서드를 호출해 fatalError 대신 원하는 방식에 맞게 에러를 별도로 처리해주는 방법이 더 적절하다고 생각한다.
    
#### Q3. 튜플 조건문 가독성 향상 고민 

- `fetchSuccess` 상수의 경우, 해당 일기가 이미 일전에 작성한 일기인지 확인하기 위한 `Diary` 타입의 값이고, `isDeleted` 변수의 경우 액션시트를 통해 삭제 기능이 요청되어 있는지 판단하기 위한 `Bool` 값입니다. 처음에는 이를 `guard`를 통해 분기를 하려고 했지만, `else` 케이스 안에 또 `guard`문을 필요로하여, `switch`문을 이용하면 분기를 좀 더 간결하게 표현할 수 있었습니다.
    
- 다만, 튜플 값을 이용하여 switch 문을 사용하다보니 (nil, false), (_, false) case와 같이 한눈에 어떤 경우인지 파악하기는 힘들 것 같다는 생각이 들었습니다. 이를 좀 더 가독성 좋게 표현하기 위해서는 어떤 방법을 활용하면 좋을지 조언을 구하고 싶습니다! 
    
- 코드
```swift
private func determineDataProcessingFor(_ title: String, _ body: String, _ creationDate: Date) throws {
        let fetchSuccess = CoreDataManager.shared.fetchDiary(createdAt: creationDate)

        switch (fetchSuccess, isDeleted) {
        case (nil, false):
            CoreDataManager.shared.saveDiary(
                title: title,
                body: body,
                createdAt: creationDate
            )
        case (_, false):
            try CoreDataManager.shared.update(
                title: title,
                body: body,
                createdAt: creationDate
            )
        case (_, true):
            try CoreDataManager.shared.delete(createdAt: creationDate)
        }
    }
```
    
#### A3. 튜플 조건문 가독성 향상 고민     

- 현재 작성한 튜플 조건문의 가독성은 특별한 문제가 없는 상태로 다시 판단되어, 별다른 수정을 진행하지 않았다.

#### Q4. UISearchController 내부의 obscuresBackgroundDuringPresentation 프로퍼티 사용시 정상적으로 나타나지 않는 문제
- `UISearchController` 내부의 `obscuresBackgroundDuringPresentation` 프로퍼티를 true로 설정할 경우 아래의 사진처럼 나와야 하는 것으로 알고 있었습니다.

<image src = "https://i.imgur.com/58GWKOi.png" width="300" height="250">
    
- 하지만 저희가 `obscuresBackgroundDuringPresentation` 프로퍼티를 `true`로 설정했을 때는 아래와 같은 결과가 나타났습니다.

<image src = "https://i.imgur.com/8e0lYDt.png" width="300" height="350">

- 위 사진처럼 나타나는 것이 정상인 것으로 보여지는데, 혹시 아래처럼 `SearchBar` 까지 어두워지는 이유를 알 수 있을까요? 🥲

- 이러한 문제로 코드에서는 `obscuresBackgroundDuringPresentation` 프로퍼티를 제거한 상태입니다.
    
- **기존 코드 :**
```swift
private func configureSearchController() {
    let searchController = UISearchController(searchResultsController: nil)
    searchController.searchResultsUpdater = self
    searchController.searchBar.placeholder = SearchControllerItem.placeHolder
    searchController.obscuresBackgroundDuringPresentation = true
    navigationItem.searchController = searchController
    navigationItem.hidesSearchBarWhenScrolling = false
}
```

- **수정 코드 :**
```swift
private func configureSearchController() {
    let searchController = UISearchController(searchResultsController: nil)
    searchController.searchResultsUpdater = self
    searchController.searchBar.placeholder = SearchControllerItem.placeHolder
    navigationItem.searchController = searchController
    navigationItem.hidesSearchBarWhenScrolling = false
}
```

#### A4. UISearchController 내부의 obscuresBackgroundDuringPresentation 프로퍼티 사용시 정상적으로 나타나지 않는 문제
    
- `obscuresBackgroundDuringPresentation = true` 설정은 백그라운드 그러니까 해당 서치바까지 감싸져 있는 배경에 적용된다. 즉 아래처럼 뷰 디버깅을 해보면 서치바가 올려져 있는 배경 전체가 딤드된걸 볼 수 있다.

- 이미지
    
    ![Untitled 2](https://user-images.githubusercontent.com/99063327/186930966-827574d7-264f-48a9-9c2b-cc139068b23d.png)
    

- 그렇기에 저 설정이 서치바는 그대로 흰색인데 그 밑에 리스트만 자동으로 구현해주는건 아닐것 같고, 우리가 원하는 예시는 별도 처리가 더 이뤄져 있을 것이다. 

- 현재 서치바나 특정 네비게이션 부분의 background 색상을 특별히 지정해주지 않았기에 시스템을 따라간 것이다. 즉 이것들이 올려진 백그라운드를 따라간 것이 된다. 그렇기에 우리가 구상한 검색창을 구현하기 위해서는처리를 원하는 컴포넌트들에 기본 색상을 지정해줘야 한다. 아래의 코드를 통하여 단순히 서치바 구성 시 서치바의 백그라운드 색상을 white로 지정해주면 해결이 되는 간단한 문제였다.


- 코드
```swift
searchController.obscuresBackgroundDuringPresentation = true
searchController.searchBar.backgroundColor = .white
```
    
## 3️⃣ STEP 3
    
### STEP 3 Questions & Answers

#### Q1. 시뮬레이터에서 Location 변경시 정상적으로 적용되지 않는 문제
- 이번 프로젝트를 진행하면서 `CoreLocation`으로 사용자에게 위치 정보를 받아오는 요구사항이 있었습니다.
- 위치가 제대로 들어가는지 확인하기 위해서 `Simulator`에서 `location`을 변경해봤지만, 변경된 위치가 들어가지 않고, 이 전에 설정했던 위치가 계속 들어갔습니다.
- 그런데 정말 이상하게도 아이폰 기본 지도 앱을 한번 실행한 후 다시 테스트를 했을때는 `Location`을 변경해줬을때 바로바로 적용이 되었습니다.

![](https://i.imgur.com/oAmI4Ea.png)

![](https://i.imgur.com/QxV7koj.png)

- ⬆️ 해당 메뉴에서 위치를 변경해도 `Simulator`에서는 바로 적용되지 않는 문제가 발생했습니다.
- 단순히 애플 기본 지도 앱을 실행 후 종료해주는 것 만으로 해결되었습니다.
- 올바른 해결방법이 아니라는 생각이 들어 혹시 원인을 아시는지 궁금합니다 🤔
    
#### Q2. 서버에서 데이터를 받아오고 있는 중인지 체크하는 법
- save 기능이 구현된 메서드가 호출되면 `Weather` 아이콘을 인터넷에서 받아오고 있습니다.
- 하지만 이전 프로젝트 구현 사항으로 일기장의 저장 경우의 수는 일기장 목록으로 되돌아갈 때, 백그라운드에 들어갈 때, 키보드가 내려갈 때로, 총 3가지 경우입니다.
- 그런데 일기장 목록으로 되돌아가면 이미 show 되고 있는 키보드 또한 자동으로 hide되기 때문에 중복하여 메서드가 호출됩니다. 
- 이전에는 분기 처리를 통하여 해결하였는데, 이번에는 이 과정에서 서버와의 지연으로 인해 분기 처리가 정상적으로 이루어지지 않아 두 세번 저장 메서드가 호출되는 현상이 발생하였습니다.
- 이로 인한 중복 저장을 막기 위해서 `isFetching` 프로퍼티를 정의해서 현재 데이터를 받아오고 있는 중인지 아닌지 확인할 수 있도록 했습니다.
- 다만, 이렇게 확인하는 방식이 효율적인지에 대한 의문이 들어, 혹시 데이터가 현재 통신중인지 여부를 체크할 수 있는 더 좋은 방법이 있는지 알고 싶습니다. ☺️

- **기존 코드:**
```swift
WeatherImageAPIManager(icon: icon)?.requestImage(id: id) { [weak self] result in
    switch result {
    case .success(let image):
        do {
            try CoreDataManager.shared.saveDiary(
                title: title,
                body: body,
                createdAt: creationDate,
                id: id,
                main: main,
                icon: icon,
                image: image
            )
        } catch {
            self?.presentErrorAlert(error)
        }
    case .failure(let error):
        self?.presentErrorAlert(error)
    }
}
```

- **수정 코드:**
```swift
if isFetching == false {
    isFetching = true
    WeatherImageAPIManager(icon: icon)?.requestImage(id: id) { [weak self] result in
        switch result {
        case .success(let image):
            do {
                try CoreDataManager.shared.saveDiary(
                    title: title,
                    body: body,
                    createdAt: creationDate,
                    id: id,
                    main: main,
                    icon: icon,
                    image: image
                )
            } catch {
                self?.presentErrorAlert(error)
            }
        case .failure(let error):
            self?.presentErrorAlert(error)
        }
        self?.isFetching = false
    }
}
```
