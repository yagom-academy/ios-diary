# 📓 일기장

> 프로젝트 기간: 2022.06.13 ~ 2022.07.01 <br>
> 팀원: [Donnie](https://github.com/westeastyear), [OneTool](https://github.com/kimt4580)
> 리뷰어: [또치](https://github.com/TTOzzi)

<br>

## 🔎 프로젝트 소개
### "기억하지 말고 기록하세요! 여러분의 기억을 일기장이 대신 저장해드립니다!"

<br>

## 📺 프로젝트 실행화면
|View가 사라지면 자동 저장|Swipe Action|ActionSheet / Alert|
|:--:|:--:|:--:|
|<img src="https://i.imgur.com/TdhIFVr.gif" width="100%">|<img src="https://i.imgur.com/80NxVga.gif" width="100%">|<img src="https://i.imgur.com/jNcOOVG.gif" width="100%">|

|내용 업데이트|백그라운드 진입시 자동저장|날씨 아이콘 표시|
|:--:|:--:|:--:|
|<img src="https://i.imgur.com/63HulWh.gif" width="100%">|<img src="https://i.imgur.com/4MqRzE7.gif" width="100%">|<img src = "https://i.imgur.com/52PCeXX.gif" width = "100%"><br>|

<br>

## 👀 PR

[STEP 1](https://github.com/yagom-academy/ios-diary/pull/10)
[STEP 2](https://github.com/yagom-academy/ios-diary/pull/21)
[STEP 3](https://github.com/yagom-academy/ios-diary/pull/33)

<br>

## 🛠 개발환경 및 라이브러리
- [![swift](https://img.shields.io/badge/swift-5.6-orange)]()
- [![xcode](https://img.shields.io/badge/Xcode-13.4.1-blue)]()
- [![iOS](https://img.shields.io/badge/iOS-14.0-red)]()

<br>

## 🔑 키워드
`CollectionView` `MVC` `Keyboard` `ContentInset` `Padding` `ScrollView` `StackView` `Json` `NavigationBar` `TimeInterval` `DateFormatter` `CoreData` `NotificationCenter` `CoreData(CRUD)` `Cell Swipe Action` `Activity View` `Action Sheet` `Alert` `subscript` `URL` `CoreLocation` `Network` `API` `ImageView` `Migration`

<br> 

## 📑 구현내용
### [STEP 1]
- 사용자의 지역에 따른 "년월일" 형식을 `DateFormatter`로 유연하게 구현
    - `timeIntervalSince1970`를 활용하여 날짜계산 및 처리
- `Storyboard`없이 코드를 이용하여 `UI`구현 
- `Model` 생성 후 `decode`를 하여, `data` 사용
- `CollectionView`를 활용, `ListCell` 구현
- `Navigation Controller`를 활용하여, `View` 및 `ViewController` 전환
- `UIResponder`, `NotificationCenter`, `keyboardWillShow`, `keyboardWillHide`를 사용하여, Keyboard 구현

### [STEP 2]
- `CoreData`를 활용하여 `Local`디바이스에 데이터를 CRUD(`create`, `read`, `update`, `delete`)하는 기능 구현
- `CollectionViewListCell`를 `Swipe`하여 `Share`, `Delete`하는 기능 적용 및 구현
- `ActionSheet`와 `Alert`의 활용
- 하나의 `View`를 두개의 `ViewController`에서 사용하도록 로직 구현
- `Keyboard`의 높이만큼 `ScrollView`에 `inset`을 주어 내용을 가리지 않도록 구현
- `Array`를 확장하고 `subscript`를 활용하여 `index out of range` 오류처리 기능 구현

### [STEP 3]
- 사용자에게 위치정보 활용에 대한 권한을 받는 기능 구현
- `URL`을 활용하여, 통신하여 위도, 경도 및 해당 지역 날씨에 해당하는 icon의 이미지를 넣어주는 기능 구현
- CoreData Migration을 활용하여, Model 변경

<br>

## 📖 학습한 내용
### [STEP 1]
- `TimeInterval`을 활용하여 날짜 계산하기 
> dateStyle : .full 인 경우 → 2022년 6월 17일 금요일
dateStyle : .long 인 경우 → 2021년 6월 17일
dateStyle : .medium 인 경우 → 2022. 6. 17.
dateStyle : .short 인 경우 → 2022. 6. 17.

>timeStyle : .full 인 경우 → 오후 4시 28분 39초 대한민국 표준시
timeStyle : .long 인 경우 → 오후 4시 29분 39초 GMT+9
timeStyle : .medium 인 경우 → 오후 4:29:39
timeStyle : .short 인 경우 → 오후 4:29

> 출처 : https://roniruny.tistory.com/147

- `Date Formatter`로 사용자의 지역에 따른 "년월일" 형식을 다르게 구현하는 방법

### [STEP 2]
- CoreData

`CoreData`는 `Framework`로, `permanent data`를 저장하여 활용할 수 있다. 하지만 `CoreData`는 `Database`로 볼 수 없다. 넓은 의미로 앱의 모델 계층이고, 객체 그래프를 관리하는 `Framework`이다.

- Collection View Swipe Action

`Collection View`에서 `Swipe Action`을 활용하기 위해서는, `UICollectionLayoutListConfiguration`의 `trailingSwipeActionsConfigurationProvider`를 활용하면 된다. `trailingSwipeActionsConfigurationProvider`에서 `UIContextualAction`을 활용하여, `Action`을 설정해주면 된다.
```swift
private var listLayout: UICollectionViewCompositionalLayout {
        var configure = UICollectionLayoutListConfiguration(appearance: .plain)
        configure.showsSeparators = true
        configure.backgroundColor = .clear
        configure.trailingSwipeActionsConfigurationProvider = { [weak self] indexPath in
            let share = UIContextualAction(style: .normal, title: nil) { [weak self] _, _, completion in
                guard let diaryTitle = self?.diaryData[indexPath.row].title else {
                    return
                }
                let activityViewController = UIActivityViewController(
                    activityItems: [diaryTitle],
                    applicationActivities: nil
                )
                self?.present(activityViewController, animated: true)
                completion(true)
            }
            share.image = UIImage(systemName: DiaryConstants.cellSwipeShareButton)
            share.backgroundColor = .systemBlue
            
            let delete = UIContextualAction(style: .destructive, title: nil) { [weak self] _, _, completion in
                guard let diaryData = self?.diaryData[indexPath.row] else {
                    return
                }
                self?.persistenceManager.delete(diary: diaryData)
                self?.diaryData.remove(at: indexPath.row)
                self?.collectionView.deleteItems(at: [indexPath])
                completion(true)
            }
            delete.image = UIImage(systemName: DiaryConstants.cellSwipeDeleteButton)
            return UISwipeActionsConfiguration(actions: [delete, share])
        }
        return UICollectionViewCompositionalLayout.list(using: configure)
    }
```
- NotificationCenter를 활용한 background Task

`background` 상태에 진입하고 나서, `Task`를 원한다면 `didEnterBackgroundNotification`에 대한 `Observer`를 추가해주면 된다.
```swift
  NotificationCenter.default.addObserver(
            self,
            selector: #selector(/*@objc method*/),
            name: UIApplication.didEnterBackgroundNotification,
            object: nil
        )
```
<br>

### [STEP 3]
- ViewModel과 Controller의 관계
처리가 필요한 로직들은 대부분 ViewModel에서 처리해주고, Controller는 사용자에게 입력 받은 값만 넘겨주는 역할 이라는 것을 알았다. MVVM 패턴에 대해서 조금이나마 학습하게 되었다.

- MVVM 구조

<img src="https://i.imgur.com/za6oQgQ.png" width="60%">
<br>
>Model: 어플리케이션에서 사용되는 데이터와 그 데이터를 처리하는 부분
View : 사용자에게 보여지는 UI
View Model : View를 나타내주기 위한 Model이며, View를 나타내기 위한 데이터 처리를 하는 부분

- MVVM 동작 순서
> User의 Action -> View -> View Model -> Model -> View Model -> Data Binding -> UI

- MVVM 특징
> Command 패턴 + Data Binding 패턴을 사용하여 구현, View와 View Model 사이의 의존성을 없애고, View Model과 View의 관계를 1:n 관계로 만들었다. View와 View Model이 독립적이기 때문에, 모듈화가 가능하다. 하지만, View Model의 설계 난이도가 상당히 높다.
>> [Design Pattern 커맨드 패턴이란](https://gmlwjd9405.github.io/2018/07/07/command-pattern.html)
>> [Data Binding in MVVM on iOS](https://beenii.tistory.com/124)

## 🚀 trouble shooting

### [STEP 1]
### 1. JSON견본 파일에 있는 created_At 숫자의 의미를 알아내고, 사용자의 지역에 따라 날짜 포맷을 다르게 하기 위해 고민하였습니다. 

- JSON견본 파일에 있는 createdAt의 숫자의 의미를 알아내기 위해 다른 캠퍼들과 이야기를 나누었고, 어떻게 처리해야 하는가에 고민을 하였습니다.
- 그러면서 사용자가 설정하는 지역에 따라 다르게 포맷을 주어야 했어서 TimeInterval을 확장하였고, 아래와 같은 formattedDate라는 연산 프로퍼티를 만들게 되었습니다.

```swift
extension TimeInterval {
    var formattedDate: String {
        let dateFormatter = DateFormatter()
        let localID = Locale.preferredLanguages.first
        let deviceLocale = Locale(identifier: localID ?? "ko-kr").languageCode
        dateFormatter.dateStyle = .long
        dateFormatter.locale = Locale(identifier: deviceLocale ?? "ko-kr")
        dateFormatter.timeZone = TimeZone.current
        return dateFormatter.string(from: Date(timeIntervalSince1970: self))
    }
}
```

<br>

### 2. 캡슐화를 준수하기 위해 고민하였습니다.

![](https://i.imgur.com/FpnakIj.png)

![](https://i.imgur.com/qSHhmED.png)

![](https://i.imgur.com/T5HPVXU.png)

- 캡슐화를 하기 위해서, `private`을 모두 사용해주려고 하였으나, ViewController에서 Keyboard의 높이를 조정할 때 `mainScrollView`와 `descriptionView`를 사용해야했습니다. 이러한 경우에는 캡슐화를 어떻게 해주는 게 좋을까요? 
>`KeyboardLayoutGuide`를 사용해면 해결되겠지만, iOS 15이상이라서 지양했습니다!

---

### [STEP 2]
### 1. CoreData Attribute, Properties와 Model Type
- 방법이 두가지가 있다고 생각했습니다. 
>1. Entity를 각 ViewController가 가지고 있게 만들고, 직접적으로 CoreData에 접근하는 방식
>2. Entity를 생성해두었던 Model이랑 Type을 맞춰주어서 직접 Entity로 접근하는 것이 아닌 Model을 통하여 접근하는 방식

직접적인 접근은 안전하지 않을 것 같아서, 2번을 선택해 주었습니다.
```swift
//
//  DiaryEntity+CoreDataProperties.swift
    @NSManaged public var body: String?
    @NSManaged public var createdAt: Date
    @NSManaged public var title: String?
    @NSManaged public var id: String
```
```swift
//
//  DiaryModel.swift
struct DiaryModel: Decodable {
    let title: String?
    let body: String?
    let createdAt: Date
    let id: String
    
    private enum CodingKeys: String, CodingKey {
        case createdAt = "created_at"
        case title, body, id
    }
}
```
![](https://i.imgur.com/aiC97M9.png)

---
### [STEP 3]

### 1. 프로퍼티로 icon 데이터를 저장하는 방식에 대해서
- 현재 `RegisterViewController`에서 diaryModel에 데이터가 있는지 없는지에 대해서, 분기처리를 해주었습니다. 
- 그로 인해서 icon의 데이터를 CoreData에 저장을 해준 후, 실행하게되면 데이터 유무를 체크해주는 로직에서 CoreData에 create만 진행하게 됩니다. 
- 계속해서 CoreData 자원을 사용하게 됩니다. 그래서 직접적으로 CoreData의 DiaryData에 icon에 대한 정보를 저장해주었고, `RegisterViewController`에서 사용되는 diaryModel에는 데이터의 유무를 판단할 수 있는 분기처리용 로직을 유지되게 하였습니다.

```swift
private var icon: String?

private func sendDiaryViewModel() {
        do {
            try diaryViewModel.checkDiaryData(
                title: detailView.titleField.text,
                body: detailView.descriptionView.text,
                icon: icon
            )
        } catch {
            showAlert(alertMessage: error.localizedDescription)
        }
    }
}
```
