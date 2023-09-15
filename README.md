# 📓 일기장
## 일기를 생성하고 작성 후에 저장 및 삭제할 수 있는 앱입니다.

**핵심 개념 및 경험**
 
- **DateFormatter**
  - `locale` 프로퍼티를 이용한 지역화
- **CoreData**
  - `CoreData`모델을 통한 CRUD 기능
  - (Create, Read(Retrieve), Update, Delete)
- **UITextView**
  - `UITextView`에서 텍스트 편집
- **keyboardWillShowNotification / keyboardWillHideNotification**
  - 키보드가 나타나거나 사라질 때 `post`된 `Notification`을 `addObserver`를 통해 수신
- **subscript**
  - 배열의 범위를 벗어난 접근을 할 때 안전하게 접근할 수 있도록 `subscript`를 사용하여 `Array`의 기능 확장
- **textViewDidEndEditing()**
  - `UITextView`의 입력이 끝났을 때 `UITextViewDelegate`를 통해 실행되는 메서드
- **UIAlertAction**
  - 얼럿 버튼을 눌렀을 때 실행되는 액션

**프로젝트 기간 : 23.08.28 ~ 23.09.15**

</br>

## 📖 목차
1. [팀원 소개](#1.)
2. [타임 라인](#2.)
3. [시각화 구조](#3.)
4. [실행 화면](#4. )
5. [트러블 슈팅](#5.)
6. [참고 자료](#6.)
7. [팀 회고](#7.)

<a id="1."></a></br>
## 👨‍💻 팀원 소개
|<Img src = "https://hackmd.io/_uploads/rJj1EtKt2.png" width="200" height="200">|<Img src = "https://user-images.githubusercontent.com/109963294/235301015-b81055d2-8618-433c-b680-58b6a38047d9.png" width ="200" height="200"/>|
|:-:|:-:|
|[**Yetti**](https://github.com/iOS-Yetti)|[**idinaloq**](https://github.com/idinaloq)|

<a id="2."></a></br>
## ⏰ 타임 라인
|날짜|내용|
|:--:|--|
|2023.08.28.|메인 스토리보드 삭제<br>SceneDelegate에 rootViewController 추가<br>SwiftLint적용|
|2023.08.29.|SwiftLint설정 변경<br>DiaryListViewController구현<br>DiaryCollectionViewListCell구현<br>DiaryEntity구현<br>DiaryDetailViewController생성|
|2023.08.30.|DateFormatter 기능확장<br>키보드 사용을 위한 setUpKeyboardEvent() 메서드 추가<br>NewDiaryViewController 구현<br>리팩토링<br>|
|2023.08.31.|KeyboardManager 클래스로 키보드 기능분리<br>LocaleIdentifier타입 생성<br>리팩토링|
|2023.09.01.|README 작성|
|2023.09.04.|CoreData생성<br>textView키보드 기능추가<br>테스트용json제거|
|2023.09.05|CoreData 테스트용 코드 작성|
|2023.09.06|CoreData의 Create,Retieve,Update기능 구현<br>CoreData관련코드 리팩토링|
|2023.09.07|CoreData의 Delete기능 추가<br>swipe기능 구현|
|2023.09.08|README 작성|
|2023.09.11|CoreDataManager 리팩토링|
|2023.09.12|textView 데이터 CRUD 기능 리팩토링|
|2023.09.13|Step2 PR 작성|
|2023.09.15|Stpe2 리뷰에 따른 수정<br>README 작성|

<a id="3."></a></br>
## 👀 시각화 구조
### 1. File Tree
    Diary
    ├── Application
    │   ├── AppDelegate.swift
    │   └── SceneDelegate.swift
    ├── Application Support
    │   └── Diary.xcdatamodeld        
    ├── Controller
    │   ├── DiaryDetailViewController.swift
    │   └── DiaryListViewController.swift
    ├── Enum
    │   └── LocaleIdentifier.swift
    ├── Error
    │   └── DecodingError.swift
    ├── Extension
    │   ├── Array+.swift
    │   ├── CellIdentifiable+.swift
    │   └── DateFormatter+.swift
    ├── Manager
    │   ├── CoreDataManager.swift
    │   └── KeyboardManager.swift
    ├── Protocol
    │   └── CellIdentifiable.swift
    ├── View
    │   ├── Base.lproj
    │   │   └── LaunchScreen.storyboard
    │   └── DiaryCollectionViewListCell.swift
    ├── Resource
    │   ├── Assets.xcassets
    │   │   ├── AccentColor.colorset
    │   │   ├── AppIcon.appiconset
    └── └── Info.plist


### 2. 클래스 다이어그램
![일기장 UML](https://hackmd.io/_uploads/rk74B9Wyp.png)

<a id="4."></a></br>
## 💻 실행화면

|일기 생성화면|스와이프 액션기능|더보기 버튼|
|:-----:|:-----------:|:--------:|
|<Img src = "https://hackmd.io/_uploads/BkTbwig1T.gif" width = "300">|<Img src = "https://hackmd.io/_uploads/B1NZOjlJa.gif" width = "300">|<Img src = "https://hackmd.io/_uploads/rkqeKjlk6.gif" width = "300">|


|실행화면(가로)|
|:---:|
|<Img src = https://github.com/idinaloq/testRep/assets/124647187/24161461-538a-44de-991b-63375559cc07 >|

<a id="5."></a></br>
## 🧨 트러블 슈팅

### 1️⃣ out of range 
⚠️ **문제점** <br>
- collectionView 메서드에서 셀을 생성할 때, diaryEntity 배열에 indexPath.item으로 접근을 해서 데이터를 가져오고 있었습니다. 하지만 이렇게 되면 만약 diaryEntity 배열을 벗어난 indexPath로 접근을 하게되면 앱이 크래시가 날 수 있는 가능성이 있었습니다.

**기존코드**
```swift
extension DiaryListViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    ...
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: DiaryCollectionViewListCell.identifier, for: indexPath) as? DiaryCollectionViewListCell else {
            return UICollectionViewCell()
        }
        
        guard let diaryEntity = diaryEntity else {
            return UICollectionViewCell()
        
        cell.configureLabel(diaryEntity[indexPath.item])
        
        return cell
    }
    ...
}
```

✅ **해결방법** <br>
- 배열에 잘못된 접근을 할 때(범위를 벗어난 접근) nil이 설정되도록 subscript를 사용해서 안전하게 배열에 접근할 수 있도록 array에 기능을 추가했고, diaryEntity가 nil일 때 빈 셀을 반환하는 부분도 그에 맞게 수정을 다음과 같이 진행했습니다.

**현재코드**
```swift
extension Array {
    subscript(index index: Int) -> Element? {
        return self.indices ~= index ? self[index] : nil
    }
}

extension DiaryListViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    ...
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: DiaryCollectionViewListCell.identifier, for: indexPath) as? DiaryCollectionViewListCell else {
            return UICollectionViewCell()
        }
        
        guard let diaryIndex = diaryEntity?[index: indexPath.item] else {
            return cell
        }
        
        cell.configureLabel(with: diaryIndex)
        
        return cell
    }
    ...
}
```


### 2️⃣ View의 LifeCycle
⚠️ **문제점** <br>
- `NavigationController`를 통해 다음 뷰로 이동하고 다시 이전 뷰 컨트롤러로 돌아올 때 일기장이 생성되거나 수정된 변경사항을 `cell`에 업데이트 하기 위해 `viewWillAppear()`메서드에 `collectionView.reloadData()` 메서드를 통해 셀이 다시 그려지도록 했습니다.
- 하지만 셀이 업데이트가 되지 않고, 한 번씩 업데이트 주기가 밀리는 현상이 있었습니다.
(다음 데이터가 들어와야 이전 데이터가 업데이트 되는 현상)

**기존코드**
```swift
 override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.diaries = CoreDataManager.shared.fetchDiary(Diary.fetchRequest())
        collectionView.reloadData()
    }
```

✅ **해결방법** <br>
- `collectionView.reloadData()`메서드는 셀을 다시 그리는 메서드인데, `ViewWillApear`에서 실행하게 되면 뷰가 나타나기 전에 셀을 그려서 적용되지 않는 문제였습니다. 아래 코드와 같이 `ViewDidAppear`에서 뷰가 생성된 후 셀을 그리도록 수정하였습니다.

**현재코드**
```swift
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.diaries = CoreDataManager.shared.fetchDiary(Diary.fetchRequest())
        collectionView.reloadData()
    }
```

### 3️⃣ CoreData에 배열로 저장된 객체 식별하기
⚠️ **문제점** <br>
- CoreData에 `Diary`객체가 `Create`될 때 `[Diary]`와 같이 배열로 만들어지고 있었습니다. `Retrieve`할 때 역시 배열로 반환하고 있는데, 이렇게 된다면 특정 객체의 값을 수정하려고 할때 어느 배열에 어떤 값이 있는지 알 수 없었기 때문에 수정과 삭제가 불가능한 문제가 있었습니다.

**기존코드**
```swift
import CoreData

extension Diary {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Diary> {
        return NSFetchRequest<Diary>(entityName: "Diary")
    }

    @NSManaged public var createdAt: String?
    @NSManaged public var title: String?
    @NSManaged public var body: String?
}

extension Diary: Identifiable {
}
```

✅ **해결방법** <br>
- 모델 데이터에 `identifier`라는 변수를 만들고, 데이터가 만들어 질 때 `identifier`에 `UUID`값을 할당하는 방식으로 변경해서 원하는 배열에 접근할 수 있도록 변경하였습니다.

**현재코드**
```siwft
import CoreData

extension Diary {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Diary> {
        return NSFetchRequest<Diary>(entityName: "Diary")
    }

    @NSManaged public var createdAt: String?
    @NSManaged public var title: String?
    @NSManaged public var body: String?
    @NSManaged public var identifier: String?
}

extension Diary: Identifiable {
}

final class CoreDataManager {
    ...
    func createDiary(_ textView: UITextView) {
        ...
        object.setValue(UUID().uuidString, forKey: "identifier")
        saveContext()
    }
    ...
}

```

### 4️⃣ 두 개의 ViewController를 하나로 합치기
⚠️ **문제점** <br>
- 이전에 뷰컨트롤러는 목록을 보여주는 `DiaryListViewController`, 작성된 일기 내용을 보여주는 `DiaryDetailViewController`, 일기장을 새로 만드는 `NewDiaryViewController` 총 세 개가 있었습니다.
- 일기를 새로 생성하거나, 수정하는 화면을 볼 때 구성 자체는 완전히 동일했고, 기존의 저장된 데이터를 보여주거나 데이터가 없다면 새로 생성해야되는 부분 이외에 차이는 없었습니다.


✅ **해결방법** <br>
- `NewDiaryViewController`를 `DiaryDetailViewController`에 통합시키고, 기존에 `DiaryDetailViewController`의 수정, 저장 기능만 사용하는 로직을 그대로 사용하였습니다.
- 새로운 일기를 미리 생성해서 작성화면으로 넘겨주고, 저장을 하게 되는데, 만약 아무런 내용도 입력하지 않았다면 다시 `DiaryListViewController`로 넘어올 때 생성되었던 일기가 삭제되도록 다음과 같이 작성하였습니다. 
```swift
final class DiaryListViewController: UIViewController {
    ...
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.diaries = CoreDataManager.shared.fetchAllDiaries()
        
        diaries.forEach { diary in
            if diary.title == nil && diary.body == nil {
                guard let identifier = diary.identifier else {
                    return
                }
                
                CoreDataManager.shared.delete(diary: identifier)
            }
        }
        self.diaries = CoreDataManager.shared.fetchAllDiaries()
        collectionView.reloadData()
    }
    ...
}
```

<a id="6."></a></br>
## 📚 참고자료
- [🍎 Apple Docs: `DateFormatter`](https://developer.apple.com/documentation/foundation/dateformatter)
- [🍎 Apple Docs: `NotificationCenter`](https://developer.apple.com/documentation/foundation/notificationcenter)
- [🍎 Apple Docs: `keyboardWillShowNotification`](https://developer.apple.com/documentation/uikit/uiresponder/1621576-keyboardwillshownotification)
- [🍎 Apple Docs: `keyboardWillHideNotification`](https://developer.apple.com/documentation/uikit/uiresponder/1621606-keyboardwillhidenotification)
- [🍎 Apple Docs: `UITextView`](https://developer.apple.com/documentation/uikit/uitextview)
- [🍎 Apple Docs: `CoreData`](https://developer.apple.com/documentation/coredata)
- [🍎 Apple Docs: `UIViewController LifeCycle`](https://developer.apple.com/documentation/uikit/uiviewcontroller#1652793)
- [🍎 Apple Docs: `UUID`](https://developer.apple.com/documentation/foundation/uuid)
- [🌐 Blog: `subscript로 안전하게 배열 조회하기`](https://kkimin.tistory.com/86)
- [🌐 Blog: `키보드가 텍스트를 가리지 않도록 하기`](https://velog.io/@qudgh849/keyboard가-TextView를-가릴-때)
- [🌐 Blog: `identifier 재사용 프로토콜`](https://prod.velog.io/@yyyng/셀-재사용-프로토콜)
- [🌐 Blog: `collectionViewCell Swipe`](https://icksw.tistory.com/291)

<a id="7."></a></br>
## 👬 팀 회고
### To. Idinaloq
- 시간을 잘 맞춰주셔서 좋았습니다
- 서로 솔직한 의견을 잘 나눌 수 있었던 것 같아 좋았습니다
- 프로젝트를 마무리 짓지 못한 부분은 아쉽습니다 ㅠㅠ

### To. Yetti
- 짧은 시간동안 집중해서 팀 프로젝트를 진행하니 효율이 좋다는걸 처음으로 느꼈네요.😄
- 서로 일정이 있을때 편의를 봐주셔서 너무 좋았습니다!!! 👍
