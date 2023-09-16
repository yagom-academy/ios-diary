# 📕Diary

- **프로젝트 기간** : 2023.08.28 ~ 2023.09.15
- **프로젝트 팀원** : [hoon 🐝](https://github.com/Hoon94), [Karen 🦦](https://github.com/karenyang835)
- **프로젝트 리뷰어** : [July 🍀](https://github.com/July911)

## 🔖 목차 
1. [프로젝트 소개](#1.)
2. [실행 화면](#2.)
3. [시각적 프로젝트 구조](#3.) 
4. [트러블 슈팅](#4.)
5. [참고 링크](#5.)
6. [about TEAM](#6.)

---

</br>

<a id="1."></a>
## 1. 💬 프로젝트 소개
> `CoreData`를 활용하여 만든 일기장 앱으로 수정이 간편하고, 날짜별로 날씨 정보를 함께 저장합니다.

[![Xcode](https://img.shields.io/badge/Xcode-v14.3.1-blue?style=flat&logo=Xcode)]() [![swift](https://img.shields.io/badge/swift-v5.6-red?style=flat&logo=Swift)]() [![IOS](https://img.shields.io/badge/iOS-v15.0+-orange?style=flat&logo=Apple&logoColor=white)]() [![SwiftLint](https://img.shields.io/badge/SwiftLint-v0.52.4-green?style=flat&logo=stylelint&logoColor=white)]()

---
</br>

<a id="2."></a>

## 2.📱실행 화면
| Diary - 새 일기 작성 |Diary - 일기 수정 |
| :-: |:-: |
|<img src="https://github.com/Hoon94/Computer_Arch/assets/43189761/2d975ef9-d657-4731-b767-eb28e2da7fd1" style="zoom:70%;" />|<img src="https://github.com/Hoon94/Computer_Arch/assets/43189761/41493d15-0a56-4193-8695-01c54e37261f" style="zoom:70%;" />| 

| Diary - 공유, 삭제(메인) |Diary - 더보기(디테일) |
| :-: |:-: |
|<img src="https://github.com/Hoon94/Computer_Arch/assets/43189761/bd4ce037-8dc5-4b07-8893-db7a0fff39a2" style="zoom:70%;" />|<img src="https://github.com/Hoon94/Computer_Arch/assets/43189761/b6739e98-bb27-467d-8244-ab1109219e48" style="zoom:70%;" />| 

| Diary - Alert Error |Diary - Toast Error |
| :-: |:-: |
|<img src="https://github.com/Hoon94/Computer_Arch/assets/43189761/5823fa52-7852-4857-b68a-90dd37a1aa46" style="zoom:70%;" />|<img src="https://github.com/Hoon94/Computer_Arch/assets/43189761/b4603268-5442-4868-af19-512240d9ba0f" style="zoom:70%;" />| 

---

</br>


<a id="3."></a>
## 3. 📊 시각적 프로젝트 구조

### 📂 폴더 구조

```bash
┌── Diary
│   ├── Network
│   │   ├── Location
│   │   ├── URLComponents
│   │   ├── NetworkAPI
│   │   └── WeatherAPI
│   ├── Error
│   │   ├── DecodingManager
│   │   ├── NetworkAPIDefinition
│   │   └── CacheStore
│   ├── CoreData
│   │   ├── CoreDataManager
│   │   ├── PersistentContainer
│   │   ├── Diary
│   │   │   ├── Diary v2
│   │   │   └── Diary
│   │   └── MappingFile 
│   ├── Model
│   │   ├── DiaryModel
│   │   └── CellIdentifier
│   ├── View
│   │   ├── LaunchScreen
│   │   └── DiaryCell
│   ├── Controller
│   │   ├── DiaryViewController
│   │   └── DiaryDetailViewController
│   ├── Protocol
│   │   ├── Shareable
│   │   └── Toastable
│   ├── Extension
│   │   ├── DateFormatter+
│   │   ├── UITextView+
│   │   └── Array+
│   ├── Application
│   │   ├── AppDelegate
│   │   └── SceneDelegate
│   └── Resource
│       ├── Assets
│       └── Info
│
└── README.md
```


### 🎨 Class Diagram
</br>

![image](https://github.com/karenyang835/ios-diary/assets/124643896/c2c14350-a719-49da-a2ad-5bdd811a896f)


---

</br>

<a id="4."></a>

## 4. 🚨 트러블 슈팅

### 1️⃣ 지역별 현지화
#### ⛔️ 문제점
- 다이어리의 작성 일자에 대한 날짜 표현 형식을 사용자에 맞게 표현해 주기 위한 방법이 필요했습니다. JSON 파일에 저장된 날짜는 시스템 시간으로 1970년을 기준으로 한 `Double` 타입의 값이었기 때문에 사용자에게 표현하는 형식을 선택해야 했습니다.


#### ✅ 해결 방법
- JSON 파일에서 받아온 날짜를 디바이스의 지역에 맞는 형식으로 표현해 주기 위해 아래와 같이 Locale을 사용하였습니다.

    ```swift
    extension DateFormatter {
        static let diaryFormatter = {
            let formatter = DateFormatter()
            formatter.dateStyle = .long
            formatter.locale = Locale.current

            return formatter
        }()
    }

    // 적용
    let date = Date(timeIntervalSince1970: diaryModel[indexPath.row].date)
    let formattedDate = DateFormatter.diaryFormatter.string(from: date)
    ```

    지역에 맞게 날짜의 형식을 변경해 주는 diaryFormatter를 사용하여 JSON 데이터를 디코딩 한 값인 date(Double 타입)을 매개변수로 전달하였습니다.

### 2️⃣`CoreData` 사용
#### ⛔️ 문제점
- `CoreData`를 활용하는데 어려움이 많았습니다. 그중에서 새 일기장을 만들고 아무것도 입력하지 않은 상태로 다시 나오거나 입력을 하다가 다 지우고 나오면 생성되지 않아야 된다고 생각을 하였는데 생성이 되는 문제점이 발생했습니다.
<img src="https://hackmd.io/_uploads/B1LKSOsRh.gif" height=400>
    
#### ✅ 해결 방법
- `textView`의 내용이 비어있으면 `delete`를 해주어 해결했습니다.

    ```swift
     func saveDiary() {
            guard !contentTextView.text.isEmpty else {
                CoreDataManager.shared.deleteDiary(item: diary)
                return
            }

            let contents = contentTextView.text.split(separator: "\n")
            let title = String(contents[0])
            let body = contents.dropFirst().joined(separator: "\n")

            if contents.isEmpty {
                saveContents(title: "", body: "")
            } else {
                saveContents(title: title, body: body)
            }
        }
    ```

### 3️⃣ `Diary` 생성 위치
#### ⛔️ 문제점
- `Diary`를 `Creat`하는 위치에 따라 `tableView`에 `cell`이 추가되는 시점이 달랐습니다. 두 번째 화면인 `DiaryDetailViewController`에서 `Diary`를 생성하고 저장하는 경우 이전 화면으로 돌아와 `tableView`를 확인하면 목록에 없는 문제가 발생하였습니다. 다음 화면으로 넘어갔다가 다시 돌아오면 그제야 `cell`이 `tableView`에 추가되었습니다. `tableView`에 `cell`이 그려지는 시점이 문제였습니다.

#### ✅ 해결 방법
- 이를 해결하기 위해 `Diary`를 첫 화면인 `DiaryViewController`에서 생성하여 다음 화면인 `DiaryDetailViewController`로 넘겨주는 작업을 수행하였습니다.

    ```swift
    let action = UIAction { _ in
        let diary = CoreDataManager.shared.createDiary()
        let diaryDetailViewController = DiaryDetailViewController(diary: diary, isUpdate: false)
        self.navigationController?.pushViewController(diaryDetailViewController, animated: true)
    }
    ```
    
    생성한 `Diary`에 입력을 하는 경우 `save` 또는 `update` 동작을 분리하기 위하여 `isUpdate`를 통해 구분하였습니다.

### 4️⃣ 오토레이아웃
#### ⛔️ 문제점
- `Hierarchy`로 확인을 했을 때 해당 오류가 발생됐습니다.

    ![](https://hackmd.io/_uploads/rJpIedsR2.png)

#### ✅ 해결 방법
- 확인을 해보니 날짜를 받아오는 `label`의 사이즈가 변동이 되면서 발생된 문제점이라 `Hugging`을 주어서 해결했습니다.

    ```swift
        private let dateLabel = {
                let label = UILabel()
                label.font = .preferredFont(forTextStyle: .body)
                label.setContentHuggingPriority(.defaultHigh, for: .horizontal)

                return label
            }()
    ```

### 5️⃣`CoreData` 사용
#### ⛔️ 문제점
- 새 일기장을 만들고 아무것도 입력하지 않은 상태로 다시 나오거나 입력을 하다가 다 지우고 나오면 생성되지 않아야 된다고 생각을 하였는데 생성이 되는 문제점이 발생했습니다.

    <img src="https://hackmd.io/_uploads/B1LKSOsRh.gif" height=400>

#### ✅ 해결 방법   
- `textView`의 내용이 비어있으면 `delete`를 해주어 해결했습니다.
    
    ```swift
     func saveDiary() {
            guard !contentTextView.text.isEmpty else {
                CoreDataManager.shared.deleteDiary(item: diary)
                return
            }

            let contents = contentTextView.text.split(separator: "\n")
            let title = String(contents[0])
            let body = contents.dropFirst().joined(separator: "\n")

            if contents.isEmpty {
                saveContents(title: "", body: "")
            } else {
                saveContents(title: title, body: body)
            }
        }
    ```

### 6️⃣ `Diary` 생성 위치
#### ⛔️ 문제점
- `Diary`를 `Creat`하는 위치에 따라 `tableView`에 `cell`이 추가되는 시점이 달랐습니다. 두 번째 화면인 `DiaryDetailViewController`에서 `Diary`를 생성하고 저장하는 경우 이전 화면으로 돌아와 `tableView`를 확인하면 목록에 없는 문제가 발생하였습니다. 다음 화면으로 넘어갔다가 다시 돌아오면 그제야 `cell`이 `tableView`에 추가되었습니다. `tableView`에 `cell`이 그려지는 시점이 문제였습니다.

#### ✅ 해결 방법
- `Diary`를 첫 화면인 `DiaryViewController`에서 생성하여 다음 화면인 `DiaryDetailViewController`로 넘겨주는 작업을 수행하였습니다.

    ```swift
    let action = UIAction { _ in
        let diary = CoreDataManager.shared.createDiary()
        let diaryDetailViewController = DiaryDetailViewController(diary: diary, isUpdate: false)
        self.navigationController?.pushViewController(diaryDetailViewController, animated: true)
    }
    ```
    
    생성한 `Diary`에 입력을 하는 경우 `save` 또는 `update` 동작을 분리하기 위하여 `isUpdate`를 통해 구분하였습니다.
    

### 7️⃣ 오토레이아웃
#### ⛔️ 문제점
- 일기장을 새로 만든 후에 날씨 아이콘을 받아와서 등록됐을때는 온전하게 오토 레이아웃이 적용됐는데 일기장을 들어갔다 나오면 날씨 아이콘이 커져버리는 문제점이 발생했습니다.
    
    <img src="https://hackmd.io/_uploads/Hy71-ReJa.gif" height=400>

#### ✅ 해결 방법
- `dateLabel`의 높이에 맞추어서 날씨 아이콘의 크기가 변경되도록 제약조건을 잡아주고 `dateLabel`의 `setContentHuggingPriority`을 `required`로 가장 높게 잡아주어 해결했습니다.
    
    ```swift
     private let dateLabel = {
            let label = UILabel()
            label.font = .preferredFont(forTextStyle: .body)
            label.setContentHuggingPriority(.required, for: .vertical)
            label.setContentHuggingPriority(.defaultHigh, for: .horizontal)

            return label
        }()

        private let weatherIconImageView = {
            let imageView = UIImageView()
            imageView.contentMode = .scaleAspectFit

            return imageView
        }()
    ```

### 8️⃣ `API KEY` 숨기기
#### ⛔️ 문제점
- `API KEY`를 코드에 직접 입력하여 사용하는 경우 `API KEY`가 외부에 드러날 수 있다는 문제점이 있었습니다. 팀원과의 협업을 위해 `git`을 통해 코드를 업로드 하는 과정에서 입력했던 `API KEY`가 함께 업로드 되었습니다.

#### ✅ 해결 방법
- `API KEY`를 감추기 위해 `plist` 파일을 생성하여 외부에 드러나지 않도록 숨겼습니다. `API KEY`를 위해 생성한 파일을 `git`에 저장하고 이후 `git`에서 추적하지 않도록 설정하여 실제 `KEY` 값을 사용하였습니다.

    ```bash
    git update-index --skip-worktree Diary/Resource/WeatherInfo.plist
    ```
    
---

</br>


<a id="5."></a>

## 5.🔗 참고 링크

- 🍎 [Swift API Design Guidelines](https://www.swift.org/documentation/api-design-guidelines/)
- 🍏 [Apple Developer - UINavigationController](https://developer.apple.com/documentation/uikit/uinavigationcontroller)
- 🍏 [Apple Developer - UITextView](https://developer.apple.com/documentation/uikit/uitextview)
- 🍏 [Apple Developer - UIKeyboardLayoutGuide](https://developer.apple.com/documentation/uikit/uikeyboardlayoutguide/)
- 🍏 [Apple Developer - Date](https://developer.apple.com/documentation/foundation/date)
- 🍏 [Apple Developer - DateFormatter](https://developer.apple.com/documentation/foundation/dateformatter)
- 🍏 [Apple Developer - Adding support for languages and regions](https://developer.apple.com/documentation/xcode/adding-support-for-languages-and-regions)
- 🍏 [Apple Developer - Locale](https://developer.apple.com/documentation/foundation/locale)
- <img src="https://hackmd.io/_uploads/Sy8AUS4Lh.png" width = 20 /> [BLOG : 김종권의 iOS 앱 개발 알아가기 - SwiftLint 적용 방법](https://ios-development.tistory.com/1199)
- <img src="https://hackmd.io/_uploads/Sy8AUS4Lh.png" width = 20 /> [BLOG : Dr.kim의 나를 위한 블로그 - 화면에 딱 맞는 UITextView 만들기](https://hereismyblog.tistory.com/34)
- <img src="https://hackmd.io/_uploads/Sy8AUS4Lh.png" width = 20 /> [BLOG : Hacking with Swift - Fixing the keyboard: NotificationCenter
](https://www.hackingwithswift.com/read/19/7/fixing-the-keyboard-notificationcenter)

---

</br>


<a id="6."></a>

## 6. 🎩 aboutTEAM
| hoon ♓️   |Karen ♉️|
| :-: | :-: |
| <img src="https://hackmd.io/_uploads/HylLMDsN2.jpg" width="250"/> | <Img src="https://avatars.githubusercontent.com/u/124643896?v=4" width="250"/>|
|https://github.com/Hoon94 |https://github.com/karenyang835|

<details><summary span style="color:black; background-color:#23ff2921; font-size:110%"><b>⏰ 타임 라인 (펼쳐보기) </b></summary></span> 

|**날 짜**|**내 용**|
|:-:|-|
| 2023.08.28.    | 📝 프로젝트에서 필요로 하는 핵심기능 공부 - `CoreData`<br>|
| 2023.08.29.    | 🖨️ `SwiftLint` 라이브러리 추가<br>✴️ `tableView` 구현<br>✴️ `navigationController` 구현<br> |
| 2023.08.30.    | ✴️ `parseData` 메서드 구현<br>✴️ `custom cell` 구현<br>✴️ `diaryFormatter` 구현<br>💥 `DiaryDetailViewController` 화면이동 추가 구현<br>   |
| 2023.08.31.    | ✴️ `DiaryDetailViewController` 레이아웃 구현<br>💥 `keyboard`에 맞춰 제약조건 수정<br>|
| 2023.09.01.    | 💥 `DiaryCell` 선택시 다음 화면으로 이동<br> ✴️ `CellIdentifier` 구현<br>✴️ `DataAsset`을 불러오지 못하는 경우 `presentAlert`메소드 추가<br> 💥 중복 사용하는 프로퍼티를 상수로 선언<br> 💥 `UITableViewDelegate`와 `UITableViewDataSource extension` 분리<br> 💥 `diaryList`로 네이밍 변경<br> ✍️ `README`수정 <br> |
| 2023.09.04.    | 📝 프로젝트에서 필요로 하는 핵심기능 공부 - `CoreData CRUD` |
| 2023.09.05.    | 📝 프로젝트에서 필요로 하는 핵심기능 공부 - `UITextViewDelegate` |
| 2023.09.06.    | 📝 프로젝트에서 필요로 하는 핵심기능 공부 - `UISwipeActionsConfiguration` |
| 2023.09.07.    |✴️ `CoreData Diary Entity` 생성 <br>✴️ `Coredata loadDiary` 메소드 추가 <br>✴️ `CoreData saveDiary` 메소드 추가<br>✴️ `Coredata deleteDiary` 메소드 추가<br>|
| 2023.09.08.    |✴️ `CoreData updateDiary` 메소드 추가<br>✴️ `keyboard Done`버튼 추가<br>💥 `DiaryDetailViewController`의 화면 레이아웃을 하나의 `contentTextView`로 통합<br>|
| 2023.09.09.    |✴️ `CoreDataManager` 추가 <br>✴️ 백그라운드로 진입하는 경우 일기 자동저장 구현<br>💥 기존 `CRUD`코드 통합<br>  |
| 2023.09.11.    |✴️ `showActivityView` 메서드 추가 <br>✴️ `Shareable` `Protocol` 생성 <br>✴️ `Alert` 기능 추가 <br>💥 `tableView swipe action` 공유기능 추가<br> |
| 2023.09.12.    |✴️ `Array extension` 추가 <br> 💥`CoreDataManager`을 제너릭타입 활용으로 변경 <br> 💥 `isUpdated` 상수명 수정<br>💥`closure` 순환참조 방지를 위한 `weak self` 수정<br> |
| 2023.09.13.    |💥 `configureCell` 메서드 매개변수 타입 변경 <br>💥 `Shareable` 프로토콜 제네릭 타입으로 변경 <br>|
| 2023.09.14.    |✴️ `WeatherAPI` 생성 및 `API KEY` 숨기기 <br> ✴️ `NetworkManager` 생성 및 `fetchWeather`메서드 구현 <br> ✴️ `decodeData` 메서드 구현 및 모델 생성<br> ✴️ `CoreLocation`기반 위치정보 가져오기 구현<br>  |
| 2023.09.15.    |💥 `prepareForReuse` 메서드 수정<br> 💥 `CacheStore`로 네이밍 변경<br> 💥 `NetworkAPI` 수정 <br> ✴️ `NetworkAPI` 생성 <br>  💥 `Cell` 재사용을 위한 초기화 및 날씨 icon autolayout 수정 <br> ✴️  `CoreData` 마이그레이션 및 `fetchIconImage` 메서드 추가<br> |
| 2023.09.16.    |✴️ `showToast` 메서드 생성 <br> 💥 `if let`으로 수정하여 가독성 향상 <br> 🖨️ 스토리보드 삭제 <br> |
</details>


---

</br>
