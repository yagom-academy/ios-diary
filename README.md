# 일기장 

- 프로젝트 기간: [2023년 7월 24일 ~ 8월 23일](#타임라인)
- 프로젝트 팀원: [kyungmin🐼](https://github.com/YaRkyungmin), [Dasan🌳](https://github.com/DasanKim)
- 프로젝트 리뷰어: [제임스]()

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
- 일기를 작성, 수정, 저장 할 수 있는 일기장 앱입니다.

</br>

## 💻 실행 화면<a id="실행_화면"></a>

| 새로운 일기장 편집 화면 | 기존 일기장 편집 화면 |
| :--------: | :--------: |
| <img src = "https://cdn.discordapp.com/attachments/1100965172086046891/1147096040412020787/1.gif" width = "200"> | <img src = "https://cdn.discordapp.com/attachments/1100965172086046891/1147096095302893608/2.gif"  width = "200"> |

| 화면모드 변경 |
| :--------: | 
| <img src = "https://cdn.discordapp.com/attachments/1100965172086046891/1147059093564031026/946ecb3d2ec30a64.gif" width = "440"> | 

</br>

## 🛠️ 사용 기술<a id="사용_기술"></a>
| 구현 내용	| 도구 |
|:---:|:---:|
|아키텍쳐|MVC|
|UI|UIKit|
|Localized|Locale|
|리스트 표시|Modern Collection Veiw|

</br>

## 👀 Diagram<a id="Diagram"></a>
### 📐 UML
(추후 추가)


</br>

## 🧨 트러블 슈팅<a id="트러블_슈팅"></a>

### 1️⃣ 타입 분리
✨ 모델 타입 별 기능
- `DiaryData` : `JSON` 데이터를 디코딩할때 사용, `DTO`
- `Diary` : 실제 `VC`에서 사용할 데이터
- `AssetDataManager` : `filename`을 통해 `Asset`데이터를 받아와 디코딩해주는 역활
- `DataManager` : `DTO`를 `Diary` 타입으로 변환 해주는 역활
- `DateManager` : 필요한 날짜를 원하는 템플릿으로 변환하여 `String`으로 반환 해주는 역활
- `DiaryManager`: `VC`와 `Model` 사이에서 필요한 데이터나 이벤트를 역활에 맞는 `Manager`에게 전달 해주는 역활

🚨 **문제점** <br>
- `DTO`인 `DiaryData`와 `Diary`를 통합해서 하나의 타입으로 사용 할지, 분리해서 사용할 지에 대해 고민했습니다.

💡 **해결방법** <br>
- 통합하여 사용 하면 `cellRegistration`에서 `cell`에 데이터를 입력시켜 줄 때마다 데이터 변환을 `DiaryManager`를 통해 요청해줘야 했고, 분리하여 사용 시 `DiaryData`를 `fetch`해 올 때 `Data`를 정제 시켜줘야 했습니다.
- 각 셀에 데이터를 주입해 줄 때마다 `DiaryManager`를 통해 데이터를 요청하는 것보다 fetch할때 정제해주는것이 오버헤드가 더 적다고 판단하였기 때문에 `DiaryData`와 `Diary`를 분리하여 사용했습니다.


### 2️⃣ TextView와 Keyboard
편집중인 텍스트가 키보드에 의해 가리지 않도록하기 위하여 `diaryTextView`와 `keyboard` 사이에 레이아웃 설정이 필요했습니다.

🚨 **문제점** <br>
- diaryTextView와 `keyboardLayoutGuide` 사이에 constraint를 아래와 같이 잡아주었습니다.
    - 키보드의 위치를 추적하는 `keyboardLayoutGuide`와 constraint를 설정하였습니다.
    - 더불어 readability에 최적화된 width를 제공해주는 `readableContentGuide`와 constraint를 설정하여, **긴 글을 쉽게 읽을 수 있도록** 하였습니다.
    ```swift
    NSLayoutConstraint.activate([
        diaryTextView.topAnchor.constraint(equalTo: view.readableContentGuide.topAnchor),
        diaryTextView.bottomAnchor.constraint(equalTo: view.keyboardLayoutGuide.topAnchor),
        diaryTextView.leftAnchor.constraint(equalTo: view.readableContentGuide.leftAnchor),
        diaryTextView.rightAnchor.constraint(equalTo: view.readableContentGuide.rightAnchor)
    ])
    ```
- 하지만 `keyboardLayoutGuide` 같은 경우 `iOS 15`에서부터 적용할 수 있습니다. 
- 아래와 같이 `iOS15` 이상을 사용하는 사람들이 대부분이지만 그 이하 버전을 사용하는 `6%`를 위하여 다른 방법을 모색할 필요가 있었습니다.
    ![](https://hackmd.io/_uploads/B194oMyC3.png)

💡 **해결방법** <br>
- iOS 15 이상일 때와 그 미만 버전일 때를 나누어 레이아웃을 적용해주었습니다.
    - iOS 15이상: keyboardLayoutGuide 적용
    - iOS 15미만: diaryTextView의 contentInset 변경

- iOS 15미만일 때에는 `NotificationCenter`를 통해 키보드가 나타나고 사라질 때를 추적하여, `diaryTextView`의 `contentInset.bottom`을 키보드 높이만큼 변경하였습니다.
    <details>
    <summary> 코드 보기 </summary>
    
    ```swift
    // DiaryDetailViewController.swift
    override func viewWillAppear(_ animated: Bool) {
        if #unavailable(iOS 15.0) {
            addKeyboardObserver()
        }
    }

    private func addKeyboardObserver() {
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(keyboardWillShow),
            name: UIResponder.keyboardWillShowNotification,
            object: nil
        )
    }

    @objc private func keyboardWillShow(_ notification: Notification) {
        guard let userInfo = notification.userInfo as NSDictionary?,
              let keyboardFrame = (userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue else {
            return
        }

        diaryTextView.contentInset = UIEdgeInsets(
            top: .zero,
            left: .zero,
            bottom: keyboardFrame.size.height,
            right: .zero
        )
    }
    ```
    </details>

### 3️⃣ Locale 적용

🚨 **문제점** <br>
- Date 포맷을 DateFormatter의 lacale을 `ko_KR`로 적용하였을 때 지역화가 되지 않는 문제점이 발생했습니다.
    ```swift
    dateFormatter.locale = Locale(identifier: "ko_KR")
    ```

💡 **해결방법** <br>
- **프로퍼티를 읽을 당시 사용자의 지역 설정을 나타내는** Locale의 `current` 프로퍼티를 사용하여 지역화 문제를 해결했습니다.
    ```swift
    dateFormatter.locale = Locale.current.identifier
    ```
<br>

## 📚 참고 링크<a id="참고_링크"></a>
- [🍎Apple Docs: Layout](https://developer.apple.com/design/human-interface-guidelines/layout)
- [🍎Apple Docs: KeyboardLayoutGuide](https://developer.apple.com/documentation/uikit/uiview/3752221-keyboardlayoutguide)
- [🍎Apple Docs: UITextView](https://developer.apple.com/documentation/uikit/uitextview)
- [🍎Apple Docs: current](https://developer.apple.com/documentation/foundation/locale/2293654-current)
- [🍎Apple Docs: DateFormatter](https://developer.apple.com/documentation/foundation/dateformatter)

<br>

---

## 👩‍👧‍👧 about TEAM<a id="about_TEAM"></a>

| <Img src = "https://cdn.discordapp.com/attachments/1100965172086046891/1108927085713563708/admin.jpeg" width="100"> &nbsp; 🐼Kyungmin🐼  | https://github.com/YaRkyungmin |
| -------- | -------- |
| <Img src = "https://user-images.githubusercontent.com/106504779/253477235-ca103b42-8938-447f-9381-29d0bcf55cac.jpeg" width="100"> &nbsp; **🌳Dasan🌳** | **https://github.com/DasanKim** |

- [타임라인 링크](https://github.com/YaRkyungmin/ios-diary/wiki/타임라인-📋)
