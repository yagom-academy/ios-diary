# 다이어리

## 프로젝트 소개
일기장을 만들어 일기를 관리해본다.

> 프로젝트 기간: 2022-08-16 ~ 2022-09-02</br>
> 팀원: [휴](https://github.com/Hugh-github), [데릭](https://github.com/derrickkim0109) </br>
리뷰어: [콘](https://github.com/protocorn93)</br>


## 📑 목차

- [🧑🏻‍💻🧑🏻‍💻 개발자 소개](#-개발자-소개)
- [⏱ TimeLine](#-TimeLine)
- [💡 키워드](#-키워드)
- [🤔 핵심경험](#-핵심경험)
- [📱 실행 화면](#-실행-화면)
- [🗂 폴더 구조](#-폴더-구조)
- [📝 기능설명](#-기능설명)
- [🚀 TroubleShooting](#-TroubleShooting)
- [📚 참고문서](#-참고문서)


## 🧑🏻‍💻🧑🏻‍💻 개발자 소개

|Hugh|데릭|
|:---:|:---:|
||<image src = "https://avatars.githubusercontent.com/u/59466342?v=4" width="250" height="250">
|[Hugh](https://github.com/Hugh-github)|[데릭](https://github.com/derrickkim0109)|

## ⏱ TimeLine

### Week 1
    
> 2022.08.16 ~ 2022.08.19
    
- 2022.08.16 
    - JSON 파일을 처리하는 타입 
    - JSON Data 받을 Model 타입
    - Unit Test 작성

- 2022.08.17
    - DateFormatter로 현재 날짜 구현
    - TextView에서 Keyboard 호출 시 키보드 높이에 맞게 설정
    - Step01 PR
    
- 2022.08.18
    - SwiftLint 설정
    
- 2022.08.19
    - Step01 리팩토링
    
### Week 2
    
> 2022.08.22 ~ 2022.08.26
    
- 2022.08.22 
    - MVVM에 대한 공부
    - NotificationCenter를 활용한 데이터 전환
    - CoreData CRUD
    
- 2022.08.23
    - 객체 지향에 대한 책 읽기 
    
- 2022.08.24
    - AlertView 
    - Activity View
    - Navigation Bar Button
    - TableView 스와이프를 통한 삭제 기능
    
- 2022.08.25
    - Navigation Bar Done Button 버튼 추가
    - 저장 로직 에러 수정 
    - Step02 PR
    
- 2022.08.26
    - 객체 지향에 대한 책 읽기 
    
## 💡 키워드

- `DateFormatter`, `UITableViewDiffableDataSource`, `UITableView`, 
    `UITextView`, `Date`, `JSON`, `AlertViewController`, `CoreData`,     `CRUD`, `Activity View`, `Navigation Bar Button` 
    
## 🤔 핵심경험

- [x] Date Formatter의 지역 및 길이별 표현의 활용
- [x] Text View의 활용
- [x] 코어데이터 모델 생성
- [x] 코어데이터 모델 및 DB 마이그레이션
- [x] 테이블뷰에서 스와이프를 통한 삭제기능 구현
- [ ] Text View Delegate의 활용
- [ ] Open API의 활용
- [ ] Core Location의 활용

## 📱 실행 화면

|일기장 List 화면|일기장 화면|일기장 작성 화면|키보드 구현|
|:--:|:--:|:--:|:--:|
|![](https://i.imgur.com/uoXp233.gif)|![](https://i.imgur.com/ikYAfoW.gif)|![](https://i.imgur.com/NtY72xL.gif)|![](https://i.imgur.com/oDd8BZH.gif)|

|일기장 생성|일기장 수정|키보드 사라짐|
|:--:|:--:|:--:|
|![](https://i.imgur.com/PulaOBC.gif)|![](https://i.imgur.com/4G7BY6L.gif)|![](https://i.imgur.com/Ampe36t.gif)|
    

|Shared|Delete|Swipe Delete|백그라운드 저장|
|:--:|:--:|:--:|:--:|
|![](https://i.imgur.com/LkU2vHk.gif)|![](https://i.imgur.com/ia4ZKUB.gif)|![](https://i.imgur.com/qEBa0vo.gif)|![](https://i.imgur.com/9PhyqAa.gif)|

    
## 🗂 폴더 구조

```
└── Diary
    ├── Diary.xcdatamodeld
    ├── Application
    │   ├── AppDelegate
    │   └── SceneDelegate
    ├── ViewModel
    │   └── DiaryViewModel
    ├── View
    │   ├── DiaryPost
    │   │   └── DiaryPostViewController
    │   ├── DiaryContent
    │   │   └── DiaryContentViewController
    │   └── DiaryList
    │       ├── DiaryListViewController
    │       └── DiaryTableViewCell
    ├── Model
    │   └── DiaryContent
    ├── JSON
    │   ├── JSONManager
    │   └── JSONError
    ├── Extensions
    │   ├── TimeInterval+Extensions
    │   ├── Date+Extensions
    │   └── UITextView+Extensions
    ├── Resources
    │   ├── Assets
    │   ├── LaunchScreen
    │   └── Info
    └── DiaryTests
        └── DiaryTests
```

    
## 📝 기능설명

**일기장 UI 구현**
- TableView
    - 스와이프를 이용해 list 제거 기능 제공
- StackView
- TextView
    - 키보드 길이에 맞게 TextView 높이 조절 기능 제공

**화면 전환시 데이터 전달**
- 변수를 사용해 데이터 전달
    
**일기장 화면의 Text View & 키보드**
- 현재 커서로 textView를 클릭하는 위치가 키보드에 가려지지 않도록 구현
- 현재 사용자가 작성하는 부분은 화면에 보이도록 구현
    
**일기장 데이터 저장**
- 백그라운드 진입시 
- Content View에서 뒤로가기
- 사용자가 입력을 멈추는 경우(키보드가 사라지는 경우) - 완료 버튼 클릭시
    
**일기장 Navigation Bar Button Item**
- ellipsis 버튼 (**⋯**) : 해당 텍스트를 공유하는 화면과 삭제 기능을 제공 
- 완료 버튼 : 키보드로 내용 입력 후 완료 버튼 클릭 시 키보드 내림 기능 제공 

## 🚀 TroubleShooting
    
### STEP 1

#### T1. `UITableViewDiffableDataSource`의 사용방법
    - 데이터를 snapshot에서 받아 UI Update가 작동해야하는 상황이나 데이터를 받지 못해서 발생한 문제
    
```swift 
    private func fetchData() {
    let fileName = "diarySample"
    let result = jsonManager.checkFileAndDecode(dataType: [DiaryContent].self, fileName)

    switch result {
    case .success(let contents):
        diaryContents = contents
        updateDataSource(data: contents)
    case .failure(_):
        break
    default:
        break
    }
}

private func updateDataSource(data: [DiaryContent]) {
    var snapshot = NSDiffableDataSourceSnapshot<Section, DiaryContent>()
    snapshot.appendSections([.main])
    snapshot.appendItems(data)

    dataSource?.apply(snapshot)
}
```
- 데이터를 먼저 받아온 후 snapshot을 업데이트 하는 방식을 사용하였습니다.
    
    
#### T2. TextView의 스크롤뷰 
    - Text View의 heigth가 클 경우 제목이 사라지는 현상 발생
```swift!
extension UITextView {
    func focusTop() {
        let contentHeight = self.contentSize.height
        let offSet = self.contentOffset.y
        let contentOffset = contentHeight - offSet
        self.contentOffset = CGPoint(x: 0, y: -contentOffset)
    }
}
```

#### T3. 간접적으로 처리했던 비지니스 로직을 직접적으로 처리하도록 구현
    (ViewController ↔️ ViewModel ( ↔️ Business logic object ))
```Swift!
final class DiaryViewModel {
    private let jsonManager = JSONManager()
    var diaryContents: [DiaryContent] {
        guard let contents = fetchData() else {
            return [DiaryContent]()
        }

        return contents
    }


    private func fetchData() -> [DiaryContent]? {
        let fileName = "diarySample"
        let result = jsonManager.checkFileAndDecode(dataType : [DiaryContent].self, fileName)

        switch result {
        case .success(let contents):
            return contents
        default:
            return nil
        }
    }
}
```
- ViewController 내에서 `fetchData()를 처리하였으나 ViewModel로 이동.
    - 이유 : MVVM 패턴에서 ViewController는 비지니스 로직을 처리하면 안되기 때문.

### STEP 2

#### T1. title과 body를 분리하는 로직
- 일기장을 생성하는 `DiaryPostViewController`에서 `TextView` 내에 텍스트를 입력시 처리해줘야 하는 문제들이 있었습니다.
    1. 제목을 작성하고 한칸 띄워쓰기("\n\n")를 하고 내용을 작성
    2. 바로 아래라인("\n")으로 내용을 작성하는 상황

```swift

var data = text.split(separator: "\n", maxSplits: 2).map{ String($0) }
let title = data.remove(at: 0)
let body = data.count >= 1 ? data.joined(separator: "\n") : ""

```
- TextView의 텍스트를 모두 받아와 Title 부분과 분리하여 처리할 수 있도록 하였습니다. 
 
#### T2. CoreData Update
- 해당 Cell을 통해 text를 수정해도 수정이 제대로 반영되지 않고, 다른 Cell이 update되는 걸 확인 생성 시간을 기준으로 원하는 해당 Cell의 정확한 데이터를 불러오도록 수정
```swift
request.predicate = NSPredicate(format: "createdAt = %@", "\(data.createdAt)")
```


## 📚 참고문서

- [UITextView](https://developer.apple.com/documentation/uikit/uitextview)
- [UITableViewDiffableDataSource](https://developer.apple.com/documentation/uikit/uitableviewdiffabledatasource)
- [DateFormatter](https://developer.apple.com/documentation/foundation/dateformatter)