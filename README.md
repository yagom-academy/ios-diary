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
    
> 2022.08.16 ~ 2022.08.17
    
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

    
## 🤔 핵심경험

- [x] Date Formatter의 지역 및 길이별 표현의 활용
- [x] Text View의 활용
- [x] 코어데이터 모델 생성
- [x] 코어데이터 모델 및 DB 마이그레이션
- [x] 테이블뷰에서 스와이프를 통한 삭제기능 구현

## 🗂 폴더 구조

```
.
├── Diary
│   ├── Controllers
│   │   ├── DiaryContentsViewController.swift
│   │   └── DiaryListViewController.swift
│   ├── CoreData
│   │   ├── Diary+CoreDataClass.swift
│   │   └── Diary+CoreDataProperties.swift
│   ├── Error
│   │   ├── FetchingError.swift
│   │   └── ParsingError.swift
│   ├── Extension
│   │   ├── Date+Extension.swift
│   │   ├── Int+Extension.swift
│   │   └── UIViewController+Extension.swift
│   ├── Models
│   │   ├── CoreDataManager.swift
│   │   ├── DiarySampleData.swift
│   │   └── JSONData.swift
│   ├── Namespaces
│   │   ├── ActionSheet.swift
│   │   ├── Alert.swift
│   │   ├── AssetData.swift
│   │   ├── DiaryCoreData.swift
│   │   ├── NavigationItem.swift
│   │   ├── NewLine.swift
│   │   ├── SearchControllerItem.swift
│   │   └── SystemImage.swift
│   ├── Resources
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
│   │   ├── Diary.xcdatamodeld
│   │   │   └── Diary.xcdatamodel
│   │   │       └── contents
│   │   ├── Info.plist
│   │   └── SceneDelegate.swift
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
    
#### Q3. 튜플 조건문 가독성 향상 고민 

- `fetchSuccess` 상수의 경우, 해당 일기가 이미 일전에 작성한 일기인지 확인하기 위한 Diary 타입의 값이고, `isDeleted` 변수의 경우 액션시트를 통해 삭제 기능이 요청되어 있는지 판단하기 위한 `Bool` 값입니다. 처음에는 이를 `guard`를 통해 분기를 하려고 했지만, `else` 케이스 안에 또 `guard`문을 필요로하여, `switch`문을 이용하면 분기를 좀 더 간결하게 표현할 수 있었습니다.
    
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
