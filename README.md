# 📔 일기장 📔
<br>

## 📜 목차
1. [소개](#-소개)
2. [개발환경 및 라이브러리](#-개발환경-및-라이브러리)
3. [팀원](#-팀원)
4. [타임라인](#-타임라인)
5. [UML](#-UML)
6. [실행화면](#-실행-화면)
7. [트러블 슈팅 및 고민](#-트러블-슈팅-및-고민)
8. [참고링크](#-참고-링크)

<br>

## 🗣 소개
[Ayaan🦖](https://github.com/oneStar92), [zhilly🔥](https://github.com/zhilly11) 이 만든 Core Data를 활용한 일기장 애플리케이션 입니다.

***개발 기간 : 2022-12-19 ~ 2022-12-23***

<br>

## 💻 개발환경 및 라이브러리
[![iOS](https://img.shields.io/badge/iOS_Deployment_Target-15.0-blue)]()
[![swift](https://img.shields.io/badge/Xcode_Compatible-9.3-orange)]()

<br>

## 🧑 팀원
|Ayaan|zhilly|
|:---:|:---:|
|<img src= "https://i.imgur.com/Unq1bdd.png" width ="200"/>|<img src = "https://i.imgur.com/UGDRDhT.png" width=200 height=200>|

<br>

## 🕖 타임라인

### STEP 1 - [22.12.19 ~ 22.12.23]
- 22.12.20
    - SwiftLint 적용
    - DiaryTableView Type 구현
    - DiaryCell Type 구현
- 22.12.21
    - DiaryView Type 구현
    - DiaryListViewController Type 구현
    - DiaryViewController Type 구현
    - Keyboard 관련 기능구현
    - DiaryTextView의 PlaceHolder 기능구현
- 22.12.22
    - 코드 리팩터링
    - 매직 리터럴 제거

<br>

## 📊 UML
Step2 CoreData Model 구현 후 작성 예정

<br>

## 💻 실행 화면
Step2 구현 후 추가 예정


<br>

## 🎯 트러블 슈팅 및 고민

### **MainStoryboard없이 Code로 구현**

<details>
<summary>자세히보기</summary>
<div markdown="1">
    
- 요구사항에 코드로만 UI를 작성하라는 문구가 있어서 시도해보았습니다.
    1. Main.storyboard 삭제
    2. info.plist에서 storyboard관련 삭제
    3. SceneDelegate에서 ViewController로 이동할 수 있도록 RootViewController 설정

- 이와 같이 진행하고 실행시에 Main스토리보드 관련하여 에러가 뜨는 것을 확인했습니다
    1. 프로젝트 설정에서 Info탭에서 추가로 StoryBoard관련해서 삭제
    2. Build Settings에서 main storyboard관련 삭제 ![](https://i.imgur.com/6IpdAis.png)

- 위의 추가 과정을 통해 Main 스토리보드 없이 프로젝트를 진행할 수 있었습니다!
        
</div>
</details>

### **NavigationBar 구분선**

<details>
<summary>자세히보기</summary>
<div markdown="1">
    
- MainStoryboard가 없이 코드로만 UI를 구성해 봤습니다. `NavigationController`및 `rootViewController`를 `SceneDelegate`에서 인스턴스화 해주어서 첫 화면이 보여지게 구현해 봤습니다. 하지만 iOS 15부터 NavigationBar의 디자인이 수정되어 구분선이 보이지 않는 현상이 발생했습니다.
- `UINavigationBarAppearance`를 인스턴스화 한 후 `configureWithOpaqueBackground()`메서드로 현재 테마에 적합한 불투명한 bar appearance object로 구성한 뒤 `NavigationController.navigationBar`에 `standardAppearance`및 `scrollEdgeAppearance`에 할당해 줌으로 이전에 발생한 문제를 해결했습니다.
    
<details>
<summary>코드 보기</summary>
<div markdown="1">
    
```swift
let navigationController = UINavigationController(rootViewController: mainViewController)
let navigationBarAppearance = UINavigationBarAppearance()
navigationBarAppearance.configureWithOpaqueBackground()
        
navigationController.navigationBar.standardAppearance = navigationBarAppearance
navigationController.navigationBar.scrollEdgeAppearance = navigationBarAppearance
```
    
</div>
</details>

</div>
</details>

### **UITableDataSource**

<details>
<summary>자세히보기</summary>
<div markdown="1">
    
- `TableView`의 `DataSource`로 `UITableViewDiffableDataSource`를 사용했습니다. `UITableViewDiffableDataSource`의 경우 `ItemIdentifier`가 `Hashable`해야했으며 `ItemIdentifier`에 해당하는 `Diary` Type은 `Hashable`하지 못하는 문제가 발생했습니다.
- `Diary` Type이 인스턴스화 될 때 프로퍼티로 `UUID`를 할당해 줌으로 해당 문제를 해결했습니다.
- `Diary` Type이 `UUID`를 프로퍼티로 가지고 있는 것이 좋은 방향성인지 많은 고민을 했으나 추후 `CoreData`에서 검색등의 작업을 할때도 이러한 프로퍼티가 있으면 좋을 것 같다고 판단했습니다.

</div>
</details>


### **Locale(추가 수정 예정)**

<details>
<summary>자세히보기</summary>
<div markdown="1">
    
- 지역 및 언어에 맞는 작성일자를 표현해주려고 했습니다. 하지만 `Locale.current`의 값이 지역을 변경하고 언어를 변경해도 `eu_KR`과 같이 언어 부분이 `eu`로 표현되는 문제가 발생했습니다.

<details>
<summary>이미지 보기</summary>
<div markdown="1">
    
|Locale Current|Device Setting|
|:---:|:---:|
|![](https://i.imgur.com/KDKMb8l.png)|![](https://i.imgur.com/vW4CMqj.png)|
    
</div>
</details>
    
- `Locale.preferredLanguages.first`를 사용하여 설정된 언어 중 첫번째 언어에 해당하는 값으로 작성일자를 표현되게 해주어 문제를 해결했습니다.
- `Locale.current`는 현재 App의 지원되는 `Localization`에 영향을 받는 것을 알게되었습니다. 어떤 `Localization`을 사용할지 결정해서 `Locale.current`에 따라서 UI를 다르게 표현해 줄 예정입니다.
        
</div>
</details>

### **DiaryView 재사용 고민**

<details>
<summary>자세히보기</summary>
<div markdown="1">
    
-  Diary 수정화면과 작성화면을 구현하는 과정에서 ViewController를 2개로 구현해야할까 라는 고민을 했었습니다.
- 고민해본 결과 2개의 ViewController보다는 1개에서 처리를 해서 재사용을 하자라는 방식으로 진행했습니다.
        
</div>
</details>

### **Cell의 identifier**

<details>
<summary>자세히보기</summary>
<div markdown="1">
    
```swift
// 1번
static let identifier: String = String(describing: self)

// 2번
static func getIdentifier() -> String {
        return String(describing: self)
}
```

- 1번과 2번 방법 중 Cell의 identifier을 어떻게 사용하는 방법이 더 나은지 고민했습니다.
- 프로토콜을 사용해서 해결했습니다.
    
<details>
<summary>코드 보기</summary>
<div markdown="1">
    
```swift
protocol ReusableView: class {
    static var defaultReuseIdentifier: String { get }
}

extension ReusableView where Self: UIView {
    static var defaultReuseIdentifier: String {
        return String(describing: self)
    }
}
```
    
</div>
</details>
</div>
</details>

<br>

## 📚 참고 링크

- [DateFormatter](https://developer.apple.com/documentation/foundation/dateformatter)
- [UITextView](https://developer.apple.com/documentation/uikit/uitextview)
- [Locale](https://developer.apple.com/documentation/foundation/locale)
- [UITableviewDiffableDatasource](https://developer.apple.com/documentation/uikit/uitableviewdiffabledatasource)
- [Cell Identifier Protocol](https://medium.com/@gonzalezreal/ios-cell-registration-reusing-with-swift-protocol-extensions-and-generics-c5ac4fb5b75e)
