# 📓 일기장

> 프로젝트 기간: 2022.06.13 ~ 2022.07.01 <br>
> 팀원: [Donnie](https://github.com/westeastyear), [OneTool](https://github.com/kimt4580)
> 리뷰어: [또치](https://github.com/TTOzzi)

## 🔎 프로젝트 소개


## 📺 프로젝트 실행화면
<img src="" width="60%">

## 👀 PR

[STEP 1](https://github.com/yagom-academy/ios-diary/pull/10)

## 🛠 개발환경 및 라이브러리
- [![swift](https://img.shields.io/badge/swift-5.6-orange)]()
- [![xcode](https://img.shields.io/badge/Xcode-13.4.1-blue)]()
- [![iOS](https://img.shields.io/badge/iOS-14.0-red)]()

## 🔑 키워드
- `CollectionView`
- `MVC`
- `Keyboard`
- `ContentInset`
- `Padding`
- `ScrollView`
- `StackView`
- `Json`
- `NavigationBar`
- `TimeInterval`
- `DateFormatter`
- `CoreData`
- `NotificationCenter`

## 📑 구현내용
- 사용자의 지역에 따른 "년월일" 형식을 `DateFormatter`로 유연하게 구현
    - `timeIntervalSince1970`를 활용하여 날짜계산 및 처리
- `Storyboard`없이 코드를 이용하여 `UI`구현 
- `Model` 생성 후 `decode`를 하여, `data` 사용
- `CollectionView`를 활용, `ListCell` 구현
- `Navigation Controller`를 활용하여, `View` 및 `ViewController` 전환
- `UIResponder`, `NotificationCenter`, `keyboardWillShow`, `keyboardWillHide`를 사용하여, Keyboard 구현


## 📖 학습내용
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

## 🧐 STEP별 고민한 점 및 해결한 방법

## [STEP 1]
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
