# README

# 📒 Diary 

CoreData를 이용해 기록을 남기는 일기장 어플입니다.

- 새로운 일기를 저장할 수 있습니다. 
	- 자동 저장기능을 지원합니다. 
- 저장된 일기를 확인 / 수정 / 공유 / 삭제 할 수 있습니다.
	- 가장 최근순으로 저장된 일기리스트를 확인 할 수 있습니다.
	- 저장된 일기를 터치해 확인하는 화면에서 수정이 가능합니다.
	- 수정내용을 자동 저장하는 기능을 지원합니다.
	- 일기를 복사하거나 외부 SNS로 공유하는 내보내기 서비스를 지원합니다.
	- 리스트 목록에서 Swipe하거나 상세화면의 버튼을 이용해 공유/삭제 할 수 있습니다.
- 가로모드를 지원합니다
    - 큰 기기의 가로모드에서도 사용자가 읽기 편안한 컨텐츠 레이아웃을 제공합니다.

## 📖 목차
1. [팀 소개](#-팀-소개)
2. [기능 소개](#-기능-소개)
3. [Class Diagram](#-class-diagram)
4. [폴더 구조](#-폴더-구조)
5. [프로젝트에서 경험하고 배운 것](#-프로젝트에서-경험하고-배운-것)
6. [타임라인](#-타임라인)
7. [고민한 부분](#-고민한-부분)
8. [트러블 슈팅](#-트러블-슈팅)
9. [참고 링크](#-참고-링크)

---

## 🌱 팀 소개
 |[써니쿠키](https://github.com/sunny-maeng)|[LJ](https://github.com/lj-7-77)|
 |:---:|:---:|
|<img width="180px" img style="border: 2px solid lightgray; border-radius: 90px;-moz-border-radius: 90px;-khtml-border-radius: 90px;-webkit-border-radius: 90px;" src="https://avatars.githubusercontent.com/u/107384230?v=4">| <img width="180px" img style="border: 2px solid lightgray; border-radius: 90px;-moz-border-radius: 90px;-khtml-border-radius: 90px;-webkit-border-radius: 90px;" src="https://i.imgur.com/ggU7PLR.jpg">|

---

## 🛠 기능 소개
<details>
<summary>[Step1 - 다이어리 리스트 화면, 상세화면] </summary>

| **다이어리 리스트 화면** | 
| :-------------------------------------------: | 
| <img src = "https://i.imgur.com/m8kSEaS.gif"> |
**다이어리 상세 화면** |
| <img src = "https://i.imgur.com/G7qLxH3.gif"> |

</details> </br>

**Step2 - 다이어리 CRUD**
| **생성** | **읽기** | **수정** |
| :---: | :---: | :---: |
| <img src = "https://i.imgur.com/M9rvhco.gif"> | <img src = "https://i.imgur.com/sqZlb0s.gif"> | <img src = "https://i.imgur.com/hic34ow.gif"> |

| **삭제** | **공유,취소** | **스와이프** |
| :---: | :---: | :---: |
| <img src = "https://i.imgur.com/zb96B1F.gif">  | <img src = "https://i.imgur.com/I7r5Ysy.gif">  | <img src = "https://i.imgur.com/biRoxz9.gif">  |





---

## 👀 Class Diagram
| **Model** | 
| :-------------------------------------------: | 
|![](https://i.imgur.com/mHxETWs.png)|

| **ViewController** | 
| :-------------------------------------------: | 
|![](https://i.imgur.com/WGJpDzm.png)|

---

## 🗂 폴더 구조
```
Diary
├── AppDelegate
├── SceneDelegate
├── Diary.xcdatamodeld
│   └── Diary.xcdatamodel
├── Model
│   ├── CoreDataManager
│   ├── Date+Extension
│   └── DiaryPage
├── View
│   ├── CustomUI
│   ├── DiaryCell
│   ├── DiaryDetailView
│   └── DiaryListView
└── ViewController
│   ├── CustomActivityViewController
│   ├── DiaryDetailViewController
│   ├── DiaryListViewController
│   └── RegisterDiaryViewController
└── Info.plist
```

---

## ✅ 프로젝트에서 경험하고 배운 것
- 스토리보드없이 코드로만 View구현하기
	 - [X] 스토리보드를 삭제하고 SceneDelegate를 수정해 navigationController가 embeded된 View를 구현했습니다.
- swiftLint 라이브러리 사용하기
	 - [X] pod 을 이용해 라이브러리를 적용했습니다.
	 - [X] `swiftLint` 라이브러리로 코드컨벤션을 통일했습니다. 
- modernCollectionView를 이용한 List구현
	 - [X] `UICollectionViewCompositionalLayout.list`를 이용해 ListView 구현했습니다.
     - [X] DiffableDataSource, snapShot을 이해하고 적용했습니다.
- readableContentGuide 사용하기
     - [X] app adaptivity 및 가로모드의 레이아웃에 readableContentGuide를 사용했습니다.
- CoreData 사용하기 
	 - [X] CoreData 모델을 생성했습니다.
	 - [X] CRUD 메서드를 구현했습니다.
	 - [X] 코어데이터를 다루는 모델을 싱글톤으로 구현했습니다.
- 상속으로 등록/수정 과정의 공통기능을 구현
	 - [X] VC1와 공통기능을 갖는 VC2를 Class상속을 통해 구현했습니다.
- 컬렉션뷰 리스트에서 스와이프를 액션 구현
	 - [X] 테이블뷰에서 스와이프로 데이터를 공유/삭제합니다.
- Text View Delegate의 활용
	 - [X] TextView의 변화를 감지해 PlaceHolder를 설정합니다.

---

## ⏰ 타임라인

| 🕛 Step 1|  |
| :--------: | -------- |
| 1 | `SwiftLint` 활용 |
| 2 | DTO구현 - JSON 데이터와 매핑할 `Diary` 타입 구현 | 
| 3 | 일기장 목록화면 구현, 일기장 영역화면 UI구현, readableContentGuide 적용&nbsp;&nbsp;&nbsp;  | 
<details>
<summary>[Details - Step1 타입별 기능 설명] </summary>

#### 1️⃣ DTO - `Diary` 구조체
- JSON파일(sample.json)을 decode하기위한 DTO(데이터전송객체) 입니다.

#### 2️⃣ `DiaryListViewController` 클래스
- 일기장 목록화면인 DiaryListView를 담당하는 뷰컨트롤러입니다.
- collectionView(collectionView:didSelectItemAt:) : UICollectionViewDelegate프로토콜을 채택하여 목록 중 하나의 항목을 선택했을 때 다음화면으로 전환하는 메서드입니다.
    
#### 3️⃣ `DiaryDetailViewController` 클래스
- 일기장 목록 중 하나의 일기상세화면인 DiaryDetailView를 담당하는 뷰컨트롤러입니다.
-`configureDiary()`메서드
    일기상세화면에 제목,내용,일자 각각 항목별 데이터를 바인딩하는 메서드입니다.
- `setupNotification()`메서드
    키보드가 보이거나 숨겨질 때의 노티피케이션에 Observer를 추가해서 controlKeyboard() 메서드를 호출합니다.

</details> </br> </br>

| 🕛 Step 2|   |
| :--------: | -------- |
| 1 | CoreData 모델 생성 |
| 2 | 일기장 CRUD기능(자동저장, 읽기, 수정, 삭제) 구현&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; | 
| 3 | 컬렉션뷰 리스트에서 스와이프를 액션 구현 | 
| 4 | Text View Delegate의 활용 | 

[Details - Step2 타입별 기능 설명]

#### 1️⃣ `CoreDataManager` 구조체
- CRUD 기능별 메서드 구현
- `deleteAllNoDataDiaries()`메서드
    새로운 일기 생성 후 아무것도 입력하지 않았을 경우, 저장 후 fetch해올 때 삭제합니다.
- `searchDiary(id:)`메서드
    수정 시 해당 일기만 찾아 데이터를 가져옵니다.
    
#### 2️⃣ `RegisterDiaryViewController` 클래스
- 새로운 일기화면으로 내용없이 PlaceHolder만 입력되어있는 상태의 `DiaryDetailView`를 담당합니다.
    
#### 3️⃣ `DiaryDetailViewController` 클래스
- `RegisterDiaryViewController` 클래스를 상속받습니다.
- 이미 작성한 일기내용이 입력되어있는 상태의 `DiaryDetailView`를 담당합니다.

#### 4️⃣ `CustomActivityViewController` 클래스
- 공유 시 뷰 하단에서 올라오는 `ActivityView`를 담당하는 컨트롤러입니다.



---

## 💭 고민한 부분
### 1️⃣ 키보드가 나타나고 사라질 때, 컨텐츠를 가리지않도록 하는 방법
- 1. **ScrollView 이용**
	- 키보드가 나타날 때, 좁아진 화면으로도 스크롤 해서 가려진 화면을 볼 수 있도록 `ScrollView`에 컨텐츠들을 담았습니다.
- 2. **ScrollView의 inset, offset 조정**
	- 키보드가 나타나고 화면을 스크롤 할 때 컨텐츠의 가장 밑부분이 키보드 뒤에 가려지는 문제를 해결하기 위해, 스크롤뷰가 나타날 때의 Notification을 받아 ScrollView의 Bottom방향으로 키보드 높이만큼의 `Inset`을 더하도록 했습니다. 더불어 사용자가 보고있던 화면을 유지하기위해 `offset.y`도 키보드의 높이만큼 빼줍니다.
	- 키보드가 사라질 때는 반대로 `Inset`을 삭제합니다. 
- 3. **입력이 끝나고 키보드를 내리기위한 `keyboardDismissMode` 속성 사용**
	- 사용자가 입력을 끝내고 키보드를 내리는 방법으로 UIScrollView의 `keyboardDismissMode` 속성을 사용해 사용자가 스크롤하여 키보드를 다시 내릴 수 있도록 구현했습니다.
	
### 2️⃣ 상속으로 공통기능 구현시, 주요 프로퍼티에 접근제어(private)를 설정해주기 위해 이니셜라이저에서 데이터를 갈아끼우는 로직 구현
- `RegisterDiaryViewController`(다이어리 등록화면 VC)를 상속받는 `DiaryDetailViewController`(다이어리 수정화면 VC)를 구현하면서 필수로 `private`으로 설정해주어야 할 프로퍼티들에 접근제어를 설정할 수 없는 문제가 있었습니다. VC 두 개가 똑같이 `diaryPageView`, `diaryPage` 데이터를 갖고있는데 외부에서 접근할 수 없게 `Private`설정을 해주어야 했습니다.
- 상속받은 프로퍼티를 사용하지 않고 새로운 프로퍼티를 생성해서 사용하게되면, 이 프로퍼티들을 사용하는 메서드들을 모두 `override`해서 새로 생성한 프로퍼티를 사용할 수 있도록 모두 `override`후 재구현 해야 했습니다.
- 이니셜라이저에서 해답을 얻었습니다. 이니셜라이저에서 데이터를 갈아끼우는 로직을 구현하니 프로퍼티는 인스턴스생성시 바뀌기 때문에 Private 접근제어를 설정할 수 있고, 상속받은 메서드들은 override없이 사용할 수 있었습니다. 

### 3️⃣ 데이터가 없는 페이지는 자동 삭제되는 로직
- 처음엔 다이어리 등록 시 작성내용이 있는지 확인한 후 저장을 결정하는 로직을 구현하려했는데, 저장할때도 확인해야하고, 한글자를 써서 이미 저장이 된 데이터들에 대해서는 업데이트시 확인 후 삭제해야하고, 등록화면 뿐 아니라 이미 저장된 다이어리를 보는 화면에서도 내용을 모두 지우면 업데이트가 아닌 삭제를 해야해야하는 번거로움이 있어 일단 데이터가 없는 페이지도 자동저장 된 후 `fetch`해 올 때(저장된 리스트를 보여줄 때) 빈 값의 데이터를 자체적으로 삭제한 후 `fetch`하는 로직으로 구현했습니다.


## 🚀 트러블 슈팅

### 1️⃣ DiffableDataSource사용할 때, Value값이 똑같은 데이터로 인한 문제 해결
- 프로젝트에 포함된 견본 JSON 데이터를 사용해 List Cell을 구성할 때, 값이 같은 데이터가있어 정상작동 되지않는 문제가 있었습니다.
- 원인: Diffable datasource를 사용하려면 `ItemIdentifier`가 각각 고유한 Hash값을 갖고 있어야하는데 아래 캡쳐 화면 처럼 value가 완전히 같을 때는 두 개가 같은 Hash값을 갖기 때문입니다.
	![](https://i.imgur.com/PpWdKev.jpg)
	</br>
- **✅ 수정: UUID 사용**
	- DTO에 `UUID`를 생성해 각 value들이 각각 고유한 Hash값을 갖도록 했습니다.
		```swift
		struct Diary: Decodable, Hashable {
			let title: String
			let body: String
			let createdAt: Double
			let id = UUID() // 👈
			// ...
		}
		```

### 2️⃣ 일기장 목록의 셀 높이 조절 문제 해결 
- `DiaryCell`에 `configureDiaryCellLayout()`메서드에서 AutoLayout Constraints 설정 시 일기 제목과 작성일 등의 Label을 담은 `totalStackView`의 `Constraints`를 `self`를 기준으로 했을 때 의도한대로 셀높이가 조절되지 않았습니다.

  | 수정 전| 수정 후  |
  | :--------: | -------- |  
  | <img height = 400 src = "https://i.imgur.com/I73XrwP.png"> | <img height = 400 src = "https://i.imgur.com/S6m4APA.png"> |

- **✅ 수정: `LayoutConstraint`을 `contentView`에 걸어주기**
	- `LayoutConstraint`을 `self(DiaryCell)`이 아닌 `contentView`를 기준으로 `topAnchor`와 `bottomAnchor`에 `constant`값을 주어 해결하였습니다.

### 3️⃣ TextView PlaceHolder 설정 방법
- PlaceHolder를 TextView.text 속성으로 "일기 제목", "일기 내용" 과같은 PlaceHolder를 만들고  `textViewDidBeginEditing`메서드로 값이 바뀌었을 때, PlaceHolder가 지워지는 로직을 구현했을 때 아래와 같은 문제가 있었습니다.
	- 코어데이터에 데이터 저장 시 입력값이 없을 때도 입력되어있는 PlaceHolder인 "일기 제목", "일기 내용"을 Text로 인식해 저장되는 문제가 있었습니다.
	- 화면전환 시 키보드를 바로 띄우기 위해 TitleTextView를 FirstResponder로 지정해놓으니 `textViewDidBeginEditing` 메서드가 호출되어 PlaceHolder가 보이지 않는 문제가 있었습니다.
	- `textViewDidBeginEditing`대신, `textViewDidChange`로 값이 하나라도 적힐 때 PlaceHolder가 제거되는 로직으로 변경하면 PlaceHolder는 화면에 보이지만 타자커서가 PlaceHolder 뒤쪽에 위치하는 문제가 있었습니다.
- **✅ 수정: Label사용**
	- UILabel인 `titlePlaceHolder`와 `bodyPlaceHolder`를 만들어 TextView에 추가해 보이게 하고 UITextViewDelegate의 `textViewDidChange`메서드로 추가된 Label이 삭제되도록 수정해 해결했습니다. 
	- Label 사용시, 입력값이 없을 때에 저장되는 데이터의 값도 빈값으로 정상 저장되고, 화면전환시 FirstResponder여도 PlaceHolder가 잘 보이고, 커서의 위치도 정상적으로(제일 앞쪽에) 위치합니다.

---

## 🔗 참고 링크

[공식문서]
- [Implementing Modern Collection Views](https://developer.apple.com/documentation/uikit/views_and_controls/collection_views/implementing_modern_collection_views)
- [UICollectionViewDiffableDataSource](https://developer.apple.com/documentation/uikit/uicollectionviewdiffabledatasource/)
- [Setting Up a Core Data Stack](https://developer.apple.com/documentation/coredata/setting_up_a_core_data_stack)
- [readableContentGuide](https://developer.apple.com/documentation/uikit/uiview/1622644-readablecontentguide/)
- [DateFormatter](https://developer.apple.com/documentation/foundation/dateformatter)
- [UITextViewDelegate](https://developer.apple.com/documentation/uikit/uitextviewdelegate/)
- [UISwipeActionsConfiguration](https://developer.apple.com/documentation/uikit/uiswipeactionsconfiguration/)
