- 프로젝트 기간: [2023년 8월 28일 ~ 9월 15일](https://github.com/WhalesJin/ios-diary/wiki/타임라인)
- 프로젝트 팀원: [Whales🐬](https://github.com/WhalesJin), [Mary🐿️](https://github.com/MaryJo-github)
- 프로젝트 리뷰어: [havi🐠](https://github.com/havilog)

---

## 📖 목차
🍀 [소개](#소개) </br>
💻 [실행 화면](#실행_화면) </br>
🛠️ [사용 기술](#사용_기술) </br>
👀 [다이어그램](#Diagram) </br>
🧨 [트러블 슈팅](#트러블_슈팅) </br>
📚 [참고 링크](#참고_링크) </br>
👩‍👧‍👧 [about TEAM](#about_TEAM) </br>

</br>

## 🍀 소개<a id="소개"></a>
📙 새 일기 작성 및 저장된 일기 수정이 가능한 일기장 앱입니다. 📗

</br>

## 💻 실행 화면<a id="실행_화면"></a>

| 새 일기 작성 | 저장된 일기 수정 |
| :--------: | :--------: |
| <img src = "https://github.com/WhalesJin/FireSaturdayStudyClassC/assets/124643545/f75b86e7-1138-4faa-a52f-0118f92aac32" width = "200"> | <img src = "https://github.com/WhalesJin/FireSaturdayStudyClassC/assets/124643545/bae48206-b33c-4f1d-9b21-a9f0fa59a6e8"  width = "200"> |

</br>

## 🛠️ 사용 기술<a id="사용_기술"></a>
| 구현 내용	| 도구 |
|:---:|:---:|
|아키텍쳐|MVC|
|UI|UIKit|
|로깅방식|OS_Log|
|지원 언어|한국어, English|

</br>

## 👀 Diagram<a id="Diagram"></a>
### 📐 UML

<img src = "https://github.com/WhalesJin/FireSaturdayStudyClassC/assets/124643545/33c91586-bbc1-41c8-a48c-501aa23373c9" width = "800">


</br>

## 🧨 트러블 슈팅<a id="트러블_슈팅"></a>

### 1️⃣ DTO/Entity 분리
🚨 **문제점** <br>
- Json 샘플 파일에는 다이어리가 생성된 날짜를 `timeInterval 형태(ex. 1608651333)`로 가지고 있습니다. 하지만 ViewController에서는 생성 날짜를 `원하는 포맷(ex. 2020년 12월 23일)`으로 바꿔준 후 UI에 활용하기때문에, 활용할 때마다 DateFormat을 변경하는 것은 비효율적이라고 생각했습니다.

💡 **해결방법** <br>
- JSON decoding 시 활용하는 객체(DTO)와 실제 모델에서 활용하는 객체(Entity)를 분리해줌으로써 해결하였습니다.
    - 다이어리가 생성된 날짜를 timeInterval 형태로 가지는 DTO와 달리 Entity는 원하는 포맷으로 변환한 date를 가지고있습니다.
    - 다이어리를 생성하거나, decoding할 때에만 DateFormat을 변경하고, 이후에는 저장된 date를 이용합니다.

🔀 **코드 변화** <br>
- <details>
    <summary> 수정 전 </summary>

    ```swift
    struct DiaryContent: Codable {
        var title: String
        var body: String
        var timeInterval: Double

        private enum CodingKeys: String, CodingKey {
            case title, body
            case timeInterval = "created_at"
        }
    }
    ```
    </details>
- <details>
    <summary> 수정 후 </summary>

    ```swift
    // DTO
    struct DiaryContentDTO: Decodable {
        var title: String
        var body: String
        var timeInterval: Double

        private enum CodingKeys: String, CodingKey {
            case title, body
            case timeInterval = "created_at"
        }
    }

    // Entity
    struct DiaryContent {
        var title: String
        var body: String
        var date: String
    }
    ```
    </details>

<br>

### 2️⃣ DiaryManager (STEP2 진행 후 수정 예정)
`Asset`에 넣은 `"sample"` 데이터를 받아오는 메서드를 구현하는데, 이 작업은 `View`나 `Controller`의 역할이 아니라고 생각해서 `DiaryManager`라는 객체를 `Model`로 만들었습니다. `DiaryViewController`가 `DiaryManager`를 가지고 있고, `DiaryManager`가 데이터 `fetch` 작업을 할 수 있도록 메서드를 구현하였습니다.
<details>
    <summary> 수정 전 </summary>
    
```swift
struct DiaryManager {
    func fetchDiaryContents(name: String) -> [DiaryContent]? {
        do {
            let data: [DiaryContent] = try DecodingManager.decodeJSON(fileName: name)
            
            return data
        } catch {
            os_log("%{public}@", type: .default, error.localizedDescription)
        }
        
        return nil
    }
}
    
final class DiaryViewController: UIViewController {
    private let diaryManager = DiaryManager()
    private var data: [DiaryContent]?
            ...
    
    override func viewDidLoad() {
            ...
    
        fetchData()
    }
            ...
    
    private func fetchData() {
        data = diaryManager.fetchDiaryContents(name: "sample")
    }
}

```
</details>
</br>

🚨 **문제점** <br>
- `DiaryViewController`가 `DiaryManager`를 가지고 있긴 하지만 `fetchData` 메서드에서 `manager`의 메서드를 호출해 일을 시킴으로써 `Controller`가 데이터를 받아오는 일을 하게되고, 그로 인해 `fetchDiaryContents` 메서드를 은닉화 할 수 없었습니다.


💡 **해결방법** <br>
- `DiaryViewController`에서 필요한 `diaryContents`를 `DiaryManager`의 연산프로퍼티로 구현하고, 그 연산에 `fetchDiaryContents` 메서드를 호출해서 문제점들을 해결하였습니다.

<details>
    <summary> 수정 후 </summary>
    
```swift
struct DiaryManager {
    var diaryContents: [DiaryContent]? {
        return fetchDiaryContents(name: "sample")
    }
    
    private func fetchDiaryContents(name: String) -> [DiaryContent]? {
        do { ... } catch { ... }
    }
}
    
final class DiaryViewController: UIViewController {
    private let diaryManager = DiaryManager()
            ...
}
    
extension DiaryViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return diaryManager.diaryContents?.count ?? 0
    }
            ...
}
```
</details>

<br>


### 3️⃣ SwiftLint 활용
더 깔끔하고 통일성있는 컨벤션을 위해 SwiftLint를 적용했습니다.

🚨 **문제점** <br>
- SwiftLint를 프로젝트에 적용했더니 빌드 시 경고가 발생하였습니다.
<img src = "https://hackmd.io/_uploads/ry4_ZZk0h.png" width = 300>

💡 **해결방법** <br>
- SwiftLint에서 디폴트로 적용되는 Rule 때문에 발생한 문제였습니다.
- `.swiftlint` 파일을 다음과 같이 수정하여 저희의 컨벤션과 맞춰줌으로써 해결하였습니다.
    ``` swift
    disabled_rules:
        - trailing_whitespace
        - trailing_comma
    ```


## 📚 참고 링크<a id="참고_링크"></a>

- [🍎Apple Docs: os_log](https://developer.apple.com/documentation/os/os_log)
- [🍎Apple Docs: UIScrollView.KeyboardDismissMode](https://developer.apple.com/documentation/uikit/uiscrollview/1619437-keyboarddismissmode)
- [🍎Apple Docs: Adaptivity and Layout](https://developer.apple.com/design/human-interface-guidelines/layout)
- [🍎Apple Docs: DateFormatter](https://developer.apple.com/documentation/foundation/dateformatter)
- [🍎Apple Docs: UITextView](https://developer.apple.com/documentation/uikit/uitextview)
- [🍎Apple Docs: Swipe-trailing](https://developer.apple.com/documentation/uikit/uitableviewdelegate/2902367-tableview)
- [🍎Apple Docs: UIActivityViewController](https://developer.apple.com/documentation/uikit/uiactivityviewcontroller)
- [🍏WWDC: Making Apps Adaptive, Part 1](https://asciiwwdc.com/2016/sessions/222)
- [🍏WWDC: Making Apps Adaptive, Part 2](https://www.youtube.com/watch?v=s3utpBiRbB0)
- [🍏WWDC note: UIKit: Apps for Every Size and Shape](https://www.wwdcnotes.com/notes/wwdc18/235/)
- <Img src = "https://github.com/WhalesJin/ios-bank-manager/assets/124643545/d1df2d8a-6667-438d-9643-aab8a83a4754" width="20"/> [SwiftLint Rule Directory](https://realm.github.io/SwiftLint/rule-directory.html)
- <Img src = "https://github.com/mint3382/ios-calculator-app/assets/124643545/56986ab4-dc23-4e29-bdda-f00ec1db809b" width="20"/> [야곰닷넷: Test Double](https://yagom.net/courses/unit-test-작성하기/lessons/테스트를-위한-객체-만들기/topic/테스트를-위한-객체를-이용해서-테스트-작성하기/)
- <Img src = "https://hackmd.io/_uploads/ByTEsGUv3.png" width="20"/> [blog: URL 처리 방법](https://ios-development.tistory.com/1014)

<br>

---

## 👩‍👧‍👧 about TEAM<a id="about_TEAM"></a>

| <Img src = "https://github.com/WhalesJin/FireSaturdayStudyClassC/assets/124643545/e11077ba-328c-4ada-af5e-57e1b1ccfd77" width="100"> | 🐬Whales🐬  | https://github.com/WhalesJin |
| :--------: | :--------: | :--------: |
| <Img src = "https://hackmd.io/_uploads/r1rHg7JC3.jpg" width="100"> | **🐿️Mary🐿️** | **https://github.com/MaryJo-github** |

- [타임라인 링크](https://github.com/WhalesJin/ios-diary/wiki/타임라인)
