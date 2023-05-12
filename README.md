# 일기장 📕

> **소개: 코어데이터를 활용하여 일기장 앱을 만드는 프로젝트**

### 프로젝트 핵심 경험
- UITextView
- DateFormatter
- CoreData 구현 및 Migration 활용
- UITableView 스와이프를 통한 공유, 삭제 기능
- CoreLocation
- UISearchController


</br>

## 목차
1. [팀원](#1-팀원)
2. [타임라인](#2-타임라인)
3. [프로젝트 구조](#3-프로젝트-구조)
4. [실행화면](#4-실행-화면)
5. [트러블슈팅](#5-트러블-슈팅)
6. [팀회고](#6-팀회고)
7. [참고링크](#7-참고-링크)

<br>

## 1. 팀원

|[<img src="https://i.imgur.com/IOAJpzu.png" width="22"/> 레옹아범](https://github.com/fatherLeon)| [<img src="https://i.imgur.com/IOAJpzu.png" width="22"/> kaki](https://github.com/kak1x) |
| :--------: | :--------: |
|<img height="180px" src="https://raw.githubusercontent.com/Rhode-park/ios-rock-paper-scissors/step02/image/leonFather.jpeg">| <img height="180px" src="https://i.imgur.com/KkFB7j3.png"> |

<br>

## 2. 타임라인
#### 프로젝트 진행 기간 : 23.04.24 (월) ~ 23.05.12 (금)

| 날짜 | 타임라인 |
| --- | --- |
|23.04.24 (월)| 프로젝트 초기 세팅 및 컨벤션 합의, SwiftLint 적용 |
|23.04.25 (화)| DiaryViewController, DiaryInfoTableViewCell 구현 |
|23.04.26 (수)| DiaryDetailViewController 구현, 코드 컨벤션 수정 |
|23.04.27 (목)| 전체 코드 리팩토링 및 Keyboard 화면 가림 방지 로직 변경 |
|23.04.28 (금)| 코드 컨벤션 수정, README 작성 |
|23.05.01 (월)| DiaryDetailViewController 리팩토링 |
|23.05.02 (화)| CoreData CRUD 기능 구현 |
|23.05.03 (수)| 테이블 뷰 셀 스와이프 시 삭제, 공유 버튼 구현 및 <br> 백그라운드 상태 코어데이터 오류 수정 |
|23.05.04 (목)| 공유 버튼 클릭시 UIActivityView 구현 |
|23.05.05 (금)| 코드 리팩토링 및 README 작성 |
|23.05.08 (월)| CoreDataError를 통한 PersistentContainer 에러처리 |
|23.05.09 (화)| CoreData 마이그레이션, 사용자 위치설정 구현 |
|23.05.10 (수)| 네트워크 모델 구현, 코드 리팩토링 |
|23.05.11 (목)| 일기장 검색(UISearchController) 구현 |
|23.05.12 (금)| README작성, 코드리팩토링 |

<br>

## 3. 프로젝트 구조
#### **UML**
<img src="https://hackmd.io/_uploads/B1yWrwjE3.png">


#### **폴더구조**

``` swift
Diary
    ├── .swiftlint.yml
    ├── Model
    |    ├── Network
    |    │    ├── DiaryEndPoint
    |    │    ├── NetworkManager
    |    │    └── NetworkError
    |    ├── JsonDiary
    |    ├── DiaryState
    |    ├── PersistenceManager
    |    ├── CoreDataError
    |    └── WeatherData
    ├── View
    |    └── DiaryInfoTableViewCell
    ├── Controller
    |    ├── DiaryViewController
    |    └── DiaryDetailViewController
    ├── CoreData
    |    ├── Diary.xcdatamodeld
    |    │    ├── Diary 2
    |    │    └── Diary
    |    ├── MappingDiary.xcmappingmodel
    |    └── DiaryEntityMigrationPolicy
    ├── Etc
    |    ├── ReuseIdentifiable
    |    ├── ArrayExtension
    |    ├── DateExtension
    |    └── UIViewControllerExtention
    ├── AppDelegate
    ├── SceneDelegate
    ├── Assets
    ├── LaunchScreen
    └── Info
```

</br>

## 4. 실행 화면

|**일기장 초기 화면**|**기존 일기 조회 페이지**|**새로운 일기 작성 페이지**|
|:-----:|:-----:|:-----:|
| <img src = "https://i.imgur.com/8HiNqbM.png" width = "300">|<img src = "https://user-images.githubusercontent.com/51234397/236361609-32ebeb57-4364-49c7-ab22-f01163acb247.gif" width = "300"> |<img src = "https://user-images.githubusercontent.com/51234397/236361616-3a9cc476-c0ed-4cb3-9d3d-b35230397b67.gif" width = "300">|
|**새 일기 작성**|**일기 수정**|**일기 수정 후 Background 진입**|
| <img src = "https://user-images.githubusercontent.com/51234397/236361619-fc1d7bf2-db00-4cff-acd2-92c97b1073b0.gif" width = "300">|<img src = "https://user-images.githubusercontent.com/51234397/236361623-a173b84f-e6d8-4d6c-b174-291340f5417f.gif" width = "300"> |<img src = "https://user-images.githubusercontent.com/51234397/236361626-f5daf472-d861-49b9-9097-528b1f3d14ef.gif" width = "300">|
|**새 일기 작성 (날씨 아이콘 추가)**|**일기 검색**|
| <img src = "https://github.com/kak1x/ios-diary/assets/51234397/80540a40-8b7c-407d-87d6-d956e7fa34e5" width = "300">|<img src = "https://github.com/kak1x/ios-diary/assets/51234397/bc31ada7-90b0-4eee-b99e-542bc1aa427a" width = "300"> |

<br>

## 5. 트러블 슈팅

### 1️⃣ 편집중인 텍스트가 키보드에 의해 가려지는 문제

```swift
extension DiaryDetailViewController: UIViewController {
    private func setUpNotification() {
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(showKeyboard),
            name: UIResponder.keyboardWillShowNotification,
            object: nil
        )
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(hideKeyboard),
            name: UIResponder.keyboardWillHideNotification,
            object: nil
        )
    }
    
    @objc private func showKeyboard(_ notification: Notification) {
        guard let userInfo = notification.userInfo,
              var keyboardFrame = userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect else { return }
        
        keyboardFrame = view.convert(keyboardFrame, from: nil)
        var contentInset = textView.contentInset
        contentInset.bottom = keyboardFrame.size.height
        textView.contentInset = contentInset
        textView.scrollIndicatorInsets = textView.contentInset
    }
    
    @objc private func hideKeyboard(_ notification: Notification) {
        textView.contentInset = UIEdgeInsets.zero
        textView.scrollIndicatorInsets = textView.contentInset
    }
}
```

* 수정하고 싶은 텍스트 뷰 내용을 클릭할 경우 키보드에 의해 해당 내용이 가려지는 문제가 있었습니다.
* 이를 해결하기 위해 `UIResponder`의 Keyboard관련 `Notification`을 사용하여 키보드가 나타나고 사라질때 알림을 받아 처리하는 방식으로 구현하였습니다.
* 그러나, 코드의 길이가 길고 가독성을 해치는 부분이 많아 아래와 같이 구현하였습니다.

### ⚒️ 해결방법
```swift
NSLayoutConstraint.activate([
    diaryTextView.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor),
    diaryTextView.leadingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leadingAnchor),
    diaryTextView.trailingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.trailingAnchor),
    diaryTextView.bottomAnchor.constraint(equalTo: self.view.keyboardLayoutGuide.topAnchor)
])
```
- iOS 15 버전부터 지원하는 `keyboardLayoutGuide`를 사용하여 매우 간단하게 이를 구현할 수 있었습니다.
- 이를 사용하기 위해 프로젝트의 `Minimum Deployments`를 iOS 15.0로 설정해주었습니다.
- diaryTextView의 `bottomAnchor`를 `keyboardLayoutGuide.topAnchor`쪽에 constraint을 맞춰주는 것만으로 사용이 가능했습니다.


<br>

### 2️⃣ Heavyweight Migration

![](https://hackmd.io/_uploads/HJdYeUsNh.png)

- 기존에 Core Data에 존재하던 date Attribute의 타입을 Double에서 Date로 변경해줘야 했는데, Lightweight Migration만으로는 불가능하였습니다.

### ⚒️ 해결방법

```swift
class DiaryEntityMigrationPolicy: NSEntityMigrationPolicy {
    override func createDestinationInstances(forSource sInstance: NSManagedObject, in mapping: NSEntityMapping, manager: NSMigrationManager) throws {
        let destMOC = manager.destinationContext
        
        guard let destinationEntity = mapping.destinationEntityName else { return }
        
        guard let content = sInstance.value(forKey: "content"),
              let date = sInstance.value(forKey: "date") as? Double else { return }
        
        let context = NSEntityDescription.insertNewObject(forEntityName: destinationEntity, into: destMOC)
        
        context.setValue(content, forKey: "content")
        context.setValue(Date(timeIntervalSince1970: date), forKey: "date")
    }
}
```

- Diary를 매핑하는 과정에서 Attribute의 타입을 변경할 수 있도록 `NSEntityMigrationPolicy`의 `createDestinationInstances` 메서드를 재정의해주었습니다.

![](https://hackmd.io/_uploads/S1AeWLj4n.png)

- 이후 Entity Mapping의 `Custom Policy`를 새롭게 정의해준 `DiaryEntityMigrationPolicy`로 설정해주어 Heavyweight Migration을 진행할 수 있었습니다.

<br>

### 3️⃣ PersistentContainer 구현부

```swift
final class PersistenceManager {
    static var shared: PersistenceManager = PersistenceManager()
    
    private var container: NSPersistentContainer?
    
    private init() { }
    
    private func getContext(completion: @escaping (Result<NSManagedObjectContext, CoreDataError>) -> Void) {
        guard let container = self.container else {
            let container = NSPersistentContainer(name: "Diary")
            container.loadPersistentStores { _, error in
                guard error == nil else {
                    completion(.failure(.persistentLoadError))
                    return
                }
            }
            
            self.container = container
            completion(.success(container.viewContext))
            return
        }
        completion(.success(container.viewContext))
    }
}
```

- 기존에는 PersistenceManager를 Singleton 패턴으로 사용했기에 싱글톤 객체에 PersistenceContainer를 생성하여 공용으로 사용하고 있었습니다.
- 그러나, 싱글톤 패턴의 이점보다 의존성이 높아지고 테스트 하기 어려운 코드가 된다는 단점이 더 큰 것 같아 싱글톤을 해제해주게 되었습니다.
- 싱글톤이 아닌 필요한 곳에서 객체를 생성하여 사용하는 방식으로 변경하니 PersistenceContainer를 현재 방식으로 사용할 수 없게 되었습니다.

### ⚒️ 해결방법

```swift
struct PersistenceManager {
    private var context: NSManagedObjectContext?
    
    init() {
        self.context = getContext()
    }
    
    private func getContext() -> NSManagedObjectContext? {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return nil }
        
        return appDelegate.persistentContainer.viewContext
    }
}
```

- 새로 PersistenceContainer를 생성해주는 방식이 아닌, Core Data를 사용하게 되면 `AppDelegate`에 기본 구현되는 PersistenceContainer를 사용하는 방식으로 변경해주었습니다.
- 이를 통해 어떤 곳에서 PersistenceManger를 사용해주게 되어도 같은 PersistenceContainer를 사용할 수 있게 되었습니다.

<br>

### 4️⃣ UINavigationControllerDelegate 사용

```swift
override func viewWillDisappear(_ animated: Bool) {
    super.viewWillDisappear(animated)
    
    endEditingDiary()
}
```

- `viewWillDisappear`를 통해 화면이 disappear될 시 로직을 실행시키게 구현하였습니다.
- 지금은 뷰컨이 2개 밖에 없어서 현재와 같은 로직도 문제는 없지만, 뷰컨이 더 들어나게 될 경우 원치 않는 경우에도 해당 로직이 실행될 수 있을 것 같은 문제점이 보였습니다.

### ⚒️ 해결방법
```swift
extension DiaryDetailViewController: UINavigationControllerDelegate {
    func navigationController(_ navigationController: UINavigationController, willShow viewController: UIViewController, animated: Bool) {
        guard let diaryViewController = viewController as? DiaryViewController else { return }
        
        endEditingDiary()
        diaryViewController.fetchDiary()
    }
}
```

- `UINavigationControllerDelegate`의 `func navigationController(_ navigationController: UINavigationController, willShow viewController: UIViewController, animated: Bool)`를 사용하여 다음 보여질 뷰 컨트롤러가 `DiaryViewController`일 경우 현재 일기를 저장하고 다시 불러오는 작업을 구현하였습니다.

<br>

### 5️⃣ 코어데이터의 특정 데이터를 가져오기

- 코어데이터에서 특정 데이터를 조회하거나 가져올 때 사용할 수 있는 방법 중 하나는 `NSFetchRequest`를 통해 `NSPredicate`를 사용하는 방법입니다.
- 그러나 `NSPredicate`의 경우 `format`문법도 복잡하고 문자열을 길게 써야하는 단점이 있었습니다.

### ⚒️ 해결방법

```swift
struct PersistenceManager {
    func updateContent(at diary: Diary, _ content: String?, completion: @escaping (Result<Void, CoreDataError>) -> Void) {
        guard let context = context else { return }
        
        do {
            let item = try context.existingObject(with: diary.objectID)
            
            item.setValue(content, forKey: "content")
            
            try context.save()
            completion(.success(()))
        } catch {
            completion(.failure(.updateError))
        }
    }
}
```

- `NSManagedObejctContext`의 `existingObject`메서드를 사용하여 특정 데이터를 받아오도록 설정하였습니다.
- 기본적인 코어데이터 객체일 경우 Attribute뿐만 아니라 `NSManagedObjectID`를 가지고 있어 해당 ID를 토대로 특정 데이터를 가져오도록 구현하였습니다.

<br>

## 6. 팀회고
### 우리팀이 잘한 점
- 끝까지 모르는 부분에 대해서 해결하려고 노력하고 나름의 결론을 내린 점
- 오랜시간은 아니지만 매일매일 꾸준히 프로젝트를 진행한 점

### 우리팀이 노력할 점
- 조금 더 객체지향적인 코드를 작성해보자!
- 프로젝트가 종료된 이후에도 해결되지 않았던 문제에 대해서 고민하고 해결해보자 !

<br>

## 7. 참고 링크
- [Apple Docs - Core Data](https://developer.apple.com/documentation/coredata)
- [Apple Docs - Using Lightweight Migration](https://developer.apple.com/documentation/coredata/using_lightweight_migration)
- [Apple Docs - Heavyweight Migration](https://developer.apple.com/documentation/coredata/heavyweight_migration)
- [Apple - NSFetchRequest](https://developer.apple.com/documentation/coredata/nsfetchrequest)
- [Apple - UISearchController](https://developer.apple.com/documentation/uikit/uisearchcontroller)
- [Apple - performBatchUpdates](https://developer.apple.com/documentation/uikit/uicollectionview/1618045-performbatchupdates)
- [Apple - UIActivityViewController](https://developer.apple.com/documentation/uikit/uiactivityviewcontroller)
- [Apple - CoreLocation](https://developer.apple.com/documentation/corelocation)
- [Apple - UISwipeActionsConfiguration](https://developer.apple.com/documentation/uikit/uiswipeactionsconfiguration)
- [Apple - CLLocationManager](https://developer.apple.com/documentation/corelocation/cllocationmanager)
- [Apple - UINavigationControllerDelegate](https://developer.apple.com/documentation/uikit/uinavigationcontrollerdelegate)
---
