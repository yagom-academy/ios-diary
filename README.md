# 일기장 프로젝트 📖 
> CoreData를 활용한 일기장 어플리케이션

---
## 목차 📋
1. [팀원 소개](#1-팀원-소개)
2. [타임 라인](#2-타임라인)
3. [프로젝트 구조](#3-프로젝트-구조)
4. [실행화면](#4-실행화면)
5. [트러블 슈팅](#5-트러블-슈팅)
6. [Reference](#6-reference)

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
|   │   └── SceneDelegate.swift
│   ├── Controller
│   │   ├── DiaryEditViewController.swift
│   │   └── DiaryMainViewController.swift
│   ├── Model
│   │   ├── AssetDecoder.swift
│   │   ├── DateManager.swift
│   │   └── DiaryItem.swift
│   ├── Protocol
│   │   └── IdentifierType.swift
│   ├── Resources
│   │   └── Assets.xcassets
│   │   └── sample.dataset
│   │           └── sample.json
│   └── View
│       └── DiaryTableViewCell.swift
└── README.md
```
   
</div>
</details>


</br>

## 4. 실행화면

| 실행 화면 | 수정 화면 |
| :--------: | :--------: |
| <img src="https://i.imgur.com/FaeaDFD.gif"> | <img src="https://i.imgur.com/2s0LcNl.gif"> |


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

## 6. Reference
- [Apple Docs - UITextView](https://developer.apple.com/documentation/uikit/uitextview)
- [Apple Docs - DateFormatter](https://developer.apple.com/documentation/foundation/dateformatter)
- [Apple Docs - Layout](https://developer.apple.com/design/human-interface-guidelines/foundations/layout/)
- [Apple Docs - Keyboard Layout Guide](https://developer.apple.com/documentation/uikit/keyboards_and_input/adjusting_your_layout_with_keyboard_layout_guide)

<br/>
