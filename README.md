# 📖 일기장
> 프로젝트 기간: 2022-06-13 ~ 2022-07-01
> 
> 팀원: [Safari](https://github.com/saafaaari), [Eddy](https://github.com/kimkyunghun3)
> 
> 리뷰어: [Tony](https://github.com/Monsteel)

## 🔎 프로젝트 소개

일기장 프로젝트 

## 📺 프로젝트 실행화면


## 👀 PR
- [STEP 1](https://github.com/yagom-academy/ios-open-market/pull/136)
- [STEP 2](https://github.com/yagom-academy/ios-diary/pull/16)


## 🛠 개발환경 및 라이브러리
- [![swift](https://img.shields.io/badge/swift-5.0-orange)]()
- [![xcode](https://img.shields.io/badge/Xcode-13.0-blue)]()
- [![iOS](https://img.shields.io/badge/iOS-13.2-red)]()


## 🔑 키워드
- MVC
- UITableView
- UITableViewDiffableDataSource
- DateFormatter
- JSONDecoder
- CoreData
- Builder Pattern
- UIActivityViewController

## ✨ 구현내용
- UITableViewDiffableDataSource 이용한 TableView 구현
- DateFormatter 이용하여 지역에 따른 날짜 표시 
- JSONDecoder이용한 데이터 가져오는 기능 구현
- Keyboard TextView의 컨텐츠를 가리지 않도록 설정 
- Locailzation 설정을 통한 지역 포멧에 맞게 표현 날짜 표현
- CoreData를 활용한 Model 저장 및 수정
- Builder Pattern를 활용한 UIAlertController, UISwipeActionsConfiguration 구현
- UIActivityViewController를 통한 Content 공유 기능 구현
- 백그라운드 진입, 뒤로가기, 키보드가 Hidden 되었을 때 Content 자동 저장 기능 구현

## 🤔 해결한 방법 및 조언받고 싶은 부분

## [STEP 1]

### 공통 extension 은닉화 문제

공용 extension으로 분리했을 시 재사용성의 장점이 존재하지만 모든 곳에서 접근할 수 있기에 은닉화 문제가 발생한다.

재사용성과 은닉화를 동시에 가질 수 없을까라는 문제가 발생했다.
그에 대한 코드는 아래와 같다. 
```swift
// DateFormatter+extension.swift
extension DateFormatter {
    func changeDateFormat(time: Int) -> String {
        self.dateStyle = .long
        self.timeStyle = .none
        self.locale = Locale.current
        let time = Date(timeIntervalSince1970: TimeInterval(time))
        
        return self.string(from: time)
    }
}

// Int+extension.swift
extension Int {
    func time() -> String {
        return DateFormatter().changeDateFormat(time: self)
    } 
}
```

> Diary Model에서 init를 활용해서 데이터를 원하는 DataFormatter로 바꾼 다음 사용하는 곳에서 사용하는 방식으로 변경한다.
> 위에서 사용한 전역적인 extension를 내부로 숨길 수 있으므로 `private` 으로 바꿀 수 있어서 은닉화 문제를 해결할 수 있다.

```swift
// Diary.swift
struct Diary: Codable, Hashable {
    
    ...
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        self.title = try values.decode(String.self, forKey: .title)
        self.body = try values.decode(String.self, forKey: .body)
        self.createdAt = try values.decode(Int.self, forKey: .createdAt).time()
        self.uuid = UUID()
    }
    ...
}

private extension Decodable {
     ...   
}

private extension Int {
     ...   
}
```

> 다른 방식으로는 protocol, extension를 활용해서 내부 구현한 후 실제 사용하는 곳에서 채택하는 방식으로 해결할 수 있다.

```swift
protocol DateFormattable { }

extension DateFormattable {
  func changeDateFormat(time: Int) -> String {
    let dateFormatter = DateFormatter()
    dateFormatter.dateStyle = .long
    dateFormatter.timeStyle = .none
    dateFormatter.locale = Locale.current
    let time = Date(timeIntervalSince1970: TimeInterval(time))
    
    return dateFormatter.string(from: time)
  }
}

```

### TextView를 가리지 않도록 keyboard 위치 문제 
사용자가 Text 입력을 위해 keyboard를 올렸을 때 입력하고 있는 커서가 가려지지 않도록 `TextView`의 `bottomConstraint`를 

```swift
private var bottomConstraint: NSLayoutConstraint?

private func configureLayout() {
    self.addSubview(diaryTextView)
      
    let bottomConstraint = diaryTextView
        .bottomAnchor
        .constraint(equalTo: self.safeAreaLayoutGuide.bottomAnchor)
      
    //... 중략
    
    self.bottomConstraint = bottomConstraint
}
```
위와 같은 방법으로 프로퍼티로 저장해

```swift
func changeBottomConstraint(value: CGFloat) {
    bottomConstraint?.constant = -value
    self.layoutIfNeeded()
}
```
위 메서드를 keyboard가 나타나고, 사라질때 호출하여 결과적으로 keyboard가 현재 사용자가 입력 중인 커서를 가리지 않도록 구현했다.

### Locailzation 설정을 통한 언어별 날짜 표현 문제

`TableView`의 `cell`과 두 번째 화면에서 보여지는 일기장 생성 날짜를 언어별로 표현하기 위해서 


![스크린샷 2022-06-14 오후 8 43 21](https://user-images.githubusercontent.com/52434820/173569383-ff9d36a3-9fd7-4745-a87b-73b09e87e7ee.png)

위와 같이 Project에서 Locailzation에 지원할 나라를 설정하고, 

```swift
private extension DateFormatter {
    func changeDateFormat(time: Int) -> String {
        self.dateStyle = .long
        self.timeStyle = .none
        self.locale = Locale.current
        let time = Date(timeIntervalSince1970: TimeInterval(time))
        
        return self.string(from: time)
    }
}
```
위와 같이 `DateFormatter`를 설정해, Locailzation에 추가한 나라의 언어에 따라 서로 다른 날짜 표현이 가능했다.

| 한글 | 영어 |
|:---:|:---:|
|<img src="https://user-images.githubusercontent.com/52434820/173570000-7c25f628-f935-463d-9c2f-c72db912bac1.png" width="230">|<img src="https://i.imgur.com/sLW9w5d.png" width="230">|

## [STEP 2]

### Builder Pattern 활용하여 Alert, Swipe 구현

Builder Pattern을 활용하여

```swift
// DiaryListViewController.swift
private func configureDataSource() {
    //..중략

    do {
        try dataSource?.makeData()
    } catch {
        AlertBuilder(target: self).addAction("확인", style: .default)
            .show("데이터를 읽어오지 못했습니다", message: nil, style: .alert)
    }
}
```
위와 같이 Error 핸들링 등을 위해서 `UIAlertController`를 사용할 때 좀더 `Controller` 내부에서 간결하게 사용할 수 있다.

```swift
final class AlertBuilder {
    //..중략
    func addAction(_ title: String, style: UIAlertAction.Style, action: (() -> Void)? = nil) -> Self {
        let alertAction = AlertAction(title: title, style: style, completion: action)
        alertActions.append(alertAction)
        
        return self
    }
}
```
위와 같이 `addAction`이라는 메서드를 통해 버튼에 `title`, `style`를 정해주고 `action`이라는 클로저를 통해 이벤트를 구현할 수 있다. 또한, `UIAlertAction`를 계속 추가할 수 있도록 `self`를 반환하여 체이닝이 가능하도록 했다.

```swift
final class AlertBuilder {
    //..중략
    
    func show(_ title: String? = nil, message: String? = nil, style: UIAlertController.Style) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: style)
        alertActions.forEach { action in
            let alertAction = UIAlertAction(title: action.title, style: action.style) { _ in
                action.completion?()
            }
            alertController.addAction(alertAction)
        }
        viewController?.present(alertController, animated: true)
    }
}
```
`addAction`메서드로 `UIAlertAction` 추가가 끝났으면, `show`를 통해 `title`, `message`, `style`를 받아 `UIAlertController` 생성하고, View에 `present`하는 역할을 한다.

### Coredata 및 Snapshot 중복 data 저장
처음 데이터를 만들게 되면 `save`로 저장이 된다. 그 후에 값이 존재하기 떄문에 접근하는 `diary`에는 `nil`이 아니기 떄문에 `save`가 아닌 `update` 로직으로 가게 된다.

그러므로 중복 생성을 막을 수 있다.

```swift
private func finishTask() {
    if let diary = diary {
        delegate?.update(updateDiary(diary))
    } else {
        diary = makeDiary()
        delegate?.save(diary ?? makeDiary())
    }
}
```

### DiaryTextView 은닉화로 인한 메서드 문제
`View`에 속한 `DiaryTextView`를 `ViewController`에서 사용 시 2가지 방법이 있다.
1. `DiaryTextView` 접근제어 해제
2. `DiaryTextView`를 가지는 메서드 구현

첫 번째는 `ViewController`에서 많이 사용하므로 이에 대한 접근제어를 해제하여 계속 생성되는 메서드를 막을 수 있다.

또한 상수이기 때문에 값이 변하지 않다는 것을 알 수 있으므로 해제로 인해 모르는 곳에서 값 변경이 이루어지지 않는다.

두 번째는 `DiaryTextView`의 은닉화를 유지하며 메서드 생성으로 `ViewController`에서 생성하게 한다. 그리하여 직접 접근할 수 없도록 막을 수 있다.

두 가지 방법 다 장단점이 존재한다.
팀 합의를 통해 은닉화를 더 강조하는 방향으로 선택하여 메서드 생성으로 방향을 잡았다.

```swift
// DiaryDetailView.swift
private let diaryTextView: UITextView = {
        let textView = UITextView()
        textView.translatesAutoresizingMaskIntoConstraints = false
        
        return textView
    }()

...

func setFirstResponder() {
    self.diaryTextView.becomeFirstResponder()
}

func relinquishFirstResponder() {
    self.diaryTextView.resignFirstResponder()
}

func readText() -> String {
    return diaryTextView.text
}

func setTextViewAccessory(button: UIToolbar) {
    self.diaryTextView.inputAccessoryView = button
}
```

### background 진입 시 자동 저장
`background` 진입 시 자동 저장할 수 있는 방법으로는 2가지가 있다.

1. `NotificationCenter`
2. `Delegate`

`NotificationCenter` 사용하지 않는 이유는 아래와 같다
첫 번쨰로는,
이 이벤트로 저장을 관리하면 전역적으로 이벤트가 받는 형태라 앱 전반적으로 저장을 알리는 것이 되는 것 같다. 그러므로 이는 불필요하게 모든 곳에 알리는 것이기 때문 지양해야 한다고 생각한다.

두 번째로는,
성능 상으로 `delegate`가 더 우세하다는 것을 볼 수 있다. 실제 동일한 코드로 성능을 비교했을 떄 차이가 나는 것을 볼 수 있다.

그러므로 `delegate`를 사용해서 구현하게 되었다.


### 공유 기능
공유할 `diary`의 제목과 본문을 `Content`에 넣어서 이를 `UIActivityViewController`를 활용해서 전송하도록 한다.
```swift
private func showShareController(_ diary: Diary) {
    let shareContent = "\(diary.title ?? "")\n\(diary.body ?? "")"
    var shareObject = [String]()
    shareObject.append(shareContent)
    let activityViewController = UIActivityViewController(activityItems: shareObject, applicationActivities: nil)
    activityViewController.popoverPresentationController?.sourceView = self.view
    self.present(activityViewController, animated: true)
}
```
