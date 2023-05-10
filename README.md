# 일기장📝

## 프로젝트 소개
> 일기를 작성하고 리스트를 통해 작성한 일기를 볼 수 있는 어플리케이션
> 
> 프로젝트 기간: 2023.04.24 - 2023.05.13

## 목차 :book:


- [1. 팀원을 소개합니다 👀](#팀원을-소개합니다-) 
- [2. 파일트리 🌲](#file-tree-)
- [3. 타임라인 ⏰](#타임라인-) 
- [4. 실행 화면 🎬](#실행-화면-) 
- [5. 트러블슈팅 🚀](#트러블-슈팅-) 
- [6. 핵심경험 📌](#핵심경험-)
- [7. Reference 📑](#reference-) 

</br>

## 팀원을 소개합니다 👀

|<center>[Rhode](https://github.com/Rhode-park)</center> | <center> [무리](https://github.com/parkmuri)</center> | 
|--- | --- |
|<Img src = "https://i.imgur.com/XyDwGwe.jpg" width="300">|<Img src ="https://i.imgur.com/SqON3ag.jpg" width="300" height="300"/>|


</br>

## File Tree 🌲

```typescript
Diary
├── Entity+CoreDataClass.swift
├── Entity+CoreDataProperties.swift
├── Diary
│   ├── App
│   │   ├── AppDelegate.swift
│   │   └── SceneDelegate.swift
│   ├── Model
│   │   ├── Diary.swift
│   │   └── CoreDataManager.swift
│   ├── View
│   │   ├── LaunchScreen
│   │   └── DiaryListCell.swift
│   ├── Controller
│   │   ├── DiaryListViewController.swift
│   │   └── DetailDiaryViewController.swift
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
└── .swiftlint
```


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
    
</br>

## Reference 📑
- [🍎 Apple Developer 공식문서 - UITextView](https://developer.apple.com/documentation/uikit/uitextview)
- [🍎 Apple Developer 공식문서 - DateFormatter](https://developer.apple.com/documentation/foundation/dateformatter)
- [🍎 Apple Developer 공식문서 - NotificationCenter](https://developer.apple.com/documentation/foundation/notificationcenter)
- [🍎 Apple Developer 공식문서 - NSNotification-Name-UIKit](https://developer.apple.com/documentation/foundation/nsnotification/name#3875993)
- [🍎 Apple Developer 공식문서 - NsLayoutConstraint-constant](https://developer.apple.com/documentation/uikit/nslayoutconstraint/1526928-constant)
- [🍎 Apple Developer 공식문서 - CoreData](https://developer.apple.com/documentation/coredata)
