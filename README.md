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

## 💡 키워드

- `DateFormatter`, `UITableViewDiffableDataSource`, `UITableView`, 
    `UITextView`, `Date`, `JSON`
    
## 🤔 핵심경험

- [x] Date Formatter의 지역 및 길이별 표현의 활용
- [x] Text View의 활용
- [ ] 코어데이터 모델 생성
- [ ] 코어데이터 모델 및 DB 마이그레이션
- [ ] 테이블뷰에서 스와이프를 통한 삭제기능 구현
- [ ] Text View Delegate의 활용
- [ ] Open API의 활용
- [ ] Core Location의 활용

## 📱 실행 화면

|일기장 List 화면|일기장 화면|일기장 작성 화면|키보드 구현|
|:--:|:--:|:--:|:--:|
|![](https://i.imgur.com/uoXp233.gif)|![](https://i.imgur.com/ikYAfoW.gif)|![](https://i.imgur.com/NtY72xL.gif)|![](https://i.imgur.com/oDd8BZH.gif)|


    
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
- StackView
- TextView

**화면 전환시 데이터 전달**
- 변수를 사용해 데이터 전달
    
**일기장 화면의 Text View & 키보드**
- 현재 커서로 textView를 클릭하는 위치가 키보드에 가려지지 않도록 구현
- 현재 사용자가 작성하는 부분은 화면에 보이도록 구현

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
    
## 📚 참고문서

- [UITextView](https://developer.apple.com/documentation/uikit/uitextview)
- [UITableViewDiffableDataSource](https://developer.apple.com/documentation/uikit/uitableviewdiffabledatasource)
- [DateFormatter](https://developer.apple.com/documentation/foundation/dateformatter)
