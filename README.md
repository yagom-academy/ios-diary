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
- [STEP 3](#step-3)
    + [고민한 점](#고민한-점)
    + [질문사항](#질문사항)

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
|22.06.13(월)|요구사항 파악, 프로젝트 설계|
|22.06.14(화)|STEP1-1, STEP1-2 진행|
|22.06.15(수)|개인공부 진행|
|22.06.16(목)|STEP1 PR 피드백 반영|
|22.06.17(금)|STEP2-1, STEP2-2 진행|
|22.06.20(월)|STEP2-3|
|22.06.21(화)|STEP2 PR|
|22.06.22(수)|개인공부 진행|
|22.06.23(목)|STEP3-1 진행|
|22.06.24(금)|STEP3-2, STEP3 PR|
|22.06.25(월)|STEP3 PR 피드백 반영|
|22.06.28(화)|STEP3 PR 피드백 반영|
|22.06.29(수)|개인공부 진행|
|22.06.30(목)|STEP3 PR 피드백 반영|
|22.07.01(금)|STEP3 README 작성|
    
## 👀 PR
- [STEP 1](https://github.com/yagom-academy/ios-diary/pull/3)
- [STEP 2](https://github.com/yagom-academy/ios-diary/pull/12)
- [STEP 3](https://github.com/yagom-academy/ios-diary/pull/23)

## 🛠 개발환경 및 라이브러리
- [![swift](https://img.shields.io/badge/swift-5.6-orange)]()
- [![xcode](https://img.shields.io/badge/Xcode-13.4.1-blue)]()
- [![iOS](https://img.shields.io/badge/iOS-14.0-red)]()

## 🔑 키워드
- `NotificationCenter`
- `CoreData`
- `AttributedString`
- `Dynamic Type`
- `Core Location`
- `Lightweight Migration`
- `Layer`
- `ViewModel`
- `UseCase`
- `Repository`
- `Observable`
---

## [STEP 3]
### 고민한 점
1️⃣ 계층 및 역할 분리
- ViewController에서 View를 제외한 로직들을 ViewModel Layer로 분리
- ViewModel의 역할을 ViewModel에게 주입받은 정보를 토대로 Repository에 지시해주는 UseCase Layer로 분리
- NetworkManager의 역할을 데이터 가공 역할을 위한 Repository Layer로 분리

2️⃣ ViewModel
- View는 View의 역할만 집중하기 위해 ViewModel Layer 사용
- ViewModel Layer만을 차용하는 것 보단 실제 MVVM과 유사하게 활용하기 위해 Hot, Cold Observable을 통한 바인딩 및 이벤트 처리 구현

3️⃣ HotObservable, ColdObservable
- Alert 기능에 Observable을 사용할 수 있을지에 대해 고민했다.
- Network 통신을 통해 얻은 icon(String)은 core data에 저장되어있다. UI에 Image를 나타낼 때, HotObservable을 통해 UIImageView에 뿌려주는 방법을 선택했다.
- 하지만 Observable 초기화와 동시에 listner 클로저가 실행되는 HotObservable 특성 때문에 Alert을 기능을 구현하기 위해 Observable을 사용하는 것이 어려웠다.
- 따라서 ColdObservable 객체를 새로 만들어서 Alert 관련 기능을 구현했다.
```swift
final class ColdObservable<T> {
    private var value: T? {
        didSet {
            guard let value = value else {
                return
            }

            self.listener?(value)
        }
    }
    
    private var listener: ((T) -> Void)?
    
    func onNext(value: T) {
        self.value = value
    }
    
    func subscribe(listener: @escaping (T) -> Void) {
        self.listener = listener
    }
}
```

4️⃣ 캡슐화에 대한 고민
- MVVM과 유사한 형태로 구조를 설계하면서 객체끼리 의존성을 갖는 것을 어디까지 허용할 것인지 고민했다.
- ViewModel은 View를 알지 못한다는 개념을 기준으로 View와 ViewModel의 역할 분리 및 캡슐화에 대해 고민했다.
- VC에서 ViewModel의 프로퍼티로 직접 접근하는 대신 VC에서는 VM으로 View의 상태를 전달하고 관찰되고 있는 값의 변경을 통해 VC에서 에러처리 등 필요한 동작을 하도록 구현했다.


5️⃣ Open API 통신할 때, 모든 response data를 가져와야 하는가 
- 이번 프로젝트에서는 유저에게 날씨 정보를 표현할 때, 날씨 icon만을 사용하기 때문에 모든 response data를 가져와야 하는가에 대해서 고민을 했다.
- open API는 불특정 다수가 사용하기 때문에 모든 데이터를 가지고 있는 것이고, 사용자에 따라서 필요로하는 정보만을 가져오는 것이라 판단했다.
- 따라서 통신 response data를 파싱하는 모델을 설계할 때 필요한 데이터인 icon만을 파싱할 수 있도록 했다.

6️⃣ 코어데이터에서 날씨정보를 어떻게 저장할 것인가
- Core Data의 모델을 변경하면서 날씨정보로 어떤 데이터를 저장할지 다음 중에서 고민했다.
    - icon(String)을 갖는 방법
    - 날씨 icon image에 해당하는 URI를 갖는 방법
    - 다운로드받은 이미지 자체를 갖는 방법

- 결과적으로 첫 번째 방법을 선택했고, 이미지 캐싱을 통해 동일한 이미지를 다운로드 받는 과정을 방지했다.

7️⃣ Requesting Authorization for Location Services에 대한 고민
- 사용자 권한 동의를 앱의 첫 실행화면에서 할 것인지, 위치 정보를 얻어야 하는 순간에 할 것인지 고민했다.
- 첫 실행화면에서 할 경우: 사용자의 모든 일기에 위치정보가 추적됩니다. 만약 사용자가 경우에 따라 특정 일기에는 이 기능을 사용하고 싶지 않을 수도 있다
- 새로운 일기를 작성하는 화면에서 할 경우: 일기를 작성할 때마다 동의를 해야하는 번거로움이 있지만, 사용자에게 더 폭넓은 선택권을 줄 수 있다.
- 이러한 근거로 새로운 일기를 작성하는 화면에서 할 때, 위치 정보에 대한 사용자 권한을 받는 것을 선택.

8️⃣ Authorization for Location Services 거절 시 어떻게 처리할 지에 대한 고민
- 만약 사용자가 거절하게 된다면 해당 사항에 대한 알럿을 띄워주고, 디바이스 설정화면으로 이동하여 사용자가 직접 설정해주도록 유도했다.


### 질문사항
1️⃣ TopViewController
- 뷰 계층을 무시하고 현재 최상위 뷰 컨트롤러를 찾아 그곳에 Alert을 띄우는 방법이 적절한 방법인지
