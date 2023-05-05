# 일기장 📚

## 프로젝트 소개
> 코어데이터를 사용해 일기장을 추가, 수정, 삭제를 하는 어플리케이션
> 
> 프로젝트 기간: 2023.04.24 - 2023.05.12

## 목차 :book:


- [1. 팀원을 소개합니다 👀](#팀원을-소개합니다-) 
- [2. 시각화된 프로젝트 구조](#시각화된-프로젝트-구조)
    - [2-1. Class Diagram 🗺](#class-diagram-) 
    - [2-2. File Tree 🌲](#file-tree-) 
- [3. 타임라인 ⏰](#타임라인-) 
- [4. 실행 화면 🎬](#실행-화면-) 
- [5. 트러블슈팅 🚀](#트러블-슈팅-) 
- [6. Reference 📑](#reference-) 

</br>

## 팀원을 소개합니다 👀

|<center>[송준](https://github.com/kimseongj)</center> | <center> [릴라](https://github.com/juun97)</center> | 
|--- | --- |
|<Img src = "https://i.imgur.com/9Bd6NIT.png" width="300">| <img src="https://i.imgur.com/9M6jEo2.png" width=300>  |

</br>

## 시각화된 프로젝트 구조 

### Class Diagram 🗺

추후 업로드


</br>

### File Tree 🌲

<details>
<summary> 파일 트리 보기</summary>

```typescript
Diary
├── Application
│    ├── AppDelegate.swift
│    └── SceneDelegate.swift
├── Controller
│    ├── DiaryDetailViewController.swift
│    └── DiaryViewController.swift
├── Extra
│    └── AlertManager.swift
├── Localizable
│    ├── en.lproj
│    │    └── Localizable.strings
│    └── ko.lproj
│        └── Localizable.strings
├── Model
│    └── Diary.swift
├── Util
│    ├── CoreData
│    │    ├── DiaryEntity + CoreDataClass
│    │    ├── DiaryEntity + CoreDataProperties
│    │    ├── DiaryDataModel
│    │    └── CoreDataManager
│    └── Extension
│         ├── Int + Extension
│         ├── Array + Extension
│         ├── Date + Extension
│         └── String + Extension
│    
└── View
     └── DiaryTableViewCell.swift
```
    
</details>




</br>

## 타임라인 ⏰

| <center>날짜</center> | <center>타임라인</center> |
| --- | --- |
| **2023.04.24** | - SwiftLint 라이브러리 적용 </br>- 메인화면의 CollectionView 구현 </br>- JSONDecoder 구현|
| **2023.04.25** | - CollectionView를 TableView로 수정 </br> - Diffable DataSource를 적용 |
| **2023.04.26** | - TableView Cell 구현  |
| **2023.04.27** | - 전체 View에 Localization 설정 |
| **2023.04.28** | - 코드 리뷰 바탕으로 리팩토링  |
| **2023.05.01** | -  </br>- 메인화면의 CollectionView 구현 </br>- JSONDecoder 구현|
| **2023.05.02** | - CollectionView를 TableView로 수정 </br> - Diffable DataSource를 적용 |
| **2023.05.03** | - TableView Cell 구현  |
| **2023.05.04** | - 전체 View에 Localization 설정 |
| **2023.05.05** | - 코드 리뷰 바탕으로 리팩토링  |



</br>

## 실행 화면 🎬


| <center>셀 클릭시 세부정보 화면 이동</center>  | <center>키보드가 사용될 때 레이아웃 조정</center> | <center> 새로운 일기장 만들시 저장하기</center> |
| --- | --- | --- |
 | <img src="https://i.imgur.com/vomD5CG.gif" width =400> | <img src="https://i.imgur.com/d9L64Mo.gif" width =400> | <img src="https://i.imgur.com/HDXfdCe.gif" width =400> |

| <center> 셀 스와이프해서 데이터 삭제</center> | <center>더 보기에서 공유할시 Activity뷰 출력</center>  | <center>더 보기에서 삭제할시 데이터 삭제 및 이전화면 가기</center> | 
| --- | --- | --- |
| <img src="https://i.imgur.com/e6IYJgq.gif" width =400> | <img src="https://i.imgur.com/FMHup27.gif" width =400> | <img src="https://i.imgur.com/WCA6PDK.gif" width =400> | 



| <center>가로모드 전환시 레이아웃 조정</center>  | 
| --- | 
 | <img src="https://i.imgur.com/6g1lfQh.gif" width =600> | 



## 트러블 슈팅 🚀


### 1️⃣ lazy var 사용할 때의 메모리 효율성
프로퍼티를 선언하는 과정에서 let 으로 할지 lazy var 로 사용할지 에 대한 고민이 있었습니다.

- let 

let 의 경우 컴파일 시점에 미리 메모리에 올라가는 상태로 파악했고, 인스턴스가 initialize 되기 전까지 let 으로 구현된 프로퍼티 클로저 안에서는 다른 프로퍼티에 접근이 불가능 합니다.

- lazy var

lazy var 의 경우 런타임 시점에 해당 프로퍼티가 사용되는 시점에 메모리에 올라온다고 파악했고, 인스턴스가 initialize가 되지 않아도 다른 프로퍼티에 접근이 가능합니다. 

#### :fire: 결론
- 화면에서 반드시 보여질 필요가 없는(특정 경우에만 보여지는) view일 때 사용하는게 좋아 보입니다.
- 애플 공식 문서에를 참고했을 때, 다중 스레드로 접근하면 초기화가 한번만 되는것을 보장하지 않는다고 합니다. 즉, 단일 스레드 환경이 보장되지 않으면 lazy var를 쓰는 것은 지양해야될 거 같습니다.

### 2️⃣ scrollView와 textView의 스크롤 문제
- ScrollView 내부에 textView를 구현할 경우 textView가 나오지 않는 오류가 발생합니다. 이 오류의 원인을 파악해본 결과 UITextView가 UIScrollView를 상속받고 있어, 두 개의 ScrollView 기능이 충돌되어 textView가 나오지 않는 것으로 판단하였습니다.

![](https://i.imgur.com/l6XYPAe.png)

- 이 문제를 해결하기 위해 TextView를 선언할 때 아래와 같은 코드로, `isScrollEnabled = false`로 작성하여 textView의 스크롤 기능을 삭제하여 해결하였습니다.

```Swift
private lazy var bodyTextView: UITextView = {
        let textView = UITextView()
        textView.font = .preferredFont(forTextStyle: .body)
        textView.isScrollEnabled = false
        textView.layer.borderWidth = 0.8
        textView.layer.cornerRadius = 4
        textView.textContainerInset = UIEdgeInsets(top: 8, left: 8, bottom: 8, right: 8)
        
        return textView
    }()
```

### 3️⃣ textView Placeholder 구현
- textView의 경우 texField와 다르게 Placeholder를 직접 구현해줘야 합니다.
- 아래는 Placeholder를 구현한 모습입니다.
    - `hasPlaceholder`라는 연산 프로퍼티를 선언하여, placeholder의 존재 여부를 파악합니다.
    - `hasPlaceholder`로 분기처리를 하여 `UITextViewDelegate`에 존재하는 `textViewDidBeginEditing`, `textViewDidEndEditing`메서드에 접근하여 Placeholder를 구현했습니다.

```swift
extension DiaryDetailViewController: UITextViewDelegate {
    private var hasPlaceholder: Bool {
        if bodyTextView.textColor == UIColor.lightGray && bodyTextView.text == String.localized(key: LocalizationKey.bodyTextViewPlaceHolder) {
            return true
        } else {
            return false
        }
    }
    
    private func placeholderSetting() {
        titleTextField.attributedPlaceholder = NSAttributedString(
            string: String.localized(key: LocalizationKey.titleTextFieldPlaceHolder),
            attributes: [NSAttributedString.Key.foregroundColor: UIColor.lightGray]
        )
        
        bodyTextView.delegate = self
        bodyTextView.text = String.localized(key: LocalizationKey.bodyTextViewPlaceHolder)
        bodyTextView.textColor = UIColor.lightGray
    }
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        if hasPlaceholder == true {
            textView.text = nil
            textView.textColor = UIColor.black
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.isEmpty {
            textView.text = String.localized(key: LocalizationKey.bodyTextViewPlaceHolder)
            textView.textColor = UIColor.lightGray
        }
    }
}
```

### 4️⃣ Compression resistance priority를 이용한 label 크기 문제 해결
`Horizontal StackView`를 사용하여 두개의 `Label`을 넣는 방식을 사용할 때, 텍스트의 길이가 긴 `Label`이  짧은 `Label`을 잡아 먹는 경우가 생겼습니다. 이를 해결하기 위해 날짜`Label`에 Compression Resistance Priority를 활용하여 수정하였습니다. Compression Resistance Priority이란 해석하면 압축을 저항하는 우선순위로, Priority 값이 높은 쪽이 형태를 유지하고, 낮은 쪽의 형태가 압축됩니다.


| <center>수정 전</center> | <center>수정 후</center>|
| --- | --- |
| <img src="https://i.imgur.com/6UnpsPX.png" width =300> |<img src="https://i.imgur.com/EEzqiEV.png" width =300> |

## Reference 📑
- [UITextView - Apple Document](https://developer.apple.com/documentation/uikit/uitextview)
- [DateFormatter - Apple Document](https://developer.apple.com/documentation/foundation/dateformatter)
- [CoreData - Apple Document](https://developer.apple.com/documentation/coredata)
- [Setting Up a Core Data Stack - Apple Document](https://developer.apple.com/documentation/coredata/setting_up_a_core_data_stack)
- [Creating a Core Data Model - Apple Document](https://developer.apple.com/documentation/coredata/creating_a_core_data_model)
