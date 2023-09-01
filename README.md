# 📓 일기장
## 📝 소개
> 일기를 생성하고 작성 후에 저장할 수 있는 앱입니다.

**프로젝트 기간 : 23/08/28~23/09/15**

</br>

## 📖 목차
1. [팀원 소개](#1.)
2. [타임 라인](#2.)
3. [시각화 구조](#3.)
4. [실행 화면](#4. )
5. [핵심 경험](#5.)
6. [트러블 슈팅](#6.)
7. [참고 자료](#7.)
8. [팀 회고](#8.)

<a id="1."></a></br>
## 👨‍💻 팀원 소개
|<Img src = "https://hackmd.io/_uploads/rJj1EtKt2.png" width="200" height="200">|<Img src = "https://user-images.githubusercontent.com/109963294/235301015-b81055d2-8618-433c-b680-58b6a38047d9.png" width ="200" height="200"/>|
|:-:|:-:|
|[**Yetti**](https://github.com/iOS-Yetti)|[**idinaloq**](https://github.com/idinaloq)|

<a id="2."></a></br>
## ⏰ 타임 라인
|날짜|내용|
|:--:|--|
|2023.08.28.|메인 스토리보드 삭제<br>SceneDelegate에 rootViewController 추가<br>SwiftLint적용|
|2023.08.29.|SwiftLint설정 변경<br>DiaryListViewController구현<br>DiaryCollectionViewListCell구현<br>DiaryEntity구현<br>DiaryDetailViewController생성|
|2023.08.30.|DateFormatter 기능확장<br>키보드 사용을 위한 setUpKeyboardEvent() 메서드 추가<br>NewDiaryViewController 구현<br>리팩토링<br>|
|2023.08.31.|KeyboardManager 클래스로 키보드 기능분리<br>LocaleIdentifier타입 생성<br>리팩토링|
|2023.09.01.|README작성|

<a id="3."></a></br>
## 👀 시각화 구조
### 1. File Tree
    Diary
    ├── Model
    │   └── DiaryEntity.swift
    ├── View
    │   ├── LaunchScreen.storyboard
    │   └── DiaryCollectionViewListCell.swift
    ├── Controller
    │   ├── DiaryListViewController.swift
    │   ├── DiaryDetailViewController.swift
    │   └── NewDiaryViewController.swift
    ├── Enum
    │   └── LocaleIdentifier.swift
    ├── Error
    │   └── DecodingError.swift
    ├── Extension
    │   ├── Array+.swift
    │   └── DateFormatter+.swift
    ├── Manager
    │   └── KeyboardManager.swift
    ├── Resource
    │   ├── AppDelegate.swift
    │   ├── SceneDelegate.swift
    │   └── Assets.xcassets
    ├── Info.plist
    └── Diary.xcdatamodeld

### 2. 클래스 다이어그램
![일기장 UML](https://github.com/iOS-Yetti/ios-diary/assets/100982422/288cd6d5-b1e0-4153-9f04-d34949f0cba5)

<a id="4."></a></br>
## 💻 실행화면

|실행화면(세로)|
|:---:|
|<Img src = "https://github.com/idinaloq/testRep/assets/124647187/98772ca6-e84c-45dd-a96c-28ff4806c90c">|

|실행화면(가로)|
|:---:|
|<Img src = https://github.com/idinaloq/testRep/assets/124647187/24161461-538a-44de-991b-63375559cc07 >|

<a id="5."></a></br>
## 🧠 핵심경험

### 1️⃣ NotificationCenter를 활용한 키보드 설정
- 텍스트를 수정할 때 키보드가 텍스트를 가리지 않도록 NotificationCenter의 [keyboardWillShowNotification](https://developer.apple.com/documentation/uikit/uiresponder/1621576-keyboardwillshownotification), [keyboardWillHideNotification](https://developer.apple.com/documentation/uikit/uiresponder/1621606-keyboardwillhidenotification)를 활용해 키보드가 나타나고, 사라질 때의 동작을 구현했습니다.
<details>
    <summary>상세코드</summary>

```swift
import UIKit

final class KeyboardManager {
    private let textView: UITextView
    
    init(textView: UITextView) {
        self.textView = textView
        setUpKeyboardEvent()
    }
    
    private func setUpKeyboardEvent() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    @objc private func keyboardWillShow(_ notification: Notification) {
        guard let userInfo = notification.userInfo as NSDictionary?,
              var keyboardFrame = (userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue else {
            return
        }
        
        keyboardFrame = textView.convert(keyboardFrame, from: nil)
        var contentInset = textView.contentInset
        contentInset.bottom = keyboardFrame.size.height
        textView.contentInset = contentInset
        textView.verticalScrollIndicatorInsets = textView.contentInset
    }
    
    @objc private func keyboardWillHide() {
        textView.contentInset = UIEdgeInsets.zero
        textView.verticalScrollIndicatorInsets = textView.contentInset
    }
}

```
    
</details>

### 2️⃣ DateFormatter
- [DateFormatter](https://developer.apple.com/documentation/foundation/dateformatter)를 활용해 현재 날짜, 변환 하려는 날짜를 Locale과 TimeZone에 맞는 형식으로 출력하도록 했습니다.

<details>
    <summary>상세코드</summary>

```swift
import Foundation

extension DateFormatter {
    static var today: String {
        let dateFormatter: DateFormatter = DateFormatter()
        let date: Date = Date(timeIntervalSinceNow: 0)
        dateFormatter.locale = Locale(identifier: LocaleIdentifier.KOR.description)
        dateFormatter.timeZone = TimeZone(identifier: TimeZone.current.identifier)
        dateFormatter.dateStyle = .long
        
        return dateFormatter.string(from: date)
    }
    
    func formatDate(_ data: DiaryEntity, locale: LocaleIdentifier) -> String {
        let dateFormatter: DateFormatter = DateFormatter()
        let date: Date = Date(timeIntervalSince1970: TimeInterval(data.createdAt))
        dateFormatter.locale = Locale(identifier: locale.description)
        dateFormatter.timeZone = TimeZone(identifier: TimeZone.current.identifier)
        dateFormatter.dateStyle = .long
        
        return dateFormatter.string(from: date)
    }
}
```
    
</details>

### 3️⃣ subscript
- 배열에 범위를 벗어난 접근을 할 때 크래시가 발생하지 않도록 [subscript](https://developer.apple.com/documentation/foundation/data/3017410-subscript)를 사용해서 nil로 설정될 수 있도록 extension으로 Array의 기능을 확장했습니다.

<a id="6."></a></br>
## 🧨 트러블 슈팅

### 1️⃣ out of bound 
⚠️ **문제점** <br>
- collectionView 메서드에서 셀을 생성할 때, diaryEntity 배열에 indexPath.item으로 접근을 해서 데이터를 가져오고 있었습니다. 하지만 이렇게 되면 만약 diaryEntity 배열을 벗어난 indexPath로 접근을 하게되면 앱이 크래시가 날 수 있는 가능성이 있었습니다.

**기존코드**
```swift
extension DiaryListViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    ...
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: DiaryCollectionViewListCell.identifier, for: indexPath) as? DiaryCollectionViewListCell else {
            return UICollectionViewCell()
        }
        
        guard let diaryEntity = diaryEntity else {
            return UICollectionViewCell()
        
        cell.configureLabel(diaryEntity[indexPath.item])
        
        return cell
    }
    ...
}
```

✅ **해결방법** <br>
- 배열에 잘못된 접근을 할 때(범위를 벗어난 접근) nil이 설정되도록 subscript를 사용해서 안전하게 배열에 접근할 수 있도록 array에 기능을 추가했고, diaryEntity가 nil일 때 빈 셀을 반환하는 부분도 그에 맞게 수정을 다음과 같이 진행했습니다.

**현재코드**
```swift
extension Array {
    subscript(index index: Int) -> Element? {
        return self.indices ~= index ? self[index] : nil
    }
}

extension DiaryListViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    ...
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: DiaryCollectionViewListCell.identifier, for: indexPath) as? DiaryCollectionViewListCell else {
            return UICollectionViewCell()
        }
        
        guard let diaryIndex = diaryEntity?[index: indexPath.item] else {
            return cell
        }
        
        cell.configureLabel(with: diaryIndex)
        
        return cell
    }
    ...
}
```

<a id="7."></a></br>
## 📚 참고자료

- [🍎 Apple Docs: `DateFormatter`](https://developer.apple.com/documentation/foundation/dateformatter)
- [🍎 Apple Docs: `NotificationCenter`](https://developer.apple.com/documentation/foundation/notificationcenter)
- [🍎 Apple Docs: `keyboardWillShowNotification`](https://developer.apple.com/documentation/uikit/uiresponder/1621576-keyboardwillshownotification)
- [🍎 Apple Docs: `keyboardWillHideNotification`](https://developer.apple.com/documentation/uikit/uiresponder/1621606-keyboardwillhidenotification)
- [🍎 Apple Docs: `UITextView`](https://developer.apple.com/documentation/uikit/uitextview)
- [🌐 Blog: `subscript로 안전하게 배열 조회하기`](https://kkimin.tistory.com/86)
- [🌐 Blog: `키보드가 텍스트를 가리지 않도록 하기`](https://velog.io/@qudgh849/keyboard가-TextView를-가릴-때)
- [🌐 Blog: `identifier 재사용 프로토콜`](https://prod.velog.io/@yyyng/셀-재사용-프로토콜)

<a id="8."></a></br>
## 👬 팀 회고
프로젝트가 끝난 후 작성 예정입니다 (23.09.15)
