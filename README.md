# 일기장 프로젝트 📖 
> Core Data와 Core Location을 활용한 일기장 어플리케이션

---
## 목차 📋
1. [팀원 소개](#1-팀원-소개)
2. [타임 라인](#2-타임라인)
3. [프로젝트 구조](#3-프로젝트-구조)
4. [실행화면](#4-실행화면)
5. [트러블 슈팅](#5-트러블-슈팅)
6. [Reference](#6-Reference)

<br/>

## 1. 팀원 소개

|[vetto](https://github.com/gzzjk159)| [Christy](https://github.com/christy-hs-lee) | 
| :--------: | :--------: |
|<img height="180px" src="https://cdn.discordapp.com/attachments/535779947118329866/1055718870951940146/1671110054020-0.jpg">| <img height="180px" src="https://i.imgur.com/kHLXeMG.png"> |

<br>

## 2. 타임라인
### 프로젝트 진행 기간
> **23.04.24 (월) ~ 23.05.12 (금)** 

| 날짜 | 타임라인 |
| --- | --- |
| 23.04.24 (월) | SwiftLint설치 및 설정<br/>DiaryItem 구현<br/>AssetDecoder 구현<br/>DiaryTableView 구현 |
| 23.04.25 (화) | DiaryTableViewCell 구현<br/>NavigationItem +버튼 추가<br/>DiaryEditViewController 구현<br/>DateManger 구현 |
| 23.04.26 (수) | 키보드 Layout 설정 |
| 23.04.27 (목) | 리팩토링 진행</br>CoreData 학습 |
| 23.04.28 (금) | README 작성 |
| 23.05.01 (월) | CoreDataManager 구현<br/>CRUD 구현 |
| 23.05.02 (화) | 전체적인 로직 변경 |
| 23.05.03 (수) | UIAlertController를 사용한 Action Sheet 구현 |
| 23.05.04 (목) | swipe 모션 구현<br/>리팩토링 진행 |
| 23.05.05 (금) | AlertManager 구현<br/> 리팩토링 진행 |
| 23.05.08 (월) | title과 body가 공백일 때 처리 로직 구현<br/> CoreLocation 학습 |
| 23.05.09 (화) | WeatherProvider 구현<br/> Migration 학습 |
| 23.05.10 (수) | CoreData Migration 진행 |
| 23.05.11 (목) | WeatherAPI, WeatherProvider 리팩토링 |
| 23.05.12 (금) | CoreLocation을 사용한 icon 저장 구현<br/> icon AutoLayout 설정 |

<br>

## 3. 프로젝트 구조
### 폴더 구조 

<details>
<summary> 폴더 구조 보기 (클릭) </summary>
<div markdown="1">

```swift
├── Diary
│   ├── Application
│   │   ├── AppDelegate.swift
│   │   └── SceneDelegate.swift
│   ├── Controller
│   │   ├── DiaryEditViewController.swift
│   │   └── DiaryMainViewController.swift
│   ├── Diary.xcdatamodeld
│   │   ├── Diary 2.xcdatamodel
│   │   │   └── contents
│   │   └── Diary.xcdatamodel
│   │       └── contents
│   ├── Error
│   │   └── NetworkError.swift
│   ├── Info.plist
│   ├── MappingToV2.xcmappingmodel
│   │   └── xcmapping.xml
│   ├── Model
│   │   ├── DiaryType.swift
│   │   └── WeatherJsonData.swift
│   ├── Network
│   │   ├── WeatherAPI.swift
│   │   └── WeatherProvider.swift
│   ├── Protocol
│   │   └── IdentifierType.swift
│   ├── Resources
│   │   ├── Assets.xcassets
│   │   │   ├── AccentColor.colorset
│   │   │   │   └── Contents.json
│   │   │   ├── AppIcon.appiconset
│   │   │   │   └── Contents.json
│   │   │   └── Contents.json
│   │   └── Base.lproj
│   │       └── LaunchScreen.storyboard
│   ├── Utility
│   │   ├── ActivityViewManager.swift
│   │   ├── AlertManager.swift
│   │   ├── CoreDataManager.swift
│   │   └── DateManager.swift
│   └── View
│       └── DiaryTableViewCell.swift
├── DiaryData+CoreDataClass.swift
├── DiaryData+CoreDataProperties.swift
└── README.md
```
   
</div>
</details>


</br>

## 4. 실행화면

| 첫 실행화면 | + 버튼 눌러서 일기장 생성 | 더보기 버튼 클릭 |
| -------- | -------- | -------- |
| <img src="https://hackmd.io/_uploads/rySUNFsNn.gif" width="200" height="350"> | <img src="https://hackmd.io/_uploads/HywDVKj4h.gif" width="200" height="350"> | <img src="https://hackmd.io/_uploads/rySUNFsNn.gif" width="200" height="350"> |

| 기존의 리스트 수정 | 스와이프 모션 공유창 | 스와이프 모션 삭제 |
| ------ | -------- | -------- |
| <img src="https://hackmd.io/_uploads/B1MtHYsNh.gif" width="200" height="350"> | <img src="https://hackmd.io/_uploads/r1z9HYjEh.gif" width="200" height="350"> | <img src="https://hackmd.io/_uploads/H1S9HFiV2.gif" width="200" height="350"> |

| 가로 화면 |
| -------- |
| <img src="https://hackmd.io/_uploads/HJDcrKsVh.gif" width="350" height="200"> |



<br/>



## 5. 트러블 슈팅
### 1️⃣ Date Formatter의 활용

#### 🔒 문제점 <br/>
샘플로 주어진 데이터 내용 중 `creaded Date`의 숫자가 무슨 의미인지 파악하는 과정에서 문제가 있었습니다. 불특정하게 주어진 숫자값이 시간을 나타내고 있다는 짐작만 될 뿐 정확한 계산값을 찾을 수 없었습니다.

#### 🔑 해결 방법 <br/>
swift의 [date formatter](https://developer.apple.com/documentation/foundation/dateformatter)와 관련된 자료를 찾아보니 아래와 같은 인스턴스를 찾을 수 있었습니다.

- `timeIntervalSinceReferenceDate` : 2001년 1월 1일을 기준으로 해당 시점 이후로 지나간 시간을 계산.
- `timeIntervalSince1970` : 1970년 1월 1일을 기준으로 해당 시점 이후로 지나간 시간을 계산.

`timeIntervalSince1970`을 사용하면 요구사항과 일치하는 시간을 맞출 수 있음을 알게 되었고, 해당 인스턴스를 사용하여 구현했습니다.

<br/>

### 2️⃣ 키보드가 TextView를 가리는 문제

#### 🔒 문제점 <br/>
text를 수정하기 위해 textView를 클릭하게 되면 키보드가 textView위로 올라와 적으려고 한 부분을 가리는 문제가 있었습니다. 따라서 이것을 안 가리게 하기 위해선 notification을 활용하여 textView를 안 가리게 하거나 keyboradLayout을 활용하여 가리지 않게 해주어야 했습니다.

#### 🔑 해결 방법 <br/>
현재는 textView의 bottom을 keyboradLayouGuide의 top으로 맞추어 키보드가 수정하는 부분을 가리지 않게 해주었습니다.

```swift
view.addSubview(textView)
        
NSLayoutConstraint.activate([
    textView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
    textView.bottomAnchor.constraint(equalTo: view.keyboardLayoutGuide.topAnchor),
    textView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
    textView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor)
])
```

<br/>

### 3️⃣ 키보드가 사라지는 방법
#### 🔒 문제점 <br/>
이번 스텝 요구사항에는 일기 자동 저장에 관한 조건이 있었습니다. 해당 조건 중 키보드가 사라지는 경우라는 문구가 애매했습니다. 처음에는 아래의 코드를 사용하여 사용자가 일기를 작성하다 뷰를 드래그할 경우 키보드가 사라지도록 구현했습니다.
```swift
textView.keyboardDismissMode = .onDrag
``` 
하지만 화면 드래그를 사용하여 키보드를 사라지게 하는 방법이 사용성 측면에서 자연스러운지 의문이 들었습니다.

#### 🔑 해결 방법 <br/>
비슷한 사용 방식을 가지고 있는 아이폰의 메모 앱의 방식을 참고하게 되었습니다. 메모 앱의 경우 완료 혹은 뒤로가기 버튼을 터치 할 경우 키보드를 사라지게 해주고 있었습니다. 저희도 해당 방식을 차용하여 네비게이션의 backButton과 rightBarButton을 터치할 경우 키보드가 사라지도록 구현했습니다.
```swift
private func configureUI() {
    let navigationRightButton = UIBarButtonItem(image: image,
                                                style: .plain,
                                                target: self,
                                                action: #selector(ellipsisButtonTapped))
    ...
}
```

rightBarButton의 action에 #selector를 사용하여 버튼을 터치하는 상황을 처리할 수 있는 메서드를 호출시켜 줬습니다.
```swift
@objc
private func ellipsisButtonTapped() {
    textView.resignFirstResponder()
        
    ...
}
```
resignFirstResponder()을 통해 키보드가 내려가도록 설정 했습니다.

<br/>

### 4️⃣ locationManagerDidChangeAuthorization 호출 타이밍
#### 🔒 문제점 <br/>
```swift
func locationManagerDidChangeAuthorization()
```
이라는 메서드는 CLLocationManager()라는 객체가 생성되거나 권한이 바뀔 때 호출됩니다. 하지만 `EditViewController`에선 생성한 CLLocationManager객체를 프로퍼티로 가지고 있어 새로 일기장을 만들 때나 기존에 일기장을 클릭하였을 때 실행해야하는 시점에서 실행되지 않는 문제점이 있었습니다.

#### 🔑 해결 방법 <br/>
```swift
private var locationManager: CLLocationManager?

private func createLocationManager() {
    if diaryType == .new {
        self.locationManager = CLLocationManager()
    }
}
```
옵셔널로 가지고 있다가 CLLocationManager 객체를 생성하는 메서드를 활용하여 `locationManagerDidChangeAuthorization()`메서드의 호출 시점을 자유롭게 지정할 수 있게 하였습니다.

<br/>

## 6. Reference
- [Apple Docs - UITextView](https://developer.apple.com/documentation/uikit/uitextview)
- [Apple Docs - DateFormatter](https://developer.apple.com/documentation/foundation/dateformatter)
- [Apple Docs - Layout](https://developer.apple.com/design/human-interface-guidelines/foundations/layout/)
- [Apple Docs - Keyboard Layout Guide](https://developer.apple.com/documentation/uikit/keyboards_and_input/adjusting_your_layout_with_keyboard_layout_guide)
- [Apple Docs - Core Data](https://developer.apple.com/documentation/coredata)
- [Apple Docs - Core Location](https://developer.apple.com/documentation/corelocation)
- [Apple Docs - Migration](https://developer.apple.com/documentation/coredata/using_lightweight_migration)
- [Apple H.I.G - Typography](https://developer.apple.com/design/human-interface-guidelines/typography)
<br/>

