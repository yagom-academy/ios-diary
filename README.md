# 📓 일기장

- 일기를 기록하는 앱입니다.

## 📖 목차
1. [팀 소개](#-팀-소개)
2. [기능 소개](#-기능-소개)
3. [폴더 구조](#-폴더-구조)
4. [타임라인](#-타임라인)
5. [트러블 슈팅](#-트러블-슈팅)
6. [참고 링크](#-참고-링크)

## 🌱 팀 소개
[Woong](https://github.com/lxodud)|[Jeremy](https://github.com/yjjem)|
|:---:|:---:|
| <a href="https://github.com/iOS-Woong"><img width="180px" src="https://avatars.githubusercontent.com/u/96489602?v=4"></a>|<a href="https://github.com/yjjem"><img width="180px" src="https://i.imgur.com/RbVTB47.jpg"></a>|

## 🛠 기능 소개

|스크롤 화면|수정 기능 구현|
|--------|-----------|
|<img src="https://i.imgur.com/UZZ7n4N.gif" width=180>|<img src="https://user-images.githubusercontent.com/88357373/209281091-93b3e6b8-290b-4d35-ab29-cfb9173492dd.gif" width=180>|

## 🗂 폴더 구조
```
Diary
├── Model
│   └── SampleData.swift
├── View
│   ├── DiaryTableViewCell.swift
│   ├── DiaryTableViewCell.xib
│   ├── Main.xib
│   └── LaunchScreen.xib
├── Controller
│   ├── AppDelegate.swift
│   ├── SceneDelegate.swift
│   ├── DiaryViewController.swift
│   ├── AddViewController.swift
│   └── DetailViewController.swift
├── Utilities
│   ├── Ext + Int.swift
│   └── Ext + String.swift
├── Resources
│   └── Assets
├── Info.plist
├── Diary.xcdatamodeld
└── README.md
```


## ⏰ 타임라인

|날짜|구현 내용|
|--|--| 
|22.12.21|- dtest 목적의 Json SampleData를 활용하여 테이블뷰(+ 셀) 구현|
|22.12.22|- 키보드 사용여부에 따라 bottomConstraint 조절 </br> - delegate패턴 활용하여 데이터 전달하도록 구현|


    
## 🚀 트러블 슈팅

#### 📎 키보드가 텍스트를 가리지 않도록 설정
- 키보드 Hide, Show 상태에 따라 다른 액션을 취하도록 하기위해 NotificationCenter를 활용하였습니다.
- Notification 구조체 내부의 인스턴스인 userInfo의 KeyboardFrame을 전달받아 키보드의 높이 값을 얻어 낼 수 있었고,
- textView의 bottom 제약의 Constant에 전달받은 키보드의 높이값를 설정하는 것으로 문제를 해결 할 수 있었습니다. 

### 📎 키보드가 올라오면 margin이 생기는 현상
- textView의 bottom constraint를 safeArea.bottom에 걸었을 떄 불필요한 margin이 발생하고 텍스트를 가리는 문제가 있었습니다.
- bottom constraint를 superView.bottom으로 수정하여 해결했습니다.
    | 불필요한 margin이 생겨 텍스트를 가리는 상황 |
    | :--------: |
    | <img src="https://i.imgur.com/q7YpqV1.png" width="300px"/>|

#### 📎 textView에서 title과 body를 나누는 로직 구현

1. title과 body를 나누는 기준을 고민했고 결과적으로는 `\n\n` 을 활용하기로 결정했습니다.

     
    ```swift
    // DetailViewController.swift

    private func configureView() {
        ...
        self.detailTextView.text = "\(data.title)\n\n\(data.body)"
    }
    ```
2. 하지만 유저가 title과 body를 나누지 않고 하나의 문단으로 작성하는 경우도 고려해야 했습니다.
- 이 과정에서 고려해본 형태는 아래와 같습니다.

    |    A     |     B    |
    |:--------:|:--------:|
    | <img src="https://i.imgur.com/3dWUO7V.png" height="500px"/>|<img src="https://i.imgur.com/SoiWpUU.png" height="500px"/>  |
    |문단이 있고 components로 </br>확실하게 나눌 수 있는 형태|문단이 하나이고 title과 body를 </br> 명확히 나눌 수 없는 형태|

- 문단이 나뉘어있는 경우 componenets(separatedBy:) 메서드를 활용하여 배열의 첫 요소를 title로 지정하도록 했고 문단이 하나뿐이라면 문자열의 앞 20자가 title 그리고 나머지가 body가 되도록 했습니다.


## 🔗 참고 링크

[Apple Developer]
- [ 📎 String Index ](https://developer.apple.com/documentation/swift/string/index)
- [ 📎 DateFormatter ](https://developer.apple.com/documentation/foundation/dateformatter)
