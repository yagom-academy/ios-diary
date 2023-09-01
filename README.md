# 📖일기장

![](https://hackmd.io/_uploads/Bk88JsYTn.png)
> 프로젝트 기간: 23.08.28 ~ 23.09.15

## 📖 목차
1. [🍀 소개](#소개)
2. [💻 실행 화면](#실행-화면)
3. [🧨 트러블 슈팅](#트러블-슈팅)
4. [📚 참고 링크](#참고-링크)
5. [👥 팀](#팀)

</br>

<a id="소개"></a>

## 🍀 소개
일기를 작성하고, 수정할 수 있는 앱
> 지원 언어 : 한국어, English

</br>

<a id="실행-화면"></a>

## 💻 실행 화면

| 일기 목록 스크롤 | 일기 내용 보기 |
|:--------:|:--------:|
|<img src="https://github.com/bubblecocoa/storage/assets/67216784/df3191b2-fdda-46f0-9953-5ece1a232ba5" alt="diary_scroll" width="250">|<img src="https://github.com/bubblecocoa/storage/assets/67216784/771da24b-a121-48b7-ae43-5ed37a49be20" alt="diary_detail" width="250">|

| 키보드 영역 겹침 방지 | 일기 추가 |
|:--------:|:--------:|
|<img src="https://github.com/bubblecocoa/storage/assets/67216784/4b12fde6-a814-45a3-a3e1-7905a740fef9" alt="diary_keyboard" width="250">|<img src="https://github.com/bubblecocoa/storage/assets/67216784/9292db31-5391-46a6-85fe-4c72201937ae" alt="diary_push_add_diary_view" width="250">|


</br>

<a id="트러블-슈팅"></a>

## 🧨 트러블 슈팅
###### 핵심 트러블 슈팅위주로 작성하였습니다.
1️⃣ **Swift Lint 규칙변경** <br>
-
🔒 **문제점** <br>
`Pod`을 통해 `SwiftLint`를 설치하고 프로젝트에 적용했습니다. `Lint`는 프로젝트 빌드 시 코드 컨벤션에 대한 경고를 띄워주었고, 경고를 모두 없애면 전체적으로 읽기 좋은 코드가 되었습니다.
하지만 `Lint`를 모두 따르기에는 어색한 부분이 있었는데, 줄바꿈에 대한 부분이었습니다.
> `SwiftLint`가 경고를 띄우는 부분
```swift
struct 구조체 {
    let 프로퍼티1
    let 프로퍼티2
    // Trailing Whitespace Violation: Lines should not have trailing whitespace (trailing_whitespace) 
    func 메서드1() {}
    func 메서드2() {}
    // Trailing Whitespace Violation: Lines should not have trailing whitespace (trailing_whitespace)
    enum 열거형 {
        case 경우1
        case 경우2
    }
}
```
저희 팀은 줄바꿈은 `SwiftLint`의 제안을 받아들이기보다 저희의 컨벤션을 지키고 싶었으나, `XCode`의 `Issue Navigator`에 `Lint`로 인한 경고가 많이 누적되는것을 보고싶지 않았습니다.

🔑 **해결방법** <br>
`SwiftLint`의 기본 옵션을 변경할 수 있다는 것을 알게 되었습니다.
[SwiftLint Rule](https://realm.github.io/SwiftLint/rule-directory.html)에 따르면 경고에 계속 노출되었던 `trailing_whitespace`는  줄 뒤에 공백이 있어서는 안 됨을 의미합니다.
프로젝트 `root` 경로에 `.swiftlint.yml` 파일을 만들고 내부에 다음 내용을 작성했습니다.
```yml
# 기본 활성화된 룰 중에 비활성화할 룰을 지정
disabled_rules:
    - trailing_whitespace
```
`disabled_rules`에 `trailing_whitespace`를 추가함으로써 `Lint`가 줄바꿈 관련된 경고를 띄우지 않도록 변경했습니다.

<br>


2️⃣ **일기 작성 및 수정 시 textView 개수 선택** <br>
-
🔒 **문제점** <br>
제목과 본문의 구현을 어떻게 해야할지에 대한 고민이 있었습니다. 제목 `textView`와 본문 `textView`를 나누고 `stackView`에 넣어줄 경우 여러가지 문제점이 생겼습니다. 
1. 제목에 특정한 제약을 주지 않아 길어지게 되서 한 화면을 전부 차지하게 될 경우 본문 `textView`로 넘어갈 수가 없다.
2. 본문 `textView`를 스크롤 할 경우 제목은 올라가지 않고 계속 남아있게 된다.


🔑 **해결방법** <br>
`textView`를 제목과 본문으로 나누지 않고 `contentTextView`라는 하나의 `textView`에서 제목과 본문을 모두 입력받을 수 있게 변경하여 처리하였습니다.

<br>

3️⃣ **iOS 타겟 버전 변경 - UIKeyboardLayoutGuide** <br>
-
🔒 **문제점** <br>
키보드를 사용할 때 글자를 가리는 일이 생겨 `textView`도 같이 올려주는 방법에 대한 고민이 있었습니다. 그 중에서도 두가지 방법을 찾을 수 있었습니다.
1. `Notification`을 사용하여 키보드가 올라올 때마다 키보드의 `contentInset`을 빼주는 방법
2. `keyboardLayoutGuide`를 제약 조건에 적용하는 방법

간단하기는 2번이 간단했지만 `iOS 15.0` 부터 사용할 수 있어 고민이 있었습니다.


🔑 **해결방법** <br>
1번의 방법을 사용할 때 `keyboardFrameEndUserInfoKey`을 사용합니다. 그런데 [keyboardFrameEndUserInfoKey](https://developer.apple.com/documentation/uikit/uiresponder/1621578-keyboardframeenduserinfokey) 공식문서를 보면 다음 내용이 있었습니다.
> Important
>
> Instead of using this key to track the keyboard’s frame, consider using UIKeyboardLayoutGuide, which allows you to respond dynamically to keyboard movement in your app. For more information, see [Adjusting Your Layout with Keyboard Layout Guide](https://developer.apple.com/documentation/uikit/keyboards_and_input/adjusting_your_layout_with_keyboard_layout_guide).
> 
> 이 키를 사용하여 키보드 프레임을 추적하는 대신 앱의 키보드 움직임에 동적으로 반응할 수 있는 UIKeyboardLayoutGuide를 사용하는 것이 좋습니다. 자세한 내용은 [키보드 레이아웃 가이드로 레이아웃 조정](https://developer.apple.com/documentation/uikit/keyboards_and_input/adjusting_your_layout_with_keyboard_layout_guide)을 참조하세요.
 
[UIKeyboardLayoutGuide](https://developer.apple.com/documentation/uikit/uikeyboardlayoutguide)는 `iOS 15.0` 이후로 지원하기 때문에 2번의 방법을 선택하여 진행하였습니다.

<br>

4️⃣ **지역화 적용** <br>
-
🔒 **문제점** <br>
날짜 관련된 문자열을 출력하기 위해 `DateFormatter`의 확장에 다음 메서드를 추가했습니다.
```swift
func configureDiaryDateFormat() {
    dateStyle = .long
    timeStyle = .none
    locale = Locale(identifier: "ko_KR")
    dateFormat = "yyyy년 MM월 dd일"
}
```
하지만 이렇게 날짜 포맷을 지정할 경우 사용자가 어떠한 `Locale`을 선택하더라도 'XXXX년 XX월 XX일' 형태로 출력되게 됩니다.

🔑 **해결방법** <br>
```swift
func configureDiaryDateFormat() {
    dateStyle = .long
    timeStyle = .none
    locale = Locale(identifier: Locale.current.identifier)
}
```
`DateFormatter`의 `locale`을 현재의 `Locale.current.identifier`를 통해 인식하도록 했습니다. 이 값은 디바이스의 `설정` - `일반` - `언어 및 지역`의 정보를 가져오게 됩니다. 이것으로 사용자 각각의 `Locale`에 맞게 날짜가 포매팅 되어 출력됩니다.

<br>


5️⃣ **layoutMarginsGuide** <br>
-
🔒 **문제점** <br>
`tableView`의 `Custom Cell`을 설정할 때 제약조건을 `ContentView`에 맞췄더니 글자들이 `leading`에 딱 붙어서 표시되었습니다. 
``` swift
private func configureCellConstraint() {
    NSLayoutConstraint.activate([
        contentStackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
        contentStackView.topAnchor.constraint(equalTo: contentView.topAnchor),
        contentStackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
        contentStackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
    ])
}
```
이를 `seperate line`에 맞게 보기 좋은 간격을 주기 위한 고민이 있었습니다. 


🔑 **해결방법** <br>
`layoutMarginGuide`라는 여백 기준을 사용하여 간격을 맞춰주었습니다. 
```swift
private func configureCellConstraint() {
    NSLayoutConstraint.activate([
        contentStackView.leadingAnchor.constraint(equalTo: contentView.layoutMarginsGuide.leadingAnchor),
        contentStackView.topAnchor.constraint(equalTo: contentView.layoutMarginsGuide.topAnchor),
        contentStackView.trailingAnchor.constraint(equalTo: contentView.layoutMarginsGuide.trailingAnchor),
        contentStackView.bottomAnchor.constraint(equalTo: contentView.layoutMarginsGuide.bottomAnchor)
    ])
}
```
`readableContentGuide`를 이용하여 간격을 줄 수도 있지만 넓은 아이패드 같은 화면에서 사용하게 되는 경우 퍼지는 것을 잡아주는 데에 사용하는 가이드인데 현재의 프로젝트에서는 `layoutMarginGuide`로도 충분할 것 같아서 이것을 사용하였습니다.

<br>

<a id="참고-링크"></a>

## 📚 참고 링크
- [🍎Apple Docs: keyboardFrameEndUserInfoKey](https://developer.apple.com/documentation/uikit/uiresponder/1621578-keyboardframeenduserinfokey)
- [🍎Apple Docs: Adjusting Your Layout with Keyboard Layout Guide](https://developer.apple.com/documentation/uikit/keyboards_and_input/adjusting_your_layout_with_keyboard_layout_guide)
- [🍎Apple Docs: UIKeyboardLayoutGuide](https://developer.apple.com/documentation/uikit/uikeyboardlayoutguide)
- <Img src = "https://github.com/mint3382/ios-calculator-app/assets/124643545/56986ab4-dc23-4e29-bdda-f00ec1db809b" width="20"/> [야곰닷넷: Swift Lint 써보기](https://yagom.net/forums/topic/swift-lint-%EC%8D%A8%EB%B3%B4%EA%B8%B0/)
- <Img src = "https://hackmd.io/_uploads/ByTEsGUv3.png" width="20"/> [blog: [iOS] Swiftlint 룰 적용하기](https://velog.io/@whitehyun/iOS-Swiftlint-%EB%A3%B0-%EC%A0%81%EC%9A%A9%ED%95%98%EA%B8%B0)

</br>

<a id="팀"></a>

## 👥 팀

### 👨‍💻 팀원
| 🤖BMO🤖 | 😈MINT😈 |
| :--------: | :--------: |
| <img src="https://hackmd.io/_uploads/BJdXmAAph.jpg" width="200" height="200"> | <img src="https://hackmd.io/_uploads/ByLbQ0RT2.jpg"  width="200" height="200"> |
|[Github Profile](https://github.com/bubblecocoa) |[Github Profile](https://github.com/mint3382) |

</br>

- [팀 회고 링크](https://github.com/mint3382/ios-diary/wiki)
