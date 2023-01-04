# 📔 일기장
> 프로젝트 기간: 2022-12-19 ~ 2023-01-06 (3주)

## 🗒︎목차
1. [소개](#-소개)
2. [개발환경 및 라이브러리](#-개발환경-및-라이브러리)
3. [팀원](#-팀원)
4. [타임라인](#-타임라인)
5. [파일구조](#-파일구조)
6. [UML](#-uml)
7. [실행화면](#-실행-화면)
8. [트러블 슈팅 및 고민](#-트러블-슈팅-및-고민)
9. [참고링크](#-참고-링크)

---

## 👋 소개
- 코어데이터를 활용해 데이터를 구축하고, UI를 구현해 일기장 애플리케이션을 제작하는 프로젝트 입니다.
- 코어데이터, UICollectionView 개념을 기반으로 제작되었습니다.

---

## 💻 개발환경 및 라이브러리
[![swift](https://img.shields.io/badge/swift-5.6-orange)]()
[![iOS](https://img.shields.io/badge/iOS_Deployment_Target-14.0-blue)]()

---

## 🧑 팀원
|애쉬|애종|
|:---:|:---:|
|<img src= "https://avatars.githubusercontent.com/u/101683977?v=4" width ="200">|<img src = "https://i.imgur.com/HWcJ7i7.jpg" width=200 height=200>|


---

## 🕖 타임라인

### STEP1
- 22.12.20
  - [![feat](https://img.shields.io/badge/feat-green)]() swiftLint 적용 
  - [![feat](https://img.shields.io/badge/feat-green)]() ViewController 정의 
  - [![feat](https://img.shields.io/badge/feat-green)]() CollectionViewCell의 `configureContents()` 메서드 추가
  - [![feat](https://img.shields.io/badge/feat-green)]() JSON데이터를 담을 Diary 타입 정의

- 22.12.21
  - [![feat](https://img.shields.io/badge/feat-green)]() ErrorType 타입 정의 및 알럿으로 에러 처리 기능 추가 
  - [![feat](https://img.shields.io/badge/feat-green)]() addDiaryView에서 키보드가 올라올 때 화면이 같이 올라가는 기능 구현
  - [![refactor](https://img.shields.io/badge/refactor-blue)]() 접근제어자 추가 및 AddDiaryView 내 ScrollView 삭제 

- 22.12.22
  - [![refactor](https://img.shields.io/badge/refactor-blue)]() AddKeyboardNotification 프로토콜 정의 및 DiaryListViewController가 해당 프로토콜 준수하도록 리팩토링 
  - [![refactor](https://img.shields.io/badge/refactor-blue)]() collectionView가 오토리사이징 마스크가 아닌 오토레이아웃 제약을 사용하도록 수정 
  - [![refactor](https://img.shields.io/badge/refactor-blue)]() ErrorType -> DiaryError로 리네이밍 
  - [![feat](https://img.shields.io/badge/feat-green)]() ErrorAlert 타입 정의

- 22.12.23
  - [![docs](https://img.shields.io/badge/docs-yellow)]() STEP1 `README.md` 업데이트
  - [![docs](https://img.shields.io/badge/docs-yellow)]() swiftLint 파일 참조 제거
  - [![refactor](https://img.shields.io/badge/refactor-blue)]() 코딩 컨벤션 정리 및 접근 제어자 수정
  - [![refactor](https://img.shields.io/badge/refactor-blue)]() JSON data `decode()` 메서드가 Result 타입을 반환하도록 수정

### STEP2
- 22.12.27
  - [![feat](https://img.shields.io/badge/feat-green)]() 코어 데이터를 추가하는 메서드 추가
  - [![feat](https://img.shields.io/badge/feat-green)]() 코어 데이터를 가져오는 메서드 추가
  - [![feat](https://img.shields.io/badge/feat-green)]() editView 추가 및 테이블뷰 셀 클릭시 화면 전환 기능 추가
  - [![feat](https://img.shields.io/badge/feat-green)]() 일기장 추가 및 편집 기능 구현

- 22.12.28
  - [![feat](https://img.shields.io/badge/feat-green)]() `CoreDataManager` 타입 정의
  - [![feat](https://img.shields.io/badge/feat-green)]() View가 AddKeyboardNotification 프로토콜을 준수하도록 수정
  - [![feat](https://img.shields.io/badge/feat-green)]() 가장 최신 코어 데이터를 불러오는 `fetchLastObject()` 메서드 추가
  - [![feat](https://img.shields.io/badge/feat-green)]() 코어 데이터를 삭제하는 메서드 추가
  - [![feat](https://img.shields.io/badge/feat-green)]() background로 전환 시 자동저장 기능 구현

- 22.12.29
  - [![feat](https://img.shields.io/badge/feat-green)]() 컬렉션뷰 셀 swipe 시 공유 및 삭제 기능 추가
  - [![feat](https://img.shields.io/badge/feat-green)]() editView에 더보기 버튼 추가 / 공유 및 삭제 액션 시트 추가
  - [![refactor](https://img.shields.io/badge/refactor-blue)]() 코딩 컨벤션 통일 및 접근 제어자 설정

- 22.12.30
  - [![docs](https://img.shields.io/badge/docs-yellow)]() STEP2 `README.md` 업데이트


---

## 💾 파일구조
```
Diary
├── Model
│   ├── DiaryModel
│   ├── Diary+CoreDataClass
│   ├── Diary+CoreDataProperties
│   ├── ErrorAlert
│   └── CoreDataManager
├── View
│   ├── ListCollectionViewCell
│   ├── DiaryView
│   └── EditDiaryView
├── Controller
│   ├── DiaryListViewController
│   └── EditDiaryViewController
├── Extensions
│   ├── AddKeyboardNotification
│   ├── DateFormatter+Extension
│   ├── Double+Extension
│   └── ViewController+Extension
└── Errors
    └── DiaryError 
```

---

## 📊 UML
![](https://i.imgur.com/zmIIWRi.jpg)


---

## 💻 실행 화면
### STEP1
| 메인 일기장 화면 | 일기 추가 화면 | 키보드 표시/숨김 기능 |
|:----:|:----:|:----:|
|![일기장 - 메인 일기장 화면](https://i.imgur.com/jwZvR30.png)|![일기장 - 일기 추가 화면](https://i.imgur.com/uw41pJN.gif)|![일기장 - 키보드 표시/숨김 기능](https://i.imgur.com/LjQgJEc.gif)|

| [가로 모드] 메인 화면 | [가로 모드] 일기 추가 화면 |
|:----:|:----:|
|![메인일기장 화면 - 가로모드](https://i.imgur.com/2Wk06zm.png)|![일기장 추가 화면 - 가로모드](https://i.imgur.com/qePeOGP.png)|

### STEP2
- 자동 저장 기능

| 백그라운드 전환 시 | 이전 화면 이동 시 |
|:----:|:----:|
|![백그라운드 전환 시 자동 저장](https://i.imgur.com/hATfgFS.gif)|![이전 화면 이동 시 자동 저장](https://i.imgur.com/Wflyf8J.gif)|

- 공유 및 삭제 기능

| 공유 기능 | 삭제 기능 |
|:----:|:----:|
|![더보기 버튼으로 공유](https://i.imgur.com/SdAAE0z.gif)|![삭제 기능](https://i.imgur.com/gj9PcpE.gif)|

---

## 🎯 트러블 슈팅 및 고민

<details>
<summary><b>1. 사용자의 지역포맷에 따라 날짜를 표현하는 방법에 대한 고민</b></summary>
<div markdown="1">

- 유저의 언어 설정에 접근하는 방법을 사용해 Locale을 설정하고, 해당 Locale로 지역화된 날짜를 표시할 수 있도록 하였습니다.

```swift
let localeLanguage = Locale.preferredLanguages.first
DateFormatter().locale = Locale(identifier: localeLanguage ?? "ko-kr")
```

</div>
</details>
</br>

<details>
<summary><b>2. textView에서 사용자가 입력하는 부분이 키보드에 가려지는 문제</b></summary>
<div markdown="1">
    
 - 해당 문제를 해결하기 위해 총 3가지 방법을 시도해보았습니다.
    - view의 frame.y 를 이동시키기
      첫 번째 view의 frame을 올라가도록 변경하니 textView의 text가 네비게이션 바를 가려 이 방법은 적합하지 않다고 생각했습니다.
    - keyboardLayoutGuide 적용하기
        ```swift
        view.scrollView.bottomAnchor.constraint(equalTo: view.keyboardLayoutGuide.topAnchor, 
                                            constant: -10)
        ```
        위의 방법으로 비교적 간단하게 구현할 수 있었지만 iOS15버전부터 사용가능하기 때문에 다른 방법을 통해서도 해당기능을 구현할 줄 알아야 된다고 생각했습니다.
 - textView의 contentInset 변경하기
    - 현재 저희 코드에서 사용한 방법입니다. notification center를 통해 키보드가 나타날 때 키보드의 높이를 구하고, textView아래에 키보드의 높이만큼 여백을 추가해줬습니다.

</div>
</details>
</br>

<details>
<summary><b>3. 일기 추가 화면으로 전환시 textView 상단의 일부가 가려져서 보이는 문제</b></summary>
<div markdown="1">
    
  - 기존에는 아래 이미지와 같이 일기 추가 화면으로 전환했을 때, textView의 상단이 가려진 채로 전환되는 문제가 있었습니다.
    ![](https://i.imgur.com/b2lxdRL.png)
  - 해당 문제에 대해 확인해보니 UITextView는 기본값으로 마진을 가지고 있다는 것을 공식문서에서 확인할 수 있었습니다.
    ```swift
    This property provides text margins for text laid out in the text view. By default the value of this property is (8, 0, 8, 0).
    ```
  - 마진을 제거하기 위해 아래의 코드를 사용해 문제를 해결했습니다.
    ```swift
    self.textView.textContainerInset = .zero
    ```

</div>
</details>

</br>
<details>
<summary><b>4. Core Data를 사용해 일기를 읽기, 저장, 수정, 삭제 하기</b></summary>
<div markdown="1">
    
  - `CoreDataManager`객체를 통해 CoreData에 접근 및 CRUD 기능 구현
    - 싱글톤 패턴으로 구현해 원하는 곳에서 CoreData Managing 가능
    - `DiaryModel`이라는 데이터 모델을 사용해 CoreData에 직접 접근하지 않고 데이터 관리
    - `MangedObjectID`라는 고유한 값 사용해 각 데이터를 구분 및 원하는 데이터의 수정, 삭제 가능
        - *context.existingObject(with: objectID)*

</div>
</details>
</br>

<details>
<summary><b>5. + 버튼을 눌러 일기장을 생성하고 편집화면에서 일기장을 편집</b></summary>
<div markdown="1">
    
- 결국 일기를 쓰는 페이지에서는 update만 동작
- `+` 버튼 터치시 
```swift
CoreDataMananger.shared.insertDiary(DiaryModel()) // 빈 일기장 추가, ID는 nil
    
let currentDiaryModel = try CoreDataMananger.shared.fetchLastObject() // CoreData에 방금 추가된 일기 fetch(objectID 존재)
let editDiaryViewController = EditDiaryViewController(diaryModel: currentDiaryModel) // 일기를 편집하는 뷰컨트롤에 DiaryModel 타입으로 주입
self.navigationController?.pushViewController(editDiaryViewController, animated: true)
```

</div>
</details>
</br>

<details>
<summary><b>6. Core Data의 NSManagedObject 객체를 가져오는 방법에 대한 문제 </b></summary>
<div markdown="1">

- Core Data의 CRUD 기능을 구현하기 위해 구글링을 통해 여러 코드를 확인하였습니다. 
대부분 아래와 같은 순서로 객체를 가져오고 있었습니다.
  1. fetchRequest()로 Core Data를 모두 fetch해온다.
  2. title과 같은 특정 프로퍼티 값이 동일하면 해당 데이터로 특정한다.
- 하지만, 데이터를 update하고 delete할 때마다 모든 데이터를 fetch하고 그 중 프로퍼티 값이 동일한 객체를 불러오는 것이 좋은 로직은 아니라고 생각했습니다.
- NSManagedObjectID를 기준으로 특정 데이터를 불러올 수 있는 `existingObject(with:)` 메서드를 알게 되어 해당 메서드를 통해 아래와 같은 코드를 구현하게 되었습니다.

```swift
// 특정 다이어리 데이터 삭제 시 호출되는 코드의 일부분
guard let diaryID = diaryModel.id,
  let item = try self.context.existingObject(with: diaryID) as? Diary else { return }

  self.context.delete(item)
```
</div>
</details>
</br>

    
---

## 📚 참고 링크
- [Adaptivity and Layout](https://developer.apple.com/design/human-interface-guidelines/ios/visual-design/adaptivity-and-layout/)
- [공식문서 - DateFormatter](https://developer.apple.com/documentation/foundation/dateformatter)
- [wwdc2019 - Localization](https://developer.apple.com/videos/play/wwdc2019/403/)
- [공식문서 - Core Data](https://developer.apple.com/documentation/coredata)
  - [Creating a Core Data Model](https://developer.apple.com/documentation/coredata/creating_a_core_data_model)
  - [Setting Up a Core Data Stack](https://developer.apple.com/documentation/coredata/setting_up_a_core_data_stack)
- [Core Data CRUD 구현 시 참고한 글](https://velog.io/@leeesangheee/Core-Data-%EC%82%AC%EC%9A%A9%ED%95%B4-CRUD-%EA%B5%AC%ED%98%84%ED%95%98%EA%B8%B0)
- [의존성 주입에 관한 글](https://silver-g-0114.tistory.com/143)
