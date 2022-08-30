# 📔 일기장

## 🪧 목차
- [📜 프로젝트 소개](#-프로젝트-소개)
- [🧑🏻‍💻🧑🏻‍💻 개발자 소개](#-개발자-소개)
- [📱 실행 화면](#-실행-화면)
- [💡 핵심경험](#-핵심경험)
- [🧑‍💻 코드 설명](#-코드-설명)
- [⚡️ 트러블 슈팅](#%EF%B8%8F-step-1-트러블-슈팅)
- [⚡️ 트러블 슈팅](#%EF%B8%8F-step-2-트러블-슈팅)
- [🔗 참고 링크](#-참고-링크)

<br>

## 📜 프로젝트 소개
내가 쓴 일기를 저장하고 수정, 삭제할 수 있는 일기장입니다. 

> 프로젝트 기간: 2022-08-16 ~ 2022-09-02</br>
> 팀원:  [주디](https://github.com/Judy-999), [백곰](https://github.com/Baek-Gom-95) </br>
리뷰어: [찰리](https://github.com/kcharliek)</br>

<br>

## 🧑🏻‍💻🧑🏻‍💻 개발자 소개

|[주디](https://github.com/Judy-999)|[백곰](https://github.com/Baek-Gom-95)|
|:---:|:---:|
|<img src = "https://i.imgur.com/SdlGVLc.jpg" width="250" height="250"> | <img src = "https://i.imgur.com/c17eEk8.jpg" width="250" height="250"> |
	
<br>
	
## 📱 실행 화면
| 일기장 목록 화면 |+ 버튼 터치 시 추가화면으로 이동 | 글자 입력 및 키보드에 따른 텍스트뷰 변화 |
| :--------: | :--------: | :--------: |
| ![](https://i.imgur.com/yTb46gz.gif) |![](https://i.imgur.com/pQ2J1J0.gif)| ![](https://i.imgur.com/PcdFBvV.gif)|

| 일기장 생성 | 일기장 편집 | 비어있는 경우 알림 |
| :--------: | :--------: | :--------: |
| ![](https://i.imgur.com/s97AIrp.gif) |![](https://i.imgur.com/dOyAx8r.gif)| ![](https://i.imgur.com/i1eBMgg.gif)|
| 자동으로 커서 세팅 및 키보드 올라옴 | 내용을 터치하면 편집 가능 | 제목 또는 내용이 비어있는 상태로 되돌아갈 때 얼럿 |

| 스와이프로 삭제 및 공유 | 더보기 버튼으로 삭제 | 백그라운드 자동저장 |
| :--------: | :--------: | :--------: |
| ![](https://i.imgur.com/nKyrKlU.gif) |![](https://i.imgur.com/YxZO1KM.gif)| ![](https://i.imgur.com/RisAp7b.gif)|

<br>

## 💡 핵심경험
- [x] Date Formatter
- [x] Text View
- [x] CoreData
- [x] CoreData Model 및 DB Migration
- [x] TableView Swipe
- [x] Text View Delegate
- [x] Open API
- [x] Core Location

<br>
	
## 🧑‍💻 코드 설명
- `DiaryDataManager`: CoreDataFramwork의 기능을 사용하는 코드입니다
- `JSONParser`: JSON 타입의 데이터를 Parsing 합니다.
- `JSONError`: Parsing 도중에 일어날수있는 에러타입을 정리했습니다.
- `DiaryItem`: CoreData에 저장될 데이터의 모델 입니다.
- `ReuseIdentifying`: Cell의 이름을 Identifier로 가지게 합니다.
- `DateManager`: 날짜를 나타내는 데이터를 원하는 날짜포맷으로 변경합니다.
- `DiaryListCell`: 일기장 리스트 화면의 Cell을 구현합니다.
- `ManageDiaryView`: 일기장 생성 및 편집 뷰를 구현합니다
- `DiaryTableViewController`: 일기장 리스트 뷰를 관리하는 컨트롤러 입니다.
- `ManageDiaryViewController`: 일기장 생성 및 편집 뷰를 관리하는 컨트롤러 입니다.
- `CoreDataFramework`: CoreData의 CRUD기능을 가지고있는 프레임워크 입니다.


<br><br>

## ⚡️ Step 1 트러블 슈팅 

### 1. UITextField에 padding 구현
새로운 일기장을 생성하는 화면에서 제목을 `UITextField`로 두고, 본문을 `UITextView`로 구현했습니다. 하지만 `UITextField`와 `UITextView`의 글 시작지점이 차이가 있어 맞춰주고자 했습니다.

처음에 `UITextView`의 `contentInset`을 변경하는 방식을 해봤는데 별다른 변화가 없어 `UITextField` extension하여 padding을 추가하는 `addLeftPadding`메서드를 구현했습니다.
<br>

| **padding을 넣지 않았을 때** |  **padding을 넣은 후** | 
| :--------: | :--------: |  
| <img src="https://i.imgur.com/Sh6UCwN.png" width="400" height="200" />    |<img src="https://i.imgur.com/i6nwlVu.png" width="400" height="200" /> |

<br>

```swift
extension UITextField {
    func addLeftPadding() {
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: 5, height: self.frame.height))
        self.leftView = paddingView
        self.leftViewMode = ViewMode.always
      }
}
```
<br>

하지만 리뷰어이신 찰리가 `leftView`는 padding을 넣기 위한 공간이 아니고, 만일 나중에 악세서리를 추가하게 되면 문제가 될 수 있어 다른 방법을 추천해주셨습니다.
<br>

```swift
class TextField: UITextField {
    let padding = UIEdgeInsets(top: 0, left: 5, bottom: 0, right: 0)

    override open func textRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: padding)
    }

    override open func placeholderRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: padding)
    }

    override open func editingRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: padding)
    }
}
```
<br>
`UITextField`을 상속하는 커스텀 텍스트필드를 만들어 padding을 넣는 방식으로 변경했습니다. 

하지만 이후에 텍스트필드 자체가 필요하지 않다고 판단되어 삭제했습니다. 🥲
<br>

### 2. SwiftLint 라이브러리
**SwiftLint** 라이브러리를 활용하여 코드 스타일을 일관성있게 유지했습니다. 
<br>

```swift
excluded:
    - Pods
    - Diary/Application/AppDelegate.swift
    - Diary/Application/SceneDelegate.swift
disabled_rules:
    - trailing_whitespace
    - line_length
```
<br>

`Pods`, `AppDelegate`, `SceneDelegate` 파일은 검사 대상에서 제외하고 **trailing_whitespace**와 **line_length** 규칙만 제외하도록 했습니다.

라이브러리를 CocoaPods로 받았는데 서로 Push-Pull 할 때마다 `pod install` 해야한다는 에러가 발생했습니다.  
<br>

![](https://i.imgur.com/omAPjwj.png)
<br>

각자 `pod install`을 하면 문제는 해결되었지만 매번 해주기 번거로워 살펴보니 팀원간의 CocoaPods 버전이 달라 발생한 문제였습니다.
서로 CocoaPods 버전을 확인하여 더 낮은 팀원의 버전을 업데이트 해서 해결했습니다!
<br>

### 3. 화면전환 방식 
ViewController를 스토리보드에 구현해서 `storyboard?.instantiateViewController` 방식으로 화면을 전환했지만 찰리가 Storyboard를 사용한다면 Segue로 하는 것이 VC간 관계를 표현하기 좋다고 하셔서 팀회의를 한 결과 Segue로 하는것이 VC간의 데이터 전달 및 여러가지 방면에서 유용하다고 판단해 변경하였습니다.
<br><br>

## ⚡️ Step 2 트러블 슈팅 

### 1. 테이블 뷰 셀 삭제 시 에러
```swift
func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
    if editingStyle == .delete {
        CoreDataManager.shared.deleteDiary(id: diaryItems[indexPath.row].id)
        fetchData()
        diaryListTableView.deleteRows(at: [indexPath], with: .fade)
    }
}
```
처음에 테이블 뷰에서 셀을 삭제하는 기능으로 `EditingStyle`가 `delete`일 때 삭제하는 방법으로 구현했습니다.
<br>

```swift
diaryListTableView.deleteRows(at: [indexPath], with: .fade)
fetchData()
```
테이블 뷰에서 셀을 삭제하는 `deleteRows`를 한 후 데이터를 불러오는 `fetchData()`를 실행하니 아래와 같은 에러가 발생했습니다.
<br>

![](https://i.imgur.com/AP5VQbP.png)
<br>

셀을 삭제하고 나서 데이터를 다시 불러오는 것이 왜 문제가 됐는지 알 수 없었습니다. 하지만 에러를 잘 읽어보니 1개의 셀이 삭제되었는데 데이터에서는 삭제가 되지 않아 셀을 설정하는 과정에서 충돌을 일으킨 것이었습니다.

`fetchData()`로 선택한 셀을 삭제한 데이터를 불러온 후 테이블 뷰에서 삭제하는 코드 순서로 진행했더니 해결되었습니다!
<br>


### 2. 셀 스와이프 시 액션 추가
테이블 뷰에서 셀을 삭제하는 방법은 아래 함수에서 `EditingStyle`이 `delete`일 때 삭제하는 기능을 구현하면 자동으로 스와이프 기능이 생겼습니다. 하지만 요구사항에서는 삭제와 함께 공유를 선택할 수 있어야 했는데 해당 방법으로는 스와이프 시 동작할 작업을 추가할 수 없었습니다.

찾아본 결과 `UITableViewDelegate`에서 제공하는 아래 메서드를 통해 스와이프 작업을 추가할 수 있었습니다. 
<br>

- `tableView(_:leadingSwipeActionsConfigurationForRowAt:)`
: 오른쪽으로 스와이프 시 수행할 작업 추가(행의 왼쪽에 나타남)
- `tableView(_:trailingSwipeActionsConfigurationForRowAt:)`
: 왼쪽으로 스와이프 시 수행할 작업 추가(행의 오른쪽에 나타남)
<br>

아래 함수에서 `UIContextualAction`을 생성한 후`UISwipeActionsConfiguration(actions: [deleteAction, shareAction])`를 반환해 스와이프 시 여러 기능이 나올 수 있도록 했습니다.
<br>

```swift
 func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? { ... }
```
<br>

`UIContextualAction`의 `style`을 `normal` 또는 `destructive`로 설정할 수 있었는데 `destructive`로 설정하면 끝까지 스와이프를 하면 가장 끝에 있는 기능이 실행되었습니다. 스와이프 시 두 가지 기능이 있기 때문에 끝까지 스와이프 할 수 없도록 `normal`로 설정했습니다.
<br>

### 3. 내용에 개행 포함 시 셀에 표시하기
일기장의 첫 줄을 제목이 되고 나머지는 내용이 됩니다. 하지만 첫 줄이라는 의미가 정해져있지 않아 저희는 개행을 했을 때 즉 처음으로 `"\n"`가 나오기 전까지를 제목으로 지정했습니다.

하지만 사용자가 제목 다음에 여러 번 개행을 했을 경우 내용 초반에 개행도 함께 저장되어 셀에 일기장 내용(body)이 보이지 않는 문제가 있었습니다. 제목 이후에 한 번만 개행을 하도록 제한을 둘까 했지만 일기 내용에 제한을 두는 것보다 사용자가 몇 번 개행을 했어도 내용이 표시되도록 하는 것이 좋겠다고 생각했습니다.
<br>

```swift
// DiaryListCell.swift
func configure(with data: DiaryItem) {
    let body = data.body
    var nextIndex = body.startIndex
    
    for str in body {
        if str == "\n" {
            nextIndex = body.index(after: nextIndex)
        } else {
            break
        }
    }
    
    self.titleLabel.text = data.title
    self.dateLabel.text = DateManager().formatted(date: Date(timeIntervalSince1970: data.createdAt))
    self.bodyLabel.text = String(data.body[nextIndex..<data.body.endIndex])
}
```
<br>

따라서 셀의 내용을 설정하는 메서드에서 내용인 `body`를 for로 돌면서 개행문자가 아닌 첫 문자가 위치하는 인덱스를 얻어 해당 인덱스 이후부터 body로 표시되도록 하여 해결했습니다!
<br>

### 4. CoreData에 저장된 값 수정하기
이미 생성된 일기장을 저장하면 새로 저장하는 것이 아닌 저장된 내용을 수정해야 합니다. 처음에는 저장하는 값의 `id`(=UUID)가 같으면 덮어씌워질거라 생각하여 구현했으나 새로운 일기가 저장되었습니다.

현재 일기의 `id`를 받아와 `NSFetchRequest<NSFetchRequestResult>`의 `predicate`로 같은 `id`인 일기를 가져오도록 했습니다. 만약 가져온 `predicate`의 last가 `nil`이면 저장된 값이 없다는 것으로 판단되어 `DiaryEntity`를 생성해 저장하였고, `nil`이 아니면 이미 저장된 값이 있으므로 해당 `DiaryEntity`에 `setValue`로 새로운 값으로 변경해 저장하도록 구현했습니다.
<br>

### 5. CoreData Framework 추가 및 적용하기
리뷰어인 찰리가 CoreData와 해당 프로젝트에 의존성을 떼어냄과 함께 CoreData Framework를 만들어 사용해보는 것을 추전해주셔서 적용해봤습니다.
<br>

**FrameWork 추가 해주기**

프레임워크를 프로젝트에 추가하는방법이 드래그 앤 드롭 방식으로 시도했지만 import가 되지 않았습니다. 그래서 +버튼을 눌러 add 방식으로 추가해 주었더니 해결이 되었습니다.

<img src="https://i.imgur.com/GGyR0AI.png" width="500" height="300" /><br>
<img src="https://i.imgur.com/9LAqAiJ.png" width="400" height="400" />

<br>

**Diary 저장소를 찾지 못하는 오류**

프레임워크에서도 프로젝트에서 한 방식과 동일하게 `"Diary"`라는 이름으로 **Data Model**을 찾도록 했습니다.
<br>

```swift
lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "Diary")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()
```
<br>

> Diary[15018:562438] [error] error:  Failed to load model named Diary

하지만 프로젝트에 있던 CoreData **Data Model**를 삭제하고 나니 찾을 수 없다는 에러가 발생했습니다. 프레임워크에 분명 `"Diary"`이 있는데 왜 찾을 수 없던 이유는 위의 방식은 프로젝트 내부에 있는 모델을 찾기 때문이었습니다.
<br>

```swift
private let identifier: String = "yagom.net.CoreDataFramework"
private let model: String = "Diary"

private lazy var persistentContainer: NSPersistentContainer = {
    let bundle = Bundle(identifier: identifier)
    guard let modelURL = bundle?.url(forResource: model, withExtension: "momd") else { fatalError("invalid URL") }
    guard let managedObjectModel = NSManagedObjectModel(contentsOf: modelURL) else { fatalError("invalid NSManagedObjectModel") }
    
     let container = NSPersistentContainer(name: model, managedObjectModel: managedObjectModel)
    container.loadPersistentStores(completionHandler: { (_, error) in
        if let error = error as NSError? {
            fatalError("Unresolved error \(error), \(error.userInfo)")
        }
    })
    return container
}()
```
<br>

따라서 프레임워크 프로젝트의 Bundle identifier를 통해 프로젝트가 아닌 프레임워크 내부의 데이터 모델을 찾는 코드로 변경하여 해결했습니다.
<br><br>


## 🔗 참고 링크


<details>
<summary>[STEP 1]</summary>
	
[Adaptivity and Layout](https://developer.apple.com/documentation/coredata)<br>
[UIKit: Apps for Every Size and Shape](https://developer.apple.com/videos/play/wwdc2018/235/)<br>
[Making Apps Adaptive, Part 1 / Script](https://asciiwwdc.com/2016/sessions/222)<br>
[Making Apps Adaptive, Part 2 / Script](https://www.youtube.com/watch?v=s3utpBiRbB0)<br>
[DateFormatter](https://developer.apple.com/documentation/foundation/dateformatter)<br>
[UITextView](https://developer.apple.com/documentation/uikit/uitextview)<br>
[키보드에 동적인 스크롤뷰](https://seizze.github.io/2019/11/17/iOS에서-키보드에-동적인-스크롤뷰-만들기.html)<br>
[UITextField Left padding 넣어주기 ](https://developer-fury.tistory.com/46)<br>
[키보드야 텍스트 가리지마](https://velog.io/@cherrish_red/iOS-%ED%82%A4%EB%B3%B4%EB%93%9C%EC%95%BC-%ED%85%8D%EC%8A%A4%ED%8A%B8-%EA%B0%80%EB%A6%AC%EC%A7%80%EB%A7%88)<br>
[timeIntervalSince1970](https://developer.apple.com/documentation/foundation/date/1779963-timeintervalsince1970)<br>
[UITextView](https://developer.apple.com/documentation/uikit/uitextview)<br>
[DateFormatter](https://developer.apple.com/documentation/foundation/dateformatter)<br>
[Create space at the beginning of a UITextField](https://stackoverflow.com/questions/25367502/create-space-at-the-beginning-of-a-uitextfield/27066764#27066764)<br>
[cell 이름으로 register하기](https://github.com/SwifterSwift/SwifterSwift/blob/master/Sources/SwifterSwift/UIKit/UICollectionViewExtensions.swift#L118)<br>
</details>

<details>
<summary>[STEP 2]</summary>
    
[공유하기 버튼](https://royhelen.tistory.com/25)<br>
[FrameWork 만들기](https://www.google.com/url?sa=t&rct=j&q=&esrc=s&source=web&cd=&cad=rja&uact=8&ved=2ahUKEwiIys_Z4uP5AhXZQPUHHTO6AbUQFnoECAkQAQ&url=https%3A%2F%2Fzeddios.tistory.com%2F987&usg=AOvVaw2zfaIUqh_b6GyA2rlZDq_h)<br>
[FrameWork 만들기2](https://www.google.com/url?sa=t&rct=j&q=&esrc=s&source=web&cd=&cad=rja&uact=8&ved=2ahUKEwiCkbaM4-P5AhUMDd4KHSUbCdMQFnoECDgQAQ&url=https%3A%2F%2Ftaeminator1.tistory.com%2F38&usg=AOvVaw1JiLEm2nAOqLXNOEa_ALcC)<br>
[CoreData](https://www.google.com/url?sa=t&rct=j&q=&esrc=s&source=web&cd=&cad=rja&uact=8&ved=2ahUKEwiLkM6l4-P5AhXZVd4KHaOoBJAQFnoECAoQAQ&url=https%3A%2F%2Ficksw.tistory.com%2F224&usg=AOvVaw1rAKCD2RAGhfPSGU20cLCN)<br>
[CoreData2](https://www.google.com/url?sa=t&rct=j&q=&esrc=s&source=web&cd=&cad=rja&uact=8&ved=2ahUKEwiLkM6l4-P5AhXZVd4KHaOoBJAQFnoECAcQAQ&url=https%3A%2F%2Fzeddios.tistory.com%2F987&usg=AOvVaw2zfaIUqh_b6GyA2rlZDq_h)<br>
</details>



