# 📓 일기장

> 프로젝트 기간: 2022.06.13 ~ 2022.07.01 <br>
> 팀원: [마이노](https://github.com/Mino777), [mmim](https://github.com/JoSH0318), [grumpy](https://github.com/grumpy-sw)
> 리뷰어: ☃️[올라프](https://github.com/1Consumption)

# 📋 목차
- [프로젝트 목표](#-프로젝트-소개)
- [팀원](#-팀원)
- [프로젝트 실행화면](#-프로젝트-실행화면)
- [UML](#uml)
- [타임라인](#-타임라인)
- [PR](#-pr)
- [STEP 1](#step-1)
    + [고민한 점](#고민한-점)
- [STEP 2](#step-2)
    + [고민한 점](#고민한-점)
    + [질문사항](#질문사항)
    + [PR 후 개선사항](#pr-후-개선사항)

## 🔎 프로젝트 소개
개인의 메모, 일기를 날짜별로 저장하는 일기장 App

## 👨‍👦‍👦 팀원
|마이노|MMIM|Grumpy|
|:---:|:---:|:---:|
|<image width="300" src="https://i.imgur.com/lXxd3Mv.png"/>|<image width="300" src="https://i.imgur.com/0KXcn3Z.jpg"/>|<image width="320" src="https://user-images.githubusercontent.com/63997044/174232212-b7d00822-5848-422d-93bf-8bdefd9bd4bd.png"/>|


## 📺 프로젝트 실행화면
|백그라운드 진입<br>(자동 저장)|입력 멈춤<br>(자동 저장)|리스트 화면 이동<br>(자동 저장)|
|:-----:|:----------:|:---:|
|<image width="200" src="https://user-images.githubusercontent.com/63997044/175467898-431d300e-d0f8-4c8e-8191-0e7f707ee30a.gif"/>|<image width="200" src="https://user-images.githubusercontent.com/63997044/175467906-50bb9db3-1450-48cb-8559-cf73f794ed93.gif"/>|<image width="200" src="https://user-images.githubusercontent.com/63997044/175467622-3775e793-9804-4d6e-b58f-0a3f63c8f300.gif"/>|
    
|스와이프|공유|
|:-----:|:----------:|
|<image width="200" src="https://i.imgur.com/Lu1IHo5.gif"/>|<image width="200" src="https://user-images.githubusercontent.com/63997044/175466398-eb6bbcf7-6090-4a9b-9484-686e2e99c888.gif"/>|

## ⏱ 타임라인
|날짜|내용|
|--|--|
|21.06.13(월)|요구사항 파악, 프로젝트 설계|
|21.06.14(화)|STEP1-1, STEP1-2 진행|
|21.06.15(수)|개인공부 진행|
|21.06.16(목)|STEP1 PR 피드백 반영|
|21.06.17(금)|STEP2-1, STEP2-2 진행|
|21.06.20(월)|STEP2-3|
|21.06.21(화)|STEP2 PR|
|21.06.21(수)|개인공부 진행|
|21.06.21(목)|STEP3-1 진행|
|21.06.21(금)|STEP3-2, STEP3 PR|
    
## 👀 PR
- [STEP 1](https://github.com/yagom-academy/ios-diary/pull/3)
- [STEP 2](https://github.com/yagom-academy/ios-diary/pull/12)

## 🛠 개발환경 및 라이브러리
- [![swift](https://img.shields.io/badge/swift-5.6-orange)]()
- [![xcode](https://img.shields.io/badge/Xcode-13.4.1-blue)]()
- [![iOS](https://img.shields.io/badge/iOS-14.0-red)]()

## 🔑 키워드
- `StackView`
- `Json`
- `NavigationBar`
- `TimeInterval`
- `DateFormatter`
- `TableView`
- `NotificationCenter`
- `Keyboard`
- `CoreData`
- `ActivityViewController`
- `UIActivityItemSource`
- `UISwipeActionsConfiguration`
- `AttributedString`

---

## [STEP 1]
    
### 고민한 점
#### 📌 키보드 hide하는 방법
DetailVC는 모든 영역이 TextView이다. 따라서 키보드를 hide하는 방법에 몇가지 고민을 했다.
1. 키보드를 커스텀하여 inputAccessoryView에 키보드를 hide하는 TollBar를 추가하는 방법
2. gesture recognizer를 이용하여 Pan gesture를 했을 때, 키보드를 hide하는 방법
> 2번 방법은 TextView의 스크롤 gesture와 겹친다. 
> 만약 사용자가 화면을 내리는 gesture를 하게 되면, 사용자가 예상하지 못한 동작을 할 수 있다. 
> 따라서 1번 방법을 선택

#### 📌 크래시 방지
유효하지 않은 인덱스를 사용할 때 크래시가 나지 않기 위해 subscript를 활용해 크래시를 방지했다.
```swift
extension Collection {
    subscript(safe index: Index) -> Element? {
        return indices.contains(index) ? self[index] : nil
    }
}
```

```swift 
guard let diary = diaryList[safe: indexPath.row] else {
    return
}
```

#### 📌 편집중인 텍스트가 키보드에 의해 가리지 않게 하는 방법
UITextView의 contentInset을 조정하여 키보드가 화면에 올라왔을 때 텍스트를 가리지 않게 했다.
- 키보드가 올라올 때 UITextView의 bottomAnchor의 constant값을 키보드의 높이만큼 늘인다.
```swift
detailView.adjustConstraint(by: keyboardSize.height)
```
- 키보드가 내려갈 때 UITextView의 bottomAnchor의 constant값을 0으로 되돌린다.
```swift
detailView.adjustConstraint(by: .zero)
```

---

## [STEP 2]
    
### 고민한 점
#### 📌 Key 선택 과정
- 게시물이 생성된 시간 정보인 createdAt을 검색의 키 값으로 사용하려고 했으나 소수점 자리수 표현 때문에 정확한 비교가 되지 않아 Diary와 DiaryEntity에 id라는 Attribute를 생성하여 사용했다.
![](https://i.imgur.com/MEJ9pc1.jpg)

#### 📌 자동저장 및 저장 시점
- 자동저장 및 저장 기능을 구현함에 있어 저장하는 기준과 시점에 대해서 고민했다.
1️⃣ 사용자가 입력을 멈추는 경우(키보드가 사라지는 경우) 
-> keyboardWillHideNotification 등록 -> 키보드가 사라지는 keyboardWillHide() 메서드가 불리는 시점에 자동저장
2️⃣ 앱이 백그라운드로 진입하는 경우
-> didEnterBackgroundNotification 등록 -> app이 백그라운드에 진입하는 didEnterBackground() 메서드가 불리는 시점에 자동저장
3️⃣ 이전 화면(리스트 화면)으로 이동하는 경우 
-> 화면이 사라지는 시점인 viewDidDisappear() 시점에서 저장

#### 📌 ActionSheet 각 버튼 위치
- 요구사항의 예시 화면을 보면 ActionSheet의 버튼순서가 공유, 삭제, 취소 순으로 되어있다.
- HIG에서는 아래와 같이 설명되어 있다.
![](https://i.imgur.com/CWweXKv.png)
- 때문에 삭제처럼 파괴적인(destructive) 선택사항의 경우 가장 상단에 위치하도록 변경했다.

#### 📌 core data persistence 관련 메서드 추상화
- core data의 persistence를 관리하기 위해선 VC에서 아래와 같이 각 메서드를 호출해야 했다.
```swift
PersistenceManager.shared.createData(_)
PersistenceManager.shared.fetchData(_)
PersistenceManager.shared.updateData(_)
PersistenceManager.shared.deleteData(_)
```
- VC는 단순히 파라미터로 정보를 넘기는 역할을 해야하고, 어떠한 메서드를 써야하는지를 알 필요가 없다고 판단했다.
- 또한, PersistenceManager의 캡슐화가 미흡하다는 판단했다.
```swift
enum Method {
    case create(diary: Diary)
    case read
    case update(diary: Diary)
    case delete(_ objectToDelete: DiaryEntity, index: Int? = nil)
}

func execute(by method: Method) {
    switch method {
    case .create(let diary):
        createData(by: diary)
    case .read:
        fetchData()
    case .update(let diary):
        updateData(by: diary)
    case .delete(let objectToDelete, let index):
        deleteData(by: objectToDelete, index: index)
    }
}
// 호출 예시
PersistenceManager.shared.execute(
    by: .delete(objectToDelete, index: indexPath.row)
)
```
- 위와 같은 방법으로 개선했다.

#### 📌 registrationVC: 키보드 관련 Notification 제거
- 자동저장 기능을 구현하기 위해 각각 다음 경우에 대응하기 위한 메서드에 저장 메서드를 호출하였다.
    - 사용자가 입력을 멈추는 경우(키보드가 사라지는 경우): `keyboardWillHide()`
    - 앱이 백그라운드로 진입하는 경우: `didEnterBackground()`
    - 이전 화면으로 이동하는 경우: `viewWillDisappear()`

    그러나 View Controller를 pop하면 save하는 메서드가 두 번 호출되는 현상이 발생하였다.(1. 화면이동시 저장 / 2. 키보드 노티에 의한 저장) 따라서 viewWillDisappear에서 키보드 관련 Notification 제거하여 화면 이동 시 키보드 노티로 인해 저장 메소드가 불리는 현상을 해결하였다.

#### 📌 자동 저장 로직에 의한 리소스 낭비
- 게시물을 삭제하는 경우에도 ViewController가 pop되면서 viewDidDisappear 메서드에서 update 로직을 호출하는 현상 발생 하였다.
- status 값을 만들어 삭제시에는 update 로직을 호출하지 않게 함으로써 해결하였다.

#### 📌 데이터 뒤집어주기
- TableView에 최근 게시물이 가장 상단에 위치하도록 데이터를 fetch할 때 가져온 데이터를 reversed() 메서드를 통해 뒤집어주어 해결하였다.

#### 📌 Title과 Body의 구분
- 실행 예시대로 \n\n을 기준으로 진행하는 경우, 개행을 두번하지 않으면 Title과 Body가 구분되지 않는 현상이 있었다.
- Title의 Font와 FontSize를 변경해주어 UX상 유저에게 Title로 인식을 시켜주고, 제목과 원글의 구분 로직을 \n 기준으로 변경하였다.

#### 📌DetailVC 와 RegistrationVC 합치기
- 공통된 부모 VC를 만들어 상속을 통해 두 VC의 중복 코드를 제거하는 작업을 진행하려고 했다.
- 하지만 진행하다보니, 대부분의 메서드가 기능적인 부분에서 조금씩 달랐다.
- 그러다보니 나중에 혹시라도 기획적인 부분에서 각 화면에 변화가 생긴다면, 신경써주어야 하는 부분이 많아지고 오히려 코드가 더러워질 수 있겠다는 생각이 들다.
- 따라서 차라리 두 객체로 관리하는게 좋다고 판단하여 분리하였다.

### 질문사항
#### 📌 name space관련 질문: 1) class 안에 private enum 으로 만들어줄지 2)public enum -> file private enum으로 만들어줄지
- 현재 Name Space를 Class안에 private enum이 아닌, 외부에 2개 이상의 파일에서 사용되는 공통된 상수들을 관리하는 enum을 만들고, 
- 하나의 파일에서만 사용하는 경우 해당 파일에서 fileprivate으로 extension 하여 사용하였습니다.  
- 어떤식으로 관리하는 것이 좋을까요?
 
#### 📌 은닉화 관련 질문
- 저희 코드에서 `MainView > baseTableView`는 은닉화하지 않고 VC에서 다음과 같은 쓰이고있습니다.
    - delegate, dataSource를 설정
    - baseTableView.deleteRows으로 baseTableView의 해당 index를 삭제
    - VbaseTableView.reloadData()
- 사실 baseTableView을 private하고 convenient init이나 메서드를 통해서 위와 같은 경우를 설정해줄 수 있습니다.
- 은닉화를 꼭 하는 것이 옳은 것인지, 필요에 따라서 은닉화를 안해도 되는 것인지 고민이 됐습니다.
- 어떤 것이 옳은 방법일까요 🥹
 
 
### PR 후 개선사항
#### 📌 core data persistence 관련 추상화된 메서드 제거 및 
- 리뷰어 코멘트
> 이전 코드 또한 method 매개변수로 인해 VC가 어떤 동작을 하는지 구체적으로 알아야합니다. 무조건 감춘다고 캡슐화가 되는건 아닙니다. 이미 CRUD에 해당하는 부분은 잘 캡슐화를 해주셨어요. 굳이 또 감쌀 필요는 없어보입니다.
- 위와 같은 코멘트를 받고 execute 메서드 제거했다.
- createData(), fetchData(), updateData(), deleteData()를 캡슐화된 CRUD 메서드로 사용하는 방법으로 변경했다.

#### 📌 상태값(status)과 코어 데이터 저장의 역할 이동
- 리뷰어 코멘트
> 저는 ViewController도 View라고 보고 있어요.
또한 이부분은 로직이기 때문에 Controller보다는 model의 역할에 더 가깝다고 생각됩니다.
- 위와 같은 코멘를 받고 VC도 View라고 생각하게 됐다.
- View가 status나 data 저장하는 로직을 갖는 것이 View의 역할에 맞지 않는다고 판단했다.
- 해당 View의 ViewModel을 만들어 위와 같은 값을 갖도록 변경했다. 

#### 📌 소스코드 내에서 사용하는 상수 관리
- 여러 곳에서 사용하는 전역 상수의 경우에만 `AppConstants`로 사용하고 한 곳에서만 사용하는 경우 각 타입마다 `private enum Constants`로 생성하여 관리하도록 변경했다.

#### 📌 에러 발생 시 사용자에게 에러 관련 Alert 띄우기
- 코어 데이터를 사용하면서 발생할 수 있는 에러를 `DiaryError`로 정의하고 에러 발생 시 사용자에게 에러에 대한 메시지를 Alert을 통해 띄우도록 에러 핸들링을 만들었다.

