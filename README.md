# 일기장 프로젝트 📔
## 🪧 목차

- [📜 프로젝트 내용](#📜-프로젝트-내용)
- [💡 활용한 개념](#💡-활용한-개념)
- [👨‍👨‍👦‍👦 팀원 및 리뷰어](#👨‍👨‍👦‍👦-팀원-및-리뷰어)
- [🗓 타임라인](#🗓-타임라인)
- [📱 실행 화면](#📱-실행-화면)
- [📪 Pull Request](#📪-Pull-Request)
- [🔫 트러블 슈팅](#🔫-트러블-슈팅)
- [🔗 참고 링크](#🔗-참고-링크)

<br>

## 📜 프로젝트 내용
> 작성된 일기목록, 일기 상세내용 화면으로 구성된 앱입니다.
>
> 일기의 생성, 수정, 삭제가 가능하며 리스트 형태로 조회가 가능합니다.
>
> 코어 데이터를 활용하여 앱이 꺼져도 데이터를 저장할 수 있습니다.
>
> 작성된 일기를 텍스트 형태로 공유할 수 있습니다.
>
> 가로/세로 모드 및 다크모드에 대응합니다.

## 💡 활용한 개념
- MVC 아키텍처 활용
- List Style의 일기 목록 화면구성
  - CollectionView
  - DiffableDataSource
  - CompositionalLayout(Default List Style, Trailing Swipe gesture)
  - Custom Cell 
- CoreData(CRUD)
- Codable, Hashable
- TextView
- Notification - Keyboard event, didEnterBackgroundNotification
- Localization
- ActionSheet 

<br>

## 👨‍👨‍👦‍👦 팀원 및 리뷰어
- **minsson**🎾 [민쏜 깃허브](https://github.com/minsson)

- **Borysarang**🌾 [보리사랑](https://github.com/yusw10)

- 리뷰어: **라이언**🦁 [라이언 깃허브](https://github.com/ryan-son)

<br>

## 🗓 타임라인
> **프로젝트 기간** : 22.08.16 ~ 22.09.02

### 1주차 
**8월 16일 (화):** 
- 프로젝트 시작
- 스토리보드 삭제 및 코드 기반으로 프로젝트 초기 설정
- 다이어리 리스트 뷰 네비게이션 아이템 구현


**8월 17일 (수):**
- 일기장 모델 타입 및 날짜 지역화 메서드 구현
- 다이어리 리스트를 표시할 컬렉션 뷰 구현 (DiffableDataSource 활용


**8월 18일 (목):**
- 일기 작성/조회/수정을 위한 텍스트 뷰 구현
- 기존 일기 조회 기능 구현


**8월 19일 (금):**
- 일기 편집시 키보드가 글을 가리지 않도록 개선
- 키보드 상단을 쓸어내릴시 자연스럽게 키보드가 dismiss되는 기능 추가
- 일기 본문 가독성 향상을 위해 좌우 간격 추가
- STEP1 Pull Request

### 2주차
**8월 22일 (월):**
- STEP1 Pull Request 코멘트 수정
  - DiaryDetailViewController 구조 리팩토링
  - DiaryListViewController 구조 리팩토링

**8월 23일 (화):**
- STEP1 Pull Request 코멘트 수정
  - Notification 중복 등록 문제 수정
  - 생성일 Localization 적용안되는 문제 수정

**8월 24일 (수):**
- CoreData 구현
  - 코어 데이터 관리를 위한 싱글턴 객체 구현
  - Create, Fetch기능 구현

**8월 25일 (목):**
- CoreData 구현
  - Update, Delete 기능 구현

**8월 26일 (금):**
- 일기 정보를 CoreData를 활용하여 저장하고 사용하도록 ViewController들을 리팩토링
  - DiffableDataSource의 SnapShot에 적용될 데이터를 CoreData에서 fetch한 데이터를 사용하도록 리팩토링
  - 상세 화면의 rightBarButton에 적용된 delete 기능 적용

### 3주차
**8월 29일 (월): ViewController Refacotring**
- 리팩토링
  - List ViewController와 Detail ViewController의 공통 기능을 상위 class로 분리

**8월 30일 (화):STEP2 PR**
- File Hierarchy를 Group By Feature 형태로 변경
- STEP2 PR 메시지 작성 및 정리
- STEP2 Pull Request

**8월 31일 (수):URLSession**
- URLSession의 dataTask 복습

**9월 01일 (목):**
- 날씨 OpenAPI 작동 테스트
- CoreData Migration 에러처리

**9월 02일 (목): README.md 작성**
- README.md 작성

<br>

## 📱 실행 화면

|일기 목록 화면|일기 상세 화면|
|:-----------:|:----------:|
| <img src=https://i.imgur.com/mHmsPVo.png width=100%> | <img src=https://i.imgur.com/vsf5hUf.png width=100%> |


|일기 삭제|일기 공유|
|:-----------:|:----------:|
| <img src=https://i.imgur.com/XzrDuSa.gif width=100%> | <img src=https://i.imgur.com/FQnLXtP.gif width=100%> |



<br>

## 📪 Pull Request

### [STEP1 Pull Request 링크](https://github.com/yagom-academy/ios-diary/pull/41)

### [STEP2 Pull Request 링크](https://github.com/yagom-academy/ios-diary/pull/53)

<br>

## 🔫 트러블 슈팅

### STEP 1
#### 4.1 키보드가 텍스트를 가리는 문제

|수정 전|수정 후|
|:-----------:|:----------:|
| ![](https://i.imgur.com/NcD6svP.gif)| ![](https://i.imgur.com/hPeHIK2.gif)|




일기 작성/수정/조회 화면에서 화면 하단 쪽에 위치한 텍스트를 탭할 경우 키보드가 올라오면서 커서가 가려지는 문제가 있었습니다. 처음에는 `UITextView`의 인스턴스 프로퍼티에 `textPopUpMode`와 같은 프로퍼티를 통해 해결할 수 있을 것이라고 예상했지만, 그런 프로퍼티는 없었습니다.

구글링을 통해 이를 해결하기 위한 여러가지 방법을 찾아보았고, 그 중 가장 간단하다고 생각한 방법을 선택했습니다. 해결 방법은 아래와 같습니다.

**해결방법**
**1) UIResponder.KeyboardWillShowNotification 수신**

```swift=
func setupKeyboardWillShowNoification() {
    NotificationCenter.default.addObserver(
        self,
        selector: #selector(keyboardWillShow(_:)),
        name: UIResponder.keyboardWillShowNotification,
        object: nil
    )
}
```

**2) 수신 시 텍스트 뷰의 `contentInset.bottom`을 키보드 높이 및 원하는 여유분만큼 할당**
```swift=
@objc func keyboardWillShow(_ sender: Notification) {
    let keyboardFrame = sender.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect
    guard let keyboardFrame = keyboardFrame else {
        return
    }
        
    let keyboardHeight: CGFloat = keyboardFrame.height + 50
    contentTextView.contentInset.bottom = keyboardHeight
}
```



### STEP 2
PR 리뷰 후 작성예정

<br>

## 🔗 참고 링크

[커밋스타일 - 카르마](https://karma-runner.github.io/6.4/dev/git-commit-msg.html)

[컨벤션 - 스타일쉐어](https://github.com/StyleShare/swift-style-guide)

[UICollectionView](https://developer.apple.com/documentation/uikit/uicollectionview)
