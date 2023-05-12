# 일기장📝

## 프로젝트 소개
> 일기를 작성하고 리스트를 통해 작성한 일기를 볼 수 있는 어플리케이션
> 
> 프로젝트 기간: 2023.04.24 - 2023.05.13

## 목차 :book:


- [1. 팀원을 소개합니다 👀](#팀원을-소개합니다-) 
- [2. 프로젝트 구조 🔍](#프로젝트-구조-)
- [3. 타임라인 ⏰](#타임라인-) 
- [4. 실행 화면 🎬](#실행-화면-) 
- [5. 트러블슈팅 🚀](#트러블-슈팅-) 
- [6. 핵심경험 📌](#핵심경험-)
- [7. 팀 회고 👯‍♀️](#팀-회고-)
- [8. Reference 📑](#reference-) 

</br>

## 팀원을 소개합니다 👀

|<center>[Rhode](https://github.com/Rhode-park)</center> | <center> [무리](https://github.com/parkmuri)</center> | 
|--- | --- |
|<Img src = "https://i.imgur.com/XyDwGwe.jpg" width="300">|<Img src ="https://i.imgur.com/SqON3ag.jpg" width="300" height="300"/>|


</br>

## 프로젝트 구조 🔍

### File Tree 🌲

```typescript
Diary
├── Entity+CoreDataClass.swift
├── Entity+CoreDataProperties.swift
├── Diary
│   ├── App
│   │   ├── AppDelegate.swift
│   │   └── SceneDelegate.swift
│   ├── Model
│   │   ├── DTO
│   │   │   └── WeatherInformation.swift
│   │   ├── Diary.swift
│   │   ├── CoreDataManager.swift
│   │   ├── LocationDataManager.swift
│   │   └── CacheManager.swift
│   ├── View
│   │   ├── LaunchScreen
│   │   └── DiaryListCell.swift
│   ├── Controller
│   │   ├── DiaryListViewController.swift
│   │   └── DetailDiaryViewController.swift
│   ├── Decode
│   │   ├── DecodeManager.swift
│   │   └── DecodeError.swift
│   ├── Network
│   │   ├── URLRequestMaker.swift
│   │   ├── NetworkManager.swift
│   │   └── NetworkError.swift
│   ├── Utility
│   │   └── ActionController.swift
│   ├── Resource
│   │   ├── Info
│   │   └── Assets
│   └── Extension
│       ├── Date+.swift
│       ├── Double+.swift
│       └── String+.swift
├── Diary
│       ├── Diary v2
│       └── Diary
└── .swiftlint
```

### UML 📊

![](https://hackmd.io/_uploads/ByL0CDo42.png)


</br>

## 타임라인 ⏰

|<center>날짜</center> | <center>타임라인</center> |
| --- | --- |
| **2023.04.24** | - 스토리보드 연결 해제 </br>- DiaryListViewController의 tableView, customCell 구현 </br>- Diary모델 및 Decoder 객체 구현  |
| **2023.04.25** | - SwiftLint 적용 </br> - DetailDiaryViewController구현 및 화면 전환 구현 </br>- NotificationCenter 이용하여 키보드 구현 </br> - NameSpace.swift파일 생성|
| **2023.04.26** | - DetailDiaryViewController에서 키보드 hide를 위한 변수 생성 </br> - textView레이아웃 로직 수정 |
| **2023.04.27** | - DetailDiaryViewController의 viewWillDisappear메서드 삭제 </br> - NSLayoutConstraint constant 활용하여 레이아웃 변경 적용 |
| **2023.04.28** | - NameSpace.swift파일 각 뷰컨트롤러에 private로 선언|
| **2023.05.01** | - CoreData entity 설정 </br>- DetailDiaryViewController configureDiary() 구현 </br>- CoreDataManager타입 생성, createDiary()및 fetchDiary() 구현 </br>- String Extenstion 생성 및 removeNewLinePrefix() 구현|
| **2023.05.02** | - CoreData deleteDiary()구현 </br>- 테이블에서 스와이프 및 삭제 구현 </br>- Entity에 id 프로퍼티 추가 </br>- DetailDiaryViewController updateDiary()구현 </br>- showActivieyVC() 구현 및 NotificationObserver 추가 |
| **2023.05.03** | - 일기 저장 로직 수정 </br>- CoreData delete로직 수정 및 DetailDiaryViewController에서 삭제기능 추가 </br>- 스와이프 로직 수정 </br>- ActionViewController 분리 </br>- DetailViewController에서 삭제 시 alert 구현 </br>- 키보드 레이아웃 로직 keyboardLayout으로 수정|
| **2023.05.04** | - ActivityViewController에서 다이어리 내용 전달할 수 있게 수정 </br>- 바번튼 아이템 수정 </br>- DetailDiaryViewController updateDiary() 로직 수정 </br>- 다이어리 저장 시 중복으로 저장되는 오류 처리|
| **2023.05.05** | - DiaryListViewController가 Diary 변수를 가지도록 수정</br>- 수정 중 저장기능 리팩토링|
| **2023.05.08** | - 에러처리 방법 변경 </br>- CoreDataManager 내부 반복 로직 메서드로 분리|
| **2023.05.09** | - Core Location 구현 및 Location Manager 생성 </br>- NetworkManger 구현 </br>- DecodeManager 구현</br>- CoreData Migration 및 로직 오류 해결|
| **2023.05.11** | - ActivityViewController에서 다이어리 내용 전달할 수 있게 수정 </br>- 바번튼 아이템 수정 </br>- DetailDiaryViewController updateDiary() 로직 수정 </br>- 다이어리 저장 시 중복으로 저장되는 오류 처리|
| **2023.05.12** | - URL 사용하여 ListCell에 날씨 아이콘 추가 및 오류 수정 </br>- Cache Manager 구현 및 아이콘 이미지 캐싱|

</br>

---
## 실행 화면 🎬
### 일기 저장
|<center>뒤로가기</center>|<center>키보드</center>|<center>백그라운드</center>|
| --- | --- | --- |
|<img src=https://i.imgur.com/S9qye9S.gif width=300>|<img src=https://i.imgur.com/8NDbF3j.gif width=300>|<img src=https://i.imgur.com/NolZGts.gif width=300>|
|유저가 일기를 작성 후 뒤로가기를 누르면 저장이 됩니다.|유저가 일기를 작성 후 키보드가 사라지면 저장이 됩니다.| 일기를 작성 중 백그라운드에 진입 시 저장이 됩니다. |

## 일기 수정
|<center>뒤로가기</center>|<center>키보드</center>|<center>백그라운드</center>|
| --- | --- | --- |
|<img src=https://i.imgur.com/r1E6ygT.gif width=300>|<img src=https://i.imgur.com/gtTi9U6.gif width=300>|<img src=https://i.imgur.com/z09m3bS.gif width=300>|
|유저가 일기를 수정 후 뒤로가기를 누르면 내용이 수정 됩니다.|유저가 일기를 수정 후 키보드가 사라지면 내용이 수정 됩니다.| 일기 수정 중 백그라운드에 진입 시 내용이 수정 됩니다. |

## 일기 삭제
|<center>스와이프</center>|<center> 더보기 </center>|
| --- | --- |
|<img src=https://i.imgur.com/Z6cbjH9.gif width=300>|<img src=https://i.imgur.com/WrReSrm.gif width=300>|
|일기 리스트에서 스와이프 시 선택된 일기 삭제가 가능합니다.|일기 페이지에서 삭제 시 알럿창을 띄워 삭제할 수 있습니다.| 

## 일기 공유

|<center>스와이프</center>|<center> 더보기 </center>|
| --- | --- |
|<img src=https://i.imgur.com/atSpHIj.gif width=300>|<img src=https://i.imgur.com/b1l2s1b.gif width=300>|

## 예외 처리 - 일기의 내용이 없을 때 
|<center>생성 화면</center>|<center>수정 화면</center>|
| --- | --- |
|<img src=https://i.imgur.com/1kl70hn.gif width=300>|<img src=https://i.imgur.com/FKQ1aVk.gif width=300>|



## 날씨 아이콘 추가 후 CRUD
|<center>Create</center>|<center>Read&Update</center>|<center>Delete</center>
|---|---|---|
|<img src=https://hackmd.io/_uploads/B17zePs43.gif width=300>|<img src=https://hackmd.io/_uploads/rkmGewjVn.gif width=300>|<img src=https://hackmd.io/_uploads/S1QflviV2.gif width=300>

## 날씨 아이콘 이미지 캐싱

|<center>이미지 캐싱 전</center>|<center>이미지 캐싱 후</center>|
|---|---|
|<img src=https://hackmd.io/_uploads/r1HtWwiNn.gif width=300>|<img src=https://hackmd.io/_uploads/HkvIe_sEh.gif width=300>|

---


</br>

## 트러블 슈팅 🚀
### 1️⃣ 키보드가 나오고 들어갈 때 view의 constraint 변경하기
일기를 작성하거나 수정하기 위해 일기의 내용을 터치하면 키보드가 나와서 입력이 가능하도록 구현해야 했습니다. 하지만 키보드가 올라와도 `TextView`의 `bottomAnchor`는 이미 `view.safeAreaLayoutGuide.bottomAnchor`로 제약이 걸려있는 상황이었기 때문에 아래쪽에 있는 내용은 키보드에 가려지게 되었습니다. 
이를 해결하기 위해 키보드가 올라왔을때, `TextView`의 `bottomAnchor`를 키보드의 높이만큼 빼주어 작아진 뷰를 가지게 하고싶었습니다. 
**수정 전**
```swift
// DetailDiaryViewController.swfit
private var bottomConstraint: NSLayoutConstraint?

private func configureConstraint() {
    bottomConstraint = diaryTextView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
    bottomConstraint?.isActive = true
// ...
}

@objc
private func keyboardWillShow(notification: NSNotification) {
    // ...
        UIView.animate(withDuration: 5) {
            self.bottomConstraint?.isActive = false
            self.bottomConstraint = self.diaryTextView.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor, 
                                                                               constant: -changedHeight)
            self.bottomConstraint?.isActive = true
        }
    // ...
}

@objc
private func keyboardWillHide(notification: NSNotification) {
    UIView.animate(withDuration: 5) {
        self.bottomConstraint?.isActive = false
        self.bottomConstraint = self.diaryTextView.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor)
        self.bottomConstraint?.isActive = true
    }
}
```
위의 코드와 같이 작성했을 때, isActive의 반복되는 코드로 가독성이 매우 좋지않아보였습니다. 

**수정 후**
`NSLayoutConstraint`의 `constant`프로퍼티를 알게되어 위의 코드에 적용시켜보았습니다.
```swift
// DetailDiaryViewController.swift
private func configureConstraint() {
    bottomConstraint = diaryTextView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
    bottomConstraint?.isActive = true
    // ...
}

@objc
private func keyboardWillShow(notification: NSNotification) {
    if let keyboardFrame: NSValue =
        notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue,
       let firstWindow = UIApplication.shared.windows.first {
        // ...
        let changedHeight = -(keyboardHeight - firstWindow.safeAreaInsets.bottom)
        bottomConstraint?.constant = changedHeight
    }
}

@objc
private func keyboardWillHide(notification: NSNotification) {
    bottomConstraint?.constant = 0
}        
```
필요하지 않은 코드가 삭제되어 한결 더 가독성이 좋은 코드가 되었습니다.

</br>

### 2️⃣ 사용자가 키보드를 내릴 때 텍스트뷰의 레이아웃
현재 트러블슈팅 1️⃣에서는 **키보드가 올라왔을 때** 텍스트 뷰의 크기를 동적으로 줄여 사용하고있었습니다. `⌘+k`를 이용하여 키보드를 없앨 때는 느끼지 못했던 부분인 **사용자가 키보드를 내릴 때**의 텍스트 뷰 레이아웃이 어색하게 느껴졌습니다.
<img src=https://i.imgur.com/PfWmHP8.gif width=300>

이를 해결하기 위해 **iOS 15.0+** 부터 사용 가능한  `keyboardLayoutGuide`를 사용해주었습니다.
트러블슈팅 1️⃣에서 사용한 전역변수와 NotificationObserver도 사용하지 않아 더 간결한 코드가 되었습니다.
```swift
private func configureConstraint() {
    NSLayoutConstraint.activate([
        // ... 
         diaryTextView.bottomAnchor.constraint(equalTo: view.keyboardLayoutGuide.topAnchor)
    ])
}
```


### 3️⃣ 네비게이션바버튼 아이템의 수정
**수정 전**
navigation의 barButtonItem에 custom한 이미지를 넣는 방법에 대해 고민하다가 버튼자체를 넣어주는 방법을 사용하게 되었습니다.
```swift!
// DetailDiaryViewController.swift
    private let detailButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(systemName: "ellipsis"), for: .normal)

        return button
    }()
// ...
    private func configureUI() {
        // ...
        detailButton.addTarget(self, action: #selector(showDetailAction), for: .touchUpInside)
        let detailDiaryButton = UIBarButtonItem(customView: detailButton)
        navigationItem.rightBarButtonItem = detailDiaryButton
        // ...
```

**수정 후**
barButtonItem의 image를 UIImage에 넣어 사용하는 방법으로 한결 간단한 코드로 사용할 수 있게 되었습니다.
```swift
    private func configureNavigationBar() {
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "ellipsis.circle"),
                                                            style: .plain,
                                                            target: self,
                                                            action: #selector(showDetailAction))
    }
```
<br/>

### 4️⃣ 저장 로직의 수정
일기는 다음과 같은 상황에서 저장이 되어야합니다:
1. 일기장 화면에서 빠져나갈 때
2. 키보드가 내려갈 때
3. 백그라운드로 들어갈 때

그래서 각각의 상황에 `saveDiary()`메서드를 넣어주었습니다:
```swift
@objc
final class DetailDiaryViewController: UIViewController {
    
    ...
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        saveDiary()
    }
    
    ...
    
        @objc
    private func enterTaskSwitcher() {
        saveDiary()
    }
    
    ...
}

extension DetailDiaryViewController: UITextViewDelegate {
    func textViewDidEndEditing(_ textView: UITextView) {
        saveDiary()
    }
}
```


그런데, 아무런 분기처리를 해주지 않아 일기장이 중복으로 저장되곤 했습니다. 중복으로 저장이 되는 상황을 방지하기 위해서 `isSaveRequired`라는 Bool타입의 프로퍼티를 만들어 분기처리를 해주었습니다:
```swift
private func saveDiary() {
    if isSaveRequired {
        if isDiaryCreated {
            createDiary()
        } else {
            updateDiary()
        }
        
        isSaveRequired = false
    }
}
```
`isSaveRequired`는 `DiaryListViewController`에서 `addDiary()`를 해줄 때 혹은 테이블뷰의 셀을 선택할 때, true로 초기화됩니다. 그래서 이 때는 `if isSaveRequired`를 타고 들어가 `createDiary()`혹은 `updateDiary()`가 호출됩니다. 그렇지만, 나머지 상황에서는 `isSaveRequired`가 false이기 때문에 일기가 저장되거나 수정되지 않습니다. 

### 5️⃣ DiaryListVC의 `.reloadData()`의 호출 순서 오류
로직 수정 중, DiaryListViewController의 `viewWillAppear()` 내부에서 사용하고있는 `diaryTableView.reloadData()`가 제대로 작동하지 않은 오류가 있었습니다. 
확인 결과 사용하고있던 escaping closure가 뷰컨트롤러의 전환 후 작동하여 나타났던 오류로, 일기장 작성 페이지에서 뒤로가기 시 저장이 되는 로직을 가지고 있었기 때문에 화면전환 시 불리우는 CoreDataManager의 `saveContext()` 메서드에 Notification의 post기능을 이용하여 해결할 수 있었습니다.
```swift!
// CoreDataManager.swift
private func saveContext() {
    do {
        try self.context.save()
        NotificationCenter.default.post(name: .init("reload"), object: nil)
    } catch {
        print(error.localizedDescription)
    }
}
```
```swift
// DiaryListViewController.swift
private func addObserver() {
    NotificationCenter.default.addObserver(forName: .init("reload"),
                                           object: nil,
                                           queue: .main) { _ in
        self.diaryListTableView.reloadData()
        self.diaryListTableView.layoutIfNeeded()
    }
}
```


<br/>


## 핵심 경험 📌
<details>
<summary><big>✅ TextView의 활용 </big></summary>

TextView를 사용하여 view에 일기장 내용을 띄우면서도 그 내용을 수정할 수 있게 하였습니다. 
    
```swift
private let diaryTextView: UITextView = {
    let textView = UITextView()
    textView.font = UIFont.preferredFont(forTextStyle: .body)
    textView.adjustsFontForContentSizeCategory = true
    textView.translatesAutoresizingMaskIntoConstraints = false
    textView.text = NameSpace.diaryPlaceholder
    
    return textView
}()
```


</details>

<details>
<summary><big>✅ DateFormatter의 활용 </big></summary>

Date에 extension을 두어 원하는 형식으로 날짜를 변형시켜주었습니다. 
    
```swift
extension Date {
    func convertDate() -> String {
        let dateFormatter = DateFormatter()
        
        dateFormatter.dateFormat = "yyyy년 MM월 dd일"
        
        let convertedDate = dateFormatter.string(from: self)
        
        return convertedDate
    }
}
```
    
</details>

<details>
<summary><big>✅ CoreData의 활용 </big></summary>

CoreData를 사용하기 위해 CoreDataManager를 만들어주고 CoreData를 관리하는 메서드들을 구현해주었습니다. 메서드는 CRUD의 순서로 배치해주었습니다. 

```swift
import CoreData
import Foundation

class CoreDataManager {
    static var shared: CoreDataManager = CoreDataManager()
    
    lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "Diary")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        
        return container
    }()
    
    var context: NSManagedObjectContext {
        return persistentContainer.viewContext
    }
    
    var diaryEntity: NSEntityDescription? {
        return  NSEntityDescription.entity(forEntityName: "Entity", in: context)
    }
    
    func createDiary(_ diary: Diary) {
        if let entity = diaryEntity {
            let managedObject = NSManagedObject(entity: entity, insertInto: context)
            managedObject.setValue(diary.id, forKey: "id")
            managedObject.setValue(diary.title, forKey: "title")
            managedObject.setValue(diary.body, forKey: "body")
            managedObject.setValue(diary.date, forKey: "date")
            
            do {
                try self.context.save()
            } catch {
                print(error.localizedDescription)
            }
        }
    }
    
    func readDiary() -> [Diary]? {
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "Entity")
        var diaries = [Diary]()
        
        guard let diaryData = try? context.fetch(fetchRequest) else { return nil }
        
        for diary in diaryData {
            guard let id = diary.value(forKey: "id") as? UUID,
                  let title = diary.value(forKey: "title") as? String,
                  let body = diary.value(forKey: "body") as? String,
                  let date = diary.value(forKey: "date") as? Double else { return nil }
            
            diaries.append(Diary(id: id, title: title, body: body, date: date))
        }
        
        return diaries
    }
    
    func updateDiary(diary: Diary) {
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "Entity")
        fetchRequest.predicate = NSPredicate(format: "id == %@", diary.id as CVarArg)
        
        do {
            let objects = try context.fetch(fetchRequest)
            let objectToUpdate = objects[0]
            
            objectToUpdate.setValue(diary.title, forKey: "title")
            objectToUpdate.setValue(diary.body, forKey: "body")
            objectToUpdate.setValue(diary.date, forKey: "date")
            
            do {
                try self.context.save()
            } catch {
                print(error.localizedDescription)
            }
        } catch {
            print(error.localizedDescription)
        }
    }
    
    func deleteDiary(diary: Diary) {
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "Entity")
        fetchRequest.predicate = NSPredicate(format: "id == %@", diary.id as CVarArg)
        
        do {
            let objects = try context.fetch(fetchRequest)
            let objectToDelete = objects[0]
            context.delete(objectToDelete)
            
            do {
                try context.save()
            } catch {
                print(error.localizedDescription)
            }
        } catch {
            print(error.localizedDescription)
        }
    }
}

```

</details>
    
<details>
<summary><big>✅ ActivityViewController의 활용 </big></summary>

일기장을 공유하기 위해 ActivitiyViewController를 사용해보았습니다.
현재 일기장을 공유할 수 있는 기능은 두 곳에서 사용하고 있기 때문에, 중복되는 코드의 사용을 막기 위하여 따로 파일을 분리해 사용해주었습니다. 
    
```swift
enum ActionController {
    static func showActivityViewController(from viewController: UIViewController,
                                           title: String, body: String) {
        let activityItems = [title, body]
        let activityViewController = UIActivityViewController(activityItems: activityItems,
                                                              applicationActivities: nil)
        
        activityViewController.popoverPresentationController?.sourceView = viewController.view
        
        viewController.present(activityViewController, animated: true, completion: nil)
    }
}
```

</details>
    
<details>
<summary><big>✅ Core Location 활용 </big></summary>
    
일기를 저장하는 장소에서의 현재 날씨를 구하기 위해, Core Location을 활용하여 해당 지역의 위/경도를 구할 수 있었습니다. 
    
```swift 
// LocationDataManager.swift
final class LocationDataManager: NSObject {
    static let shared = LocationDataManager()
    private var locationManager = CLLocationManager()

    var latitude: CLLocationDegrees?
    var longitude: CLLocationDegrees?

    private override init() {
        super.init()

        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyHundredMeters
        locationManager.requestWhenInUseAuthorization()
    }

    func fetchLocation() -> (latitude: CLLocationDegrees, longitude: CLLocationDegrees)? {
        guard let latitude,
              let longitude else { return nil }

        return (latitude: latitude, longitude: longitude)
    }
}
    
extension LocationDataManager: CLLocationManagerDelegate {
    // 권한설정 메서드 등
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.last else { return }

        latitude = location.coordinate.latitude
        longitude = location.coordinate.longitude
    }
}
```
    
</details>
    
<details>
<summary><big>✅ Core Data Lightweight Migration</big></summary>
OpenWeather API에서 받아오는 날씨의 icon값을 저장하기 위해 Core Data의 Migration을 할 필요가 있었습니다. 
CoreData에서 `Add Model Version`을 하여 새로운 버전을 관리 해 주었습니다. 그 후 `Create NSManagedObject Subclass`하여 수정 내용을 반영해준 후 실행하여 마이그레이션을 해볼 수 있었습니다.
    
```swift
import Foundation
import CoreData

extension Entity {
    @nonobjc public class func fetchRequest() -> NSFetchRequest<Entity> {
        return NSFetchRequest<Entity>(entityName: "Entity")
    }

    @NSManaged public var body: String?
    @NSManaged public var date: Double
    @NSManaged public var id: UUID?
    @NSManaged public var title: String?
    @NSManaged public var iconName: String?
}
// ...
    
```
    
</details>
        
    
</br>
    
## 팀 회고 👯‍♀️
    
### 우리팀이 잘한 점
- 리뷰가 오기 전에 각자 집중해서 공부할 수 있는 시간을 가졌던 점이 참 좋았습니다.
- 그라운드 룰에 적어놓은 시간약속을 잘 지켰어요!
    
### 우리 팀의 아쉬웠던 점
- 프로젝트 후반부에 체력적으로 많이 지쳤던 것 같아요...😭
- 자잘한 실수 큰 오류...😅

### 팀원 서로 칭찬하기
#### 무리 -> 로데
로데의 넓은 지식...! 멋져요. 로데 덕분에 새로운 메서드, 컨벤션 등 많이 알아갑니다! 오류를 만났을때도 이런저런 방법으로 시도해보시는 점 너무 멋있었습니다! 공식문서와 가까우신 점, 코드짜실 때 일관성있는 점도 꼭 배우고싶은 부분입니다. 로데는 정말 어디가서든지 적응 잘하실것같아요🥹 로데 최고입니다!!!

#### 로데 -> 무리
무리는 유연한 사고와 꼼꼼함을 두루 갖추고 있는 정육각형 개발자입니다. 늘 성실하면서도 생각이나 일정을 계획하는데에 있어서 유연함을 가지고 있어서 배울 점이 많습니다. 체력 안배도 잘 하시는 편인지 후반부에 체력적으로 많이 지쳤음에도 프로젝트를 이끌어나갈 힘이 있으신 것 같았습니다. 모든 점을 균형있게 잘 하시는 것이 무리의 가장 큰 장점이라고 볼 수 있을 것 같습니다.

    
</br>
## Reference 📑
[🍎 Apple Developer 공식문서 - UITextView ](https://developer.apple.com/documentation/uikit/uitextview)
[🍎 Apple Developer 공식문서 - DateFormatter ](https://developer.apple.com/documentation/foundation/dateformatter)
[🍎 Apple Developer 공식문서 - NotificationCenter ](https://developer.apple.com/documentation/foundation/notificationcenter)
[🍎 Apple Developer 공식문서 - NSNotification-Name-UIKit ](https://developer.apple.com/documentation/foundation/nsnotification/name#3875993)
[🍎 Apple Developer 공식문서 - NsLayoutConstraint-constant ](https://developer.apple.com/documentation/uikit/nslayoutconstraint/1526928-constant)
[🍎 Apple Developer 공식문서 - Core Data](https://developer.apple.com/documentation/coredata)
[🍎 Apple Developer 공식문서 - Core Location](https://developer.apple.com/documentation/corelocation)
[🍎 Apple Developer 공식문서 - Configuring your app to use location services](https://developer.apple.com/documentation/corelocation/configuring_your_app_to_use_location_services)
[🍎 Apple Developer 공식문서 - Getting the current location of a device](https://developer.apple.com/documentation/corelocation/getting_the_current_location_of_a_device)
[🍎 Apple Developer 공식문서 - Requesting authorization to use location services](https://developer.apple.com/documentation/corelocation/requesting_authorization_to_use_location_services)
[🍎 Apple Developer 공식문서 - Using Lightweight Migration](https://developer.apple.com/documentation/coredata/using_lightweight_migration)
[🌤️ OpenWeatherAPI](https://openweathermap.org/current#multi)

