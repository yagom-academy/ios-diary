# 📒 일기장 프로젝트

## 📖 목차
1. [소개](#-소개)
2. [Tree](#-tree)
3. [타임라인](#-타임라인)
4. [실행 화면](#-실행-화면)
5. [고민한 점](#-고민한-점)
6. [트러블 슈팅](#-트러블-슈팅)
7. [참고 링크](#-참고-링크)

## 🌱 소개

`Mangdi`와 `junho`가 만든 일기장 앱입니다.
- **KeyWords**
  - `UICollectionViewDiffableDataSource`, `NSDiffableDataSourceSnapshot`
  - `UIContentView`, `UIContentConfiguration`, `Notification`
  - `keyboardLayoutGuide`, `localizing`, `CoreData`
  - `UISwipeActionsConfiguration`, `UIActivityViewController`
  - `Core Location`, `CLLocationManager`, `Lightweight Migration`

## 💻 개발환경 및 라이브러리
[![swift](https://img.shields.io/badge/swift-5.6-orange)]()
[![xcode](https://img.shields.io/badge/Xcode-13.4.1-blue)]()

## 🧑🏻‍💻 팀원
|<img src="https://avatars.githubusercontent.com/u/49121469" width=160>|<img src="https://camo.githubusercontent.com/a482a55a5f5456520d73f6c2debdd13375430060d5d1613ca0c733853dedacc0/68747470733a2f2f692e696d6775722e636f6d2f436558554f49642e706e67" width=160>|
|:--:|:--:|
|[Mangdi](https://github.com/MangDi-L)|[junho](https://github.com/junho15)|

## 🌲 Tree

```
.
├── Diary
│   ├── Base.lproj
│   ├── Controllers
│   │   ├── DiaryDetailViewController.swift
│   │   └── DiaryListViewController.swift
│   ├── Extensions
│   │   ├── Locale.swift
│   │   └── TimeInterval.swift
│   ├── Models
│   │   ├── Diary
│   │   │   └── Diary.swift
│   │   ├── Location
│   │   │   └── LocationManager.swift
│   │   ├── PersistentContainer
│   │   │   ├── DiaryModelObject+CoreDataClass.swift
│   │   │   ├── DiaryModelObject+CoreDataProperties.swift
│   │   │   ├── PersistentContainer.swift
│   │   │   └── PersistentContainerManager.swift
│   │   └── Weather
│   │       ├── ApiError.swift
│   │       ├── WeatherIconLoader.swift
│   │       ├── WeatherInformation.swift
│   │       ├── WeatherInformationLoader.swift
│   │       └── WeatherRequest.swift
│   ├── SupportFiles
│   │   ├── AppDelegate.swift
│   │   ├── Assets.xcassets
│   │   │   ├── AccentColor.colorset
│   │   │   │   └── Contents.json
│   │   │   ├── AppIcon.appiconset
│   │   │   │   └── Contents.json
│   │   │   ├── Contents.json
│   │   │   └── sample.dataset
│   │   │       ├── Contents.json
│   │   │       └── sample.json
│   │   ├── DiaryModel.xcdatamodeld
│   │   │   ├── DiaryModel v2.xcdatamodel
│   │   │   │   └── contents
│   │   │   └── DiaryModel.xcdatamodel
│   │   │       └── contents
│   │   ├── Info.plist
│   │   ├── Model.xcmappingmodel
│   │   │   └── xcmapping.xml
│   │   ├── SceneDelegate.swift
│   │   ├── en.lproj
│   │   │   └── Localizable.strings
│   │   └── ko.lproj
│   │       └── Localizable.strings
│   └── Views
│       └── DiaryListContentView.swift
```
 
## ⏰ 타임라인

<details>
<summary>Step 1 타임라인</summary>
    
- **22/12/20**
    - SwiftLint 라이브러리 적용
    - MVC 파일 분리 및 Asset에 들어있는 json파일에 맞는 모델타입 구현

- **22/12/22**
    - 일기장 리스트 화면 구현 
        - 스토리보드 제거
        - CollectionView Layout, DataSource, Snapshot 구현
        - Custom ContnetView, ContentConfiguration 구현
    - 일기장 등록 화면구현
        - 키보드가 화면을 가리지 않도록 구현
        - NSLocalizedString 사용하여 구현
    
- **22/12/23**
    - 프로젝트 폴더 정리(Extensions, Models, Views, Controllers, SupportFiles)

</details>

<details>
<summary>Step 2 타임라인</summary>
    
- **22/12/26**
    - Mark 주석 추가
    - ContentConfiguration를 Custom ContnetView의 Nested Type으로 선언
    
- **22/12/27**
    - DiaryModel, NSMangedObject Subclass 구현
    - PersistentContainer, PersistentContainerManager 구현
    
    
- **22/12/29**
    - 일기 화면 이동 기능 구현
    - 자동 저장 기능 구현
    - 더보기 버튼 및 액션 시트로 공유/삭제 기능 구현
    - 스와이프로 공유/삭제 기능 구현

</details>

<details>
<summary>Step 3 타임라인</summary>
    
- **23/01/03**
    - 위치정보 관련 Location Manager 타입 구현
    - API 통신관련 NetworkManger 타입 구현
    
- **23/01/04**
    - NetworkManger 기능 분리 및 URLCache 추가
    - Diary 모델 및 CoreData DB의 속성에 날씨관련 프로퍼티2개 추가하고 새로운 버전 생성
    - cellRegistration 에서 contentConfiguration 에 이미지 할당해주는 기능 및 아이콘 이미지 로드 기능 추가
    - 날씨아이콘 이미지뷰 추가 및 세팅
    
- **23/01/05**
    - 새로운 일기를 작성할 때 현재 사용자의 위치를 기반으로 현재 날씨정보를 가져오는 기능 구현
    - 전체적인 컨벤션 통일

</details>


## 📱 실행 화면

<details>
    <summary>STEP 1 실행화면</summary>

|화면회전|지역화|
|:--:|:--:|
|![Simulator Screen Recording - iPhone 11 - 2022-12-23 at 14 39 10](https://user-images.githubusercontent.com/49121469/209278369-3e69e3c0-3700-49d8-8fde-8e36b2f0ddd8.gif)|![Simulator Screen Recording - iPhone 11 - 2022-12-23 at 14 52 03](https://user-images.githubusercontent.com/49121469/209279608-581b9718-6c32-4a87-a0a6-f654bbc4eb3c.gif)|
    
</details>

<details>
    <summary>STEP 2 실행화면</summary>

|키보드가 내려갈때 저장|백그라운드 진입할때 저장|이전화면으로 이동할때 저장|
|:--:|:--:|:--:|
|![number1](https://user-images.githubusercontent.com/49121469/210041455-6fae46dc-3d9f-4584-a850-1045dd0df8a1.gif)|![number2](https://user-images.githubusercontent.com/49121469/210041459-8832be13-1cb8-4e63-8a2f-2858198c16ed.gif)|![number3](https://user-images.githubusercontent.com/49121469/210041465-3598e1be-8d80-4c6d-b6b9-9fef13087094.gif)|
|더보기버튼으로 삭제|더보기버튼으로 공유|셀 스와이프삭제와 공유|
|![number4](https://user-images.githubusercontent.com/49121469/210041467-b96868d7-9d07-447d-bc47-44a668357d08.gif)|![number5](https://user-images.githubusercontent.com/49121469/210041470-eb4776c1-f7c2-4323-b886-192ddbfaad0d.gif)|![number6](https://user-images.githubusercontent.com/49121469/210041473-377dadd1-6853-4d3c-9909-a3778a173a41.gif)|
    
</details>

<details>
    <summary>STEP 3 실행화면</summary>
    
|(위치허가O)일기장생성|(위치허가X)일기장생성|
|:--:|:--:|
|![2번](https://i.imgur.com/Z60MvVe.gif)|![3번](https://i.imgur.com/k72znXm.gif)|

</details>

## 👀 고민한 점

### STEP 1

- **Cell 에 직접 접근하여 Lable 등에 값을 설정하는 기존 방식 대신 [WWDC 2020](https://developer.apple.com/videos/play/wwdc2020/10027/) 에서 소개한 `Configuration` 을 사용하는 방식으로 구현해보았습니다.**   
`UIContentView` 프로토콜을 채택하는 `DiaryListContentView` 와 `UIContentConfiguration` 프로토콜을 채택하는 `DiaryListConfiguration` 을 구현하여 사용했습니다.   
기존 방식처럼 직접 Cell에 접근하지 않고 `Configuration` 을 통해서 Cell을 설정해줄 수 있었습니다.   
테이블 뷰와 컬렉션 뷰 셀 모두에서 사용할 수 있고, 가볍고 생성 비용이 적어 성능에 이점이 있다고 합니다.

    <details>
    <summary>소스코드</summary>
    <div markdown="1">

    ```swift
        let cellRegistration = UICollectionView.CellRegistration<UICollectionViewListCell, Diary.ID> { [weak self] cell, _, itemIdentifier in
            var contentConfiguration = DiaryListConfiguration()
            guard let diary = self?.diary(diaryID: itemIdentifier) else {
                cell.contentConfiguration = contentConfiguration
                return
            }

            contentConfiguration.title = diary.title
            contentConfiguration.body = diary.body
            contentConfiguration.createdAt = diary.createdAt
            cell.contentConfiguration = contentConfiguration
            cell.accessories = [
                UICellAccessory.disclosureIndicator()
            ]
        }
    ```

    </div>
    </details>

- **컬렉션뷰의 셀마다 경계선이 표시되는 줄이 나타나게끔 구현하고 싶었습니다.**   
`NSCollectionLayoutSection` 으로 `UICollectionViewCompositionalLayout` 을 만드는 방법 대신 `UICollectionLayoutListConfiguration` 의 `showsSeparators` 프로퍼티를 사용하여 구현할 수 있었습니다.   
[Apple Developer Documentation - Implementing Modern Collection Views](https://developer.apple.com/documentation/uikit/views_and_controls/collection_views/implementing_modern_collection_views) 

    
    <details>
    <summary>소스코드</summary>
    <div markdown="1">

    ```swift
        // 기존 방식
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                              heightDimension: .fractionalHeight(1.0))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                               heightDimension: .estimated(75))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize,
                                                       subitem: item,
                                                       count: 1)
        let section = NSCollectionLayoutSection(group: group)
        let viewLayout = UICollectionViewCompositionalLayout(section: section)
    ```
    ```swift
        // 새로운 방식
        var config = UICollectionLayoutListConfiguration(appearance: .plain)
        config.showsSeparators = true
        let viewLayout = UICollectionViewCompositionalLayout.list(using: config)
    ```    

    </div>
    </details>    

---

### STEP 2

- **데이터 등록 시 NSDiaryModelObject의 SubClass를 사용하여 인스턴스 초기화**
    처음엔 `entity(forEntityName:in:)` 메서드로 Entity(DiaryModelObject) 를 찾은 뒤,  
찾은 Entity를 가지고 `NSManagedObject` 의 `init(entity:insertInto:)` 이니셜라이저로 인스턴스를 만들었습니다.  
`entity` 메서드 `EntityName` 와 `setValue` 메서드의 `forKey` 에 직접 문자열을 입력하기 때문에 잘못된 문자열 입력으로 인해 휴먼 에러가 발생할 가능성이 있습니다.  
또한 에러를 컴파일 단계에서 확인하지 못 하기 때문에 런타임 에러가 발생할 수 있습니다.  
따라서 `NSManagedObject`의 subClass 인 `DiaryModelObject` 의 `init(context:)` 이니셜라이저를 사용해 인스턴스를 만들도록 했습니다.
    
    <details>
    <summary>소스코드</summary>
    <div markdown="1">

    ```swift
        // 수정 전
        func insertDiary(_ diary: Diary) {
            guard let entity = NSEntityDescription.entity(forEntityName: "DiaryModelObject", 
                                                          in: persistentContainer.viewContext) else { return }
            let diaryModelObejct = NSManagedObject(entity: entity,
                                                   insertInto: persistentContainer.viewContext)
            diaryModelObejct.setValue(diary.id, forKey: "id")
            diaryModelObejct.setValue(diary.title, forKey: "title")
            diaryModelObejct.setValue(diary.body, forKey: "body")
            diaryModelObejct.setValue(diary.createdAt, forKey: "createdAt")
            persistentContainer.saveContext()
        }

        // 수정 후
        func insertDiary(_ diary: Diary) {
            let diaryModelObejct = DiaryModelObject(context: persistentContainer.viewContext)
            diaryModelObejct.id = diary.id
            diaryModelObejct.title = diary.title
            diaryModelObejct.body = diary.body
            diaryModelObejct.createdAt = diary.createdAt
            persistentContainer.saveContext()
        }
    ```

    </div>
    </details>
    
---
    
### STEP 3

- **날씨 아이콘 이미지 받아올 때 URLCache 사용**
날씨 아이콘 이미지 데이터를 매번 요청해서 받아오지 않고 캐시된 이미지를 사용할 수 있도록 했습니다.  
NSCache 와 URLCache 중에서 무엇을 사용할 지 고민을 했습니다.  
NSCache 는 in-memory 캐시를 제공하고, URLCache 는 in-memory와 on-disk 캐시를 제공합니다.  
앱을 종료하고 다시 실행해도 캐시에 저장된 아이콘 이미지가 남아있는 게 더 적절하다고 판단하여 URLCache 를 사용했습니다.  
    
    <details>
    <summary>소스코드</summary>
    <div markdown="1">

    ```swift
        private let imageURLCache = URLCache.shared

        imageURLCache.getCachedResponse(for: dataTask) { response in
            guard let response = response,
                  let cachedImage = UIImage(data: response.data) else {
                dataTask.resume()
                return
            }
            completion(cachedImage, nil)
        }
    ```

    </div>
    </details>
    
- **cellRegistration 로직 단순화**
cellRegistration 에서 직접 아이콘 이미지를 가져오지 않고 이미지를 불러와야할 경우 loadIconImage() 메서드를 호출하도록 했습니다.  
loadIconImage() 메서드는 iconID 를 기준으로 아이콘 이미지를 불러와서 diary 정보를 업데이트 한 후 applyUpdate() 메서드로 컬렉션 뷰에 반영하도록 합니다.  
cellRegistration 내부의 로직을 최대한 줄이고자 이와 같은 방법으로 구현했습니다.  
    
    <details>
    <summary>소스코드</summary>
    <div markdown="1">

    ```swift
        private func configureDataSource() {
            let cellRegistration = UICollectionView.CellRegistration<UICollectionViewListCell, Diary.ID> { [weak self] cell, _, itemIdentifier in
                ...
                let hasIconID = diary.iconID != nil
                if hasIconID {
                    if let iconImage = diary.iconImage {
                        contentConfiguration.iconImage = iconImage
                    } else {
                        self?.loadIconImage(for: diary.id)
                    }
                }
                ...
        }

        private func loadIconImage(for diaryID: Diary.ID) {
            guard var diary = diary(diaryID: diaryID),
                  let iconID = diary.iconID else { return }
            WeatherIconLoader().load(iconID: iconID) { [weak self] image, error in
                if let error = error {
                    print(error)
                    return
                }
                guard let image = image else { return }
                diary.iconImage = image
                DispatchQueue.main.async {
                    self?.update(diary: diary)
                    self?.updateSnapshot([diary.id])
                }
            }
        }
    ```

    </div>
    </details>
    
## ❓ 트러블 슈팅

### STEP 1

<details>
<summary> 현재 기기의 Locale 을 확인해서 지역화된 날짜 구현 </summary>
<div markdown="1">
    
- 시뮬레이터 설정에서 언어를 바꿔가며 테스트하던 중 `Locale.current` 가 제대로 바뀌지 않는 문제가 있었습니다.
- `EditSchema - Options` 에서 `App Language` 를 `Korean` 으로 `App Region` 을 `South Korea` 로 수정한 뒤 `Locale.current` 를 확인해도 `en_KR` 였습니다.
- 사용자가 선호하는 언어의 정렬된 목록을 알려주는 `Locale` 의 타입프로퍼티 `preferredLanguages` 를 활용해서 날짜의 지역화를 구현할 수 있었습니다.
    
```swift
// 수정전
extension DateFormatter {
    static func convertToCurrentLocalizedText(timeIntervalSince1970: Double) -> String {
        let date = Date(timeIntervalSince1970: timeIntervalSince1970)
        let formatter = DateFormatter()
        formatter.dateStyle = .long
        formatter.timeStyle = .none
        formatter.locale = Locale.current // Locale.current 사용
        return formatter.string(from: date)
    }
}
```

```swift
// 수정후
extension Locale {
    static var currentLocale: Locale {
        if let preferredLanguage = Locale.preferredLanguages.first {
            return Locale(identifier: preferredLanguage)
        } else {
            return Locale.current
        }
    }
}

extension DateFormatter {
    static func convertToCurrentLocalizedText(timeIntervalSince1970: Double) -> String {
        let date = Date(timeIntervalSince1970: timeIntervalSince1970)
        let formatter = DateFormatter()
        formatter.dateStyle = .long
        formatter.timeStyle = .none
        formatter.locale = Locale.currentLocale // 새로 추가한 Locale.currnetLocale 사용
        return formatter.string(from: date)
    }
}
```
    
</div>
</details>

<details>
    <summary> TextField 와 TextView 의 글자 시작 위치 맞추기</summary>

- titleTextField 와 bodyTextView 의 글자 시작 위치가 서로 달랐습니다.
- 예시 화면과 같이, 둘의 글자 시작 위치가 동일하도록 해주기 위해 텍스트 뷰의 `textContainer.lineFragmentPadding` 프로퍼티에 값을 디폴트 값인 `5` 대신 `0` 으로 설정해 주었습니다.
    
```swift
textView.textContainer.lineFragmentPadding = 0 // 5(디폴트) -> 0
```

|수정 전|수정 후|
|:--:|:--:|
|![](https://i.imgur.com/38sLVy7.png)|![](https://i.imgur.com/8AgMvhc.png)|


</details>

### STEP 2

<details>
    <summary> CoreData 파일 관련 에러 해결 </summary>

- 개발 과정에서 CoreData Model에 Entity를 여러개를 추가해서 작업을 진행하다가 필요없어진 Entity는 삭제했습니다.  
- 그런데 이후에 진행한 작업에서 완전히 지워진게 아니엇던걸 확인하고 완전한 삭제를 위해 프로젝트파일을 열어서 삭제할Entity와 관련된 파일을 하나씩 지우는과정중 파일이 날아가버리는 상황을 겪었습니다.  
- 그래서 이 방법은 철회하고 직접 finder에 들어가서 기존에 생성한 CoreData 관련파일을 모두 제거한 후 다시 처음부터 Entity를 생성하여 문제를 해결할 수 있었습니다.
    
</details>

### STEP 3

<details>
<summary> LocationManager 에서 completion 프로퍼티 관련 이슈 </summary>
<div markdown="1">
    
- `LocationManager` 객체의 `currentLocation()` 메서드에 탈출 클로저를 추가하여 `CLLocation` 타입의 정보를 메서드를 호출한 쪽에 전달하고자 했습니다.  
- `currentLocation()` 메서드 내부에서 `CLLocationManger` 의 `requestLocation()` 메서드를 호출하면 델리게이트의 `locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation])` 메서드에서 위치 정보를 확인할 수 있었습니다.
- `currentLocation()` 메서드에서 매개 변수로 받은 탈출 클로저에 위치 정보를 넣어주어야 하기 때문에 `completion` 프로퍼티를 사용해서 클로저를 델리게이트 메서드에 전달할 수 있도록 했습니다.
- `completion` 프로퍼티에 클로저가 남아 있어서 다시 클로저를 호출하는 경우가 발생했습니다.
클로저를 호출한 뒤 `completion` 프로퍼티를 nil로 초기화하여 문제를 해결했습니다.
    
```swift
    final class LocationManager: NSObject {
        private var completion: Completion?

        func currentLocation(completion: @escaping Completion) {
            self.completion = completion
            locationManager.requestLocation()
    }

    extension LocationManager: CLLocationManagerDelegate {
        // 수정 전
        func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
            guard let completion = completion else { return }
            guard isAuthorized else {
                completion(nil, nil)
                return
            }
            completion(locations.last, nil)
        }

        // 수정 후
        func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
            guard let completion = completion else { return }
            guard isAuthorized else {
                completion(nil, nil)
                self.completion = nil
                return
            }
            completion(locations.last, nil)
            self.completion = nil
        }
```
    
</div>  
</details>

## 🔗 참고 링크

[Apple Developer Documentation - Updating Collection Views Using Diffable Data Sources](https://developer.apple.com/documentation/uikit/views_and_controls/collection_views/updating_collection_views_using_diffable_data_sources)  
[Apple Developer Documentation - Implementing Modern Collection Views](https://developer.apple.com/documentation/uikit/views_and_controls/collection_views/implementing_modern_collection_views)  
[Apple Developer Documentation - Core Data](https://developer.apple.com/documentation/coredata)  
[Apple Developer Documentation - UIActivityViewController](https://developer.apple.com/documentation/uikit/uiactivityviewcontroller)  
[Apple Developer Documentation - Core Location](https://developer.apple.com/documentation/corelocation)  
[Apple Developer Documentation - Using Lightweight Migration](https://developer.apple.com/documentation/coredata/using_lightweight_migration)  

---

[🔝 맨 위로 이동하기](#-일기장-프로젝트)


---
