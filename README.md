# README

# 📒 Diary 

CoreData를 이용해 기록을 남기는 일기장 어플입니다.

- 작성해놓은 일기장 리스트를 확인할 수 있습니다. 
- 리스트 항목 터치 시 일기페이지를 확인 및 수정할 수 있습니다.

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
| **다이어리 리스트 화면** | 
| :-------------------------------------------: | 
| <img src = "https://i.imgur.com/m8kSEaS.gif"> |
**다이어리 상세 화면** |
| <img src = "https://i.imgur.com/G7qLxH3.gif"> |

---

## 👀 Class Diagram
| **Model** | 
| :-------------------------------------------: | 
|![](https://i.imgur.com/MzZ8I0k.png)|

| **ViewController** | 
| :-------------------------------------------: | 
|![](https://i.imgur.com/RDRDloO.png)|

---

## 🗂 폴더 구조
```
Diary
├── AppDelegate
├── SceneDelegate
├── Model
│   ├── Date+Extension
│   ├── DecodeManager
│   └── Diary
├── View
│   ├── CustomUI
│   ├── DiaryCell
│   ├── DiaryDetailView
│   └── DiaryListView
└── ViewController
│     ├── DiaryDetailViewController
│     ├── DiaryListViewController
│     └── RegisterDiaryViewController
├── Info.plist
└── SwiftLint
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

---

## ⏰ 타임라인

| 🕛 Step 1|  |
| :--------: | -------- |
| 1 | `SwiftLint` 활용 |
| 2 | DTO구현 - JSON 데이터와 매핑할 `Diary` 타입 구현 | 
| 3 | 일기장 목록화면 구현, 일기장 영역화면 UI구현, readableContentGuide 적용  | 
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

</details>

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

---

## 🔗 참고 링크

[공식문서]
- [Implementing Modern Collection Views](https://developer.apple.com/documentation/uikit/views_and_controls/collection_views/implementing_modern_collection_views)
- [UICollectionViewDiffableDataSource](https://developer.apple.com/documentation/uikit/uicollectionviewdiffabledatasource/)
- [readableContentGuide](https://developer.apple.com/documentation/uikit/uiview/1622644-readablecontentguide/)
- [DateFormatter](https://developer.apple.com/documentation/foundation/dateformatter)
