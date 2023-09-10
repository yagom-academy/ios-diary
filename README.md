# 📔 일기장
프로젝트 기간: 2023.8.28 ~ 

## 📖 목차
1. [🍀 소개](#1.)
2. [👨‍💻 팀원](#2.)
3. [📅 타임라인](#3.)
4. [👀 시각화된 프로젝트 구조](#4.)
5. [💻 실행 화면](#5.)
6. [🪄 핵심 경험](#6.)
7. [🧨 트러블 슈팅](#7.)
8. [📚 참고 링크](#8.)

</br>

<a id="1."></a></br>
## 🍀 소개
일기를 생성, 수정, 삭제할 수 있는 앱
</br>

<a id="2."></a></br>
## 👨‍💻 팀원
| Max | hamg |
| :--------: | :--------: |
| <Img src = "https://hackmd.io/_uploads/B1FqbcBAn.png" width="200" height="200"> |<Img src="https://hackmd.io/_uploads/BknBM9rC2.jpg" width="200" height="200"> |
|[Github Profile](https://github.com/maxhyunm)|[Github Profile](https://github.com/hemg2) |


</br>

<a id="3."></a></br>
## 📅 타임라인
|날짜|내용|
|:--:|--|
|2023.08.28| `SwiftLint` 라이브러리 추가|
|2023.08.29| `SwiftLint` 조건 변경 |
|2023.08.30| `DiaryEntity` `CreateDiaryViewController `생성<br> `keyboard` `NotificationCenter` 생성 및 구현 | 
|2023.09.01| `CoreData`: `Create` 구현|
|2023.09.05| `CoreData`: `UpDate`, `Delete` 구현 <br> `Swipe` `share`, `delete` 구현 <br> `AlertController` 생성  |
|2023.09.06| `CoreData`: `fetchDiary` 구현 |
|2023.09.07| 개인 학습 및 README 작성 |

</br>

<a id="4."></a></br>
## 👀 시각화된 프로젝트 구조
### FileTree
    ├── Diary
    │   ├── Protocol
    │   │   ├── AlertDisplayble.swift
    │   │   └── ShareDiary.swift
    │   ├── DataManager
    │   │   └── CoreDataManager.swift
    │   ├── Extension
    │   │   └── DateFormatter+.swift
    │   ├── Model
    │   │   ├── Diary+CoreDataClass.swift
    │   │   ├── Diary+CoreDataProperties.swift
    │   │   ├── DecodingManager.swift
    │   │   └── DiaryEntity.swift
    │   ├── Error
    │   │   └── DecodingError.swift
    │   ├── Controller
    │   │   ├── CreateDiaryViewController.swift
    │   │   └── DiaryListViewController.swift
    │   ├──  View
    │   │   └── DiaryListTableViewCell.swift
    │   ├── App
    │   │   ├── AppDelegate.swift
    │   │   └── SceneDelegate.swift
    │   ├── Assets.xcassets
    │   ├── Info.plist
    │   └── Diary.xcdatamodeld
    └── Diary.xcodeproj

</br>

<a id="5."></a></br>
## 💻 실행 화면

|작동 화면|
|:--:|
|<img src="https://hackmd.io/_uploads/SJkqEgUC3.gif" width="300" height="600"/>|

</br>

<a id="6."></a></br>
## 🪄 핵심 경험
#### 🌟 CoreData를 활용한 데이터 저장
일기 데이터를 위한 저장소로 CoreData를 활용하였습니다.
#### 🌟 Singleton 패턴을 활용한 CoreDataManager 구현
데이터 처리를 위한 로직 전반을 Singleton 패턴으로 구현하여 앱 전역에서 활용 가능하도록 하였습니다.
#### 🌟 NotificationCenter를 활용한 키보드 인식
키보드 활성화 여부에 따라 뷰의 크기를 변경하여 커서 위치가 가려지지 않도록 NotificationCenter를 활용하였습니다.
#### 🌟 여러 개의 생성자를 통한 상황별 데이터 전달
상황에 따라 ViewController에서 다른 데이터를 표시해야 하는 경우에 대비해 생성자를 활용하였습니다.
#### 🌟 Protocol과 Extension을 활용한 코드 분리
Alert, Swipe 등 별개의 작업으로 분리할 수 있는 내용들은 Protocol과 Extension을 통해 분리하였습니다.

</br>

<a id="7."></a></br>
## 🧨 트러블 슈팅

### 1️⃣ **반복적인 날짜 포매팅 처리**
🔒 **문제점** </br>
 일기 리스트 화면과 새로운 일기를 생성하는 화면에서 모두 아래와 같이 날짜 포매팅을 사용해야 하는 것을 알 수 있었습니다.
```swift
 private let formatter: DateFormatter = {
    let formatter = DateFormatter()
    formatter.locale = Locale(identifier: "ko_kr")
    formatter.dateFormat = "yyyy년MM월dd일"
    return formatter
}()
```
동일한 코드가 두 개의 `ViewController`에서 반복되어 사용하고 있었으며
반복되는 것을 막기 위해 해당 코드를 분리하고자 했습니다.
</br></br>

🔑 **해결방법** </br>
저장 프로퍼티가 아닌 메서드로 사용하여 재사용성을 높히게 되었습니다.
```swift
extension DateFormatter {
    func formatToString(from date: Date, with format: String) -> String {
        self.dateFormat = format
        
        return self.string(from: date)
    }
}

DateFormatter().formatToString(from: entity.createdAt, with: "YYYY년 MM월 dd일")
```
</br>

### 2️⃣ **화면이 꺼질 때 자동 저장 처리**
🔒 **문제점**</br>
요구사항에 따르면 사용자가 화면을 벗어날 때마다 자동 저장을 진행해야 했습니다. 이를 구현하기 위해 처음에는 `CreateViewController`의 `viewWillDisappear` 메서드에서 저장처리를 진행할 수 있도록 작업했습니다.
```swift
override func viewWillDisappear(_ animated: Bool) {
    super.viewWillDisappear(animated)
    saveDiary()
}
```
하지만 이렇게 하니 일기 삭제 처리를 한 뒤 뷰컨트롤러를 pop할 때에도 저장처리를 거치게 되어 오류가 발생하였습니다.
</br></br>

🔑 **해결방법**</br>
`TextView`가 수정될 때마다 뷰컨트롤러가 가지고 있는 일기 객체의 내용을 바꿔주고, 저장이 필요한 순간에 `saveContext` 처리만 진행할 수 있도록 아래와 같이 구현하였습니다.
```swift
func textViewDidChange(_ textView: UITextView) {
    let contents = textView.text.split(separator: "\n")
    guard !contents.isEmpty,
          let title = contents.first else { return }

    let body = contents.dropFirst().joined(separator: "\n")

    diary.title = "\(title)"
    diary.body = body
}
```
</br>

### 3️⃣ **빈 일기가 저장되는 현상**
🔒 **문제점(1)**</br>
처음에는 키보드가 비활성화되면 무조건 내용을 저장하도록 구현을 하였습니다. 하지만 이렇게 하니, 신규 생성 버튼(+)을 누른 뒤 아무런 내용도 입력하지 않고 뒤로 가기 처리를 하면 제목과 내용이 모두 비어있는 일기가 생성이 되었습니다.
```swift
func textViewDidEndEditing(_ textView: UITextView) {
    CoreDataManager.shared.saveContext()
}
```
|빈일기 생성 화면|
|:--:|
|<img src="https://cdn.discordapp.com/attachments/1148871276677562388/1148871347871686706/3639304423dabd43.gif" width="200" height="400"/>|

</br></br>

🔑 **해결방법(1)**</br>
빈 일기가 생성되는것을 막기 위해 title 이 없을 경우 저장 되지 않게 진행하였습니다.
```swift
func textViewDidEndEditing(_ textView: UITextView) {
        let contents = textView.text.split(separator: "\n")
        guard !contents.isEmpty else { return }
        
        CoreDataManager.shared.saveContext()
    }
```
</br></br>
🔒 **문제점(2)**</br>
위의 처리를 통해 더 이상 데이터베이스에 빈 일기가 저장되지는 않았지만, saveContext 되지 않은 객체가 여전히 context 내부에 남아 일시적으로 빈 일기가 리스트에 보이는 현상이 생겼습니다. 
```swift
func readCoreData() {
        do {
            diaryList = try container.viewContext.fetch(Diary.fetchRequest())
            tableView.reloadData()
        } catch {
           ....
        }
    }
```
</br></br>

🔑 **해결방법(2)**</br>
fetch해 온 일기들 중에 title이 비어있는 건은 걸러낼 수 있도록 filter 처리를 추가하였습니다.
```swift
 private func readCoreData() {
        do {
            let fetchedDiaries = try CoreDataManager.shared.fetchDiary()
            diaryList = fetchedDiaries.filter { $0.title != nil }
            tableView.reloadData()
        } catch {
           .....
        }
    }
```
</br>

<a id="8."></a></br>
## 📚 참고 링크
- [Apple Developer Documentation: Adaptivity and Layout](https://developer.apple.com/design/human-interface-guidelines/layout)
- [Apple Developer Documentation: DateFormatter](https://developer.apple.com/documentation/foundation/dateformatter)
- [Apple Developer Documentation: UITextView](https://developer.apple.com/documentation/uikit/uitextview) 
- [Apple Developer Documentation: Core Data](https://developer.apple.com/documentation/coredata) 
- [Apple Developer Documentation: Making Apps with Core Data](https://developer.apple.com/videos/play/wwdc2019/230/)
- [Apple Developer Documentation: NSFetchedResultsController](https://developer.apple.com/documentation/coredata/nsfetchedresultscontroller)
- [Apple Developer Documentation: UITextViewDelegate](https://developer.apple.com/documentation/uikit/uitextviewdelegate)
- [Apple Developer Documentation: UISwipeActionsConfiguration](https://developer.apple.com/documentation/uikit/uiswipeactionsconfiguration)
</br>
