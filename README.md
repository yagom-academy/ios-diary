## 일기장
> 프로젝트 기간: 23/08/28 ~ 23/09/15

## 📂 목차
1. [팀원](#1.)
2. [타임 라인](#2.)
3. [시각화구조](#3.)
4. [실행 화면](#4.)
5. [트러블 슈팅](#5.)
6. [팀 회고](#6.)
7. [참고 문서](#7.)


<a id="1."></a>

## 1. 팀원

| Jusbug | yyss99 |
| :--------: | :--------: |
| <Img src = "https://github.com/JusBug/ios-box-office/assets/125210310/549c2726-aa5a-48cc-a39a-7c10d10bdda5" width="200" height="200"> | <Img src = "https://hackmd.io/_uploads/ryHsN0cTn.png"  width="200" height="200"> |
|[Github Profile](https://github.com/JusBug) |[Github Profile](https://github.com/yy-ss99) |
- - -
<a id="2."></a>

## 2. 타임라인

<details>
<summary>타임 라인</summary>
<div markdown="1">
    
### 2023.08.28.(월)
- README 수정
### 2023.08.29.(화)
- DiaryTableViewCell 등록 및 구현
- Sample 데이터 타입 구현 및 JSON 파일 추가
- JSON파일을 Sample 타입으로 디코딩하는 decodeJSON() 구현
- DiaryTableViewCell 레이아웃 수정
- DateFormatter로 createdDate 날짜형식변환
### 2023.08.30.(수)
- 일기장 생성 버튼 구현
- TextView 생성 및 placeholder 구현
- DetailViewController 네비게이션 타이틀 오늘 날짜 추가
- DetailVC 생성 및 테이블 뷰 커스텀 이니셜라이져로 데이터를 전달하여 didSelectRowAt() 구현
- DetailViewController 편집 시 키보드가 글자 가리는 이슈 해결
### 2023.09.01 (금)
- final 키워드 명시, 은닉화 처리, 불필요한 프로퍼티 삭제
- NewDiaryViewController 삭제 및 DetailViewController 수정
- 불필요한 주석 제거
</div>
</details>
<a id="3."></a>

## 3. 시각화 구조

### 📐 Diagram
![](https://hackmd.io/_uploads/H1zXBb1R2.png)

### 🌲 File Tree
<details>
<summary>File Tree</summary>
<div markdown="1">

```
.
├── Diary
│   ├── Application
│   │   ├── AppDelegate.swift
│   │   └── SceneDelegate.swift
│   ├── ViewController
│   │   ├── MainViewController.swift
│   │   ├── DetailViewController.swift
│   │   └── DiaryTableViewCell.swift
│   ├── Model
│   │   ├── Sample.swift
│   │   └── CustomDateFormatter.swift
│   ├── Resources
│   │   ├── Assets
│   │   ├── Diary
│   │   └── Info.plist
│   └── View
│       ├── Base.lproj
│       │   ├── LaunchScreen.storyboard
│       │   └── Main.storyboard
│       └── DiaryTableViewCell.xib
│       
├── README.md
└── sample.json
```

</div>
</details>

</br>
<a id="4."></a>

## 4. 실행 화면

</br>
<a id="5."></a>

## 5. 트러블 슈팅

### 1. <키보드 가림 이슈>

🤯 **문제상황**
`textField`에 쓰는 글이 길어지다 보면 키보드에 의해 가려지는 현상이 발생했습니다. 

🔥 **해결방법**
키보드의 높이 만큼 `textView`의 `bottomInset`을 올라가도록 만들었습니다. 그래서 글이 쓰여지는 동안에 키보드에 의해 가려지 않고 화면에 보여지게 만들었습니다.

```Swift
@objc func keyboardWillShow(_ sender: Notification) {
    if originalFrame == nil {
        originalFrame = view.frame
    }
        
    if let keyboardFrame = (sender.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
        let keyboardHeight = keyboardFrame.height
        let safeAreaBottom = view.safeAreaInsets.bottom
        let contentInsets = UIEdgeInsets(top: 0, left: 0, bottom: keyboardHeight - safeAreaBottom, right: 0)
            
        bodyTextView.contentInset = contentInsets
    }
}
    
@objc func keyboardWillHide(_ sender: Notification) {
    if originalFrame != nil {
        bodyTextView.contentInset = UIEdgeInsets.zero
    }
}
```
- - -
### 2. <TextView Placeholder 구현>

🤯 **문제상황**
기본적으로 `UITextView`에서는 `placeholder` 기능을 제공하지 않아서 직집 구현해야 하는 문제가 있었습니다. 참고로 `placeholder`는 사용자에게 입력하라는 힌트를 주는 메시지 역할로 사용자 입장에서 보다 편리한 UI 경험을 제공하기 위해서 구현하게 되었습니다.

🔥 **해결방법**
`titleTextView`, `bodyTextView`에서 둘다 사용할 수 있도록 `placeHolderText` 문자열을 전역으로 두고 `UITextViewDelegate`의 `textViewDidBeginEditing` `textViewDidEndEditing` 메서드 즉, 텍스트 뷰의 편집의 시작과 종료 시점에서 호출되는 메서드 안에 텍스트와 컬러를 정의함으로서 직접 placeholder기능을 구현하였습니다.

```Swift
let placeHolderText = "Input Text"
...
extension NewDiaryViewController: UITextViewDelegate {
    func textViewDidBeginEditing(_ textView: UITextView) {
        if titleTextView.text == placeHolderText {
            titleTextView.text = nil
            titleTextView.textColor = .black
        }
        
        if bodyTextView.text == placeHolderText {
            bodyTextView.text = nil
            bodyTextView.textColor = .black
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if titleTextView.text.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
            titleTextView.text = placeHolderText
            titleTextView.textColor = .lightGray
        }
        
        if bodyTextView.text.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
            bodyTextView.text = placeHolderText
            bodyTextView.textColor = .lightGray
        }
    }
}
```
<Img src = "https://hackmd.io/_uploads/rkFAu_2ph.gif" width="300" height="600">
- - -
### 3. <touchesBegan 메서드>
🤯 **문제상황**
`TextViewDelegate`의 `textViewDidEndEditing()`가 호출되기 위해서는 텍스트 뷰의 편집이 종료되어야 하는데 다른 터치이벤트를 이용하여 처리를 해주어야만 편집에서 벗어날 수 있었습니다.

🔥 **해결방법**
`touchesBegan()`는 터치 이벤트가 발생했을 때 호출되는 메서드로 뷰 안에서 편집중인 키보드를 찾아 닫을 수 있도록 해결하였습니다.
```Swift
override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
    self.view.endEditing(true)
}
```
<Img src = "https://hackmd.io/_uploads/H1T32O2T2.gif" width="300" height="600">

- - -
### 4. <DateFormatterManager 구현>

🤯 **문제상황**
`DateFormatter`를 여러번 생성해서 사용해야 하는 상황이 발생 했습니다. 같은 역할을 하는 인스턴스를 여러번 만들어 사용하는 것이 비효율적이었습니다.


🔥 **해결방법**
`static`을 사용하여 `DateFormatter`를 한번만 생성하여 여러 곳에서 쓸 수 있도록 `CustomDateFormatter` 구조체를 만들었습니다.
```Swift
struct CustomDateFormatter {
    static let customDateFormatter: DateFormatter = {
        let todayDateFormatter = DateFormatter()
        todayDateFormatter.locale = Locale(identifier: "koKR")
        todayDateFormatter.dateFormat = "yyyy년 MM월 dd일"

        return todayDateFormatter
    }()

    static func formatTodayDate() -> String {
        let today = Date()
        let formattedTodayDate = customDateFormatter.string(from: today)

        return formattedTodayDate
    }

    static func formatSampleDate( sampleDate: Int) -> String {
        let timeInterval = TimeInterval(sampleDate)
        let inputDate = Date(timeIntervalSince1970: timeInterval)
        let formattedDate = customDateFormatter.string(from: inputDate)

        return formattedDate
    }
}
```
- - -
<a id="6."></a>

## 6. 팀 회고

### 우리팀이 잘한점👍

    
### 서로에게 피드백😀
    
- <To. yyss99>


- <To. Jusbug🕷️>

    
</br>

- - -
<a id="7."></a>

## 7. 참고 문서

- [🍎 Apple - Adaptivity and Layout](https://developer.apple.com/design/human-interface-guidelines/ios/visual-design/adaptivity-and-layout/)
- [🍎 Apple - UIKit: Apps for Every Size and Shape
](https://www.wwdcnotes.com/notes/wwdc18/235/)
- [🎦 Video - Making apps adaptive 1](https://www.youtube.com/watch?v=hLkqt2g-450)
- [🎦 Video - Making apps adaptive 2](https://www.youtube.com/watch?v=s3utpBiRbB0)
- [🍎 Apple - dateformatter](https://developer.apple.com/documentation/foundation/dateformatter)
- [🍎 Apple - UITextView](https://developer.apple.com/documentation/uikit/uitextview)
