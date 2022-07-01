# 일기장

## 소개
사용자의 현재 위치를 기반으로 그날의 날씨와 일기를 함께 기록하는 일기장 프로젝트입니다.

## 팀원 소개
|iOS|iOS|
|:---:|:---:|
|[Minseong](https://github.com/Minseong-yagom)|[Lingo](https://github.com/llingo)|
|<img width="150" src="https://avatars.githubusercontent.com/u/94295586?v=4"/>|<img width="150" src="https://avatars.githubusercontent.com/u/94151993?v=4"/>|

## 프로젝트 기간

> 2022.06.13(월) ~ 07.01(금)

## 키워드

- `AutoLayout Programmatically`
- `DataFormatter`
- `UITextView` `UITextViewDelegate`
- `Core Data`
- `UISwipeAction`
- `UIAlertController - ActionSheet`
- `UIActivityController`
- `URLSession` `URLRequest`
- `Lightweight Migration`
- `WeatherOpenAPI 사용`
- `Core Location`
- `UIImageView`

## 프로젝트 구조

![](https://i.imgur.com/Ef4qlN4.png)

## 트러블 슈팅

1️⃣ **TextView의 contentInset를 주었을 때에 대해**

![](https://i.imgur.com/wcS3Z8V.gif)

`bodyTextView.contentInset`을 키보드의 높이만큼 올려주어 입력 중인 부분이 키보드에 가려지지 않게 하는 과정에서 위 gif를 보면 중간 부분에 커서를 위치시킨 후 입력했을 땐 `contentInset`의 변화에 따른 화면 스크롤이 되지 않고 커서가 키보드와 근접한 상태에서는 스크롤이 자동으로 되는 원리 (즉, 무엇을 기준으로 판단하여 작동하는 건지?)에 대한 문제가 있었다.

> 해결책

UITextView 의 경우는 cursor 의 위치를 기반으로 스크롤이 조절되는 것을 발견
그래서 추론을 해 보면 contentInset 값이 바뀔 때 UITextView 에서 현재 뷰 frame을 기준으로 cursor의 위치를 계산한 뒤에 커서 위치 + 변경되는 contentInset (여기서는 bottom 값)를 했을 때 frame 사이즈를 넘어가면 커서의 위치를 적절하게 스크롤하는 처리가 들어가 있는게 아닌가 추론하였다.

2️⃣ **파일명이 바뀐 프로젝트 Merge 하는 과정**
리팩토링 중 파일명을 변경한 일이 있었고 이 후의 Merge 과정에서 파일명이 달라져 파일을 인식하지 못해 아래 사진과 같이 Conflict이 발생했다.

![](https://i.imgur.com/hAR12Cv.png)

충돌 상황을 도식화하면 아래와 같았다.

![](https://i.imgur.com/NcGUBHp.png)

`main`의 PersistentManager라는 파일의 이름이 `feature-1`에서 DiaryStorageManager, `feature-2`에서 DiaryRepository로 변경되었다고 하자. feature-1을 main 브랜치로 merge가 될 때는 아무 문제가 발생하지 않지만 feature-2를 main에 merge할 때 PersistentManager라는 파일을 찾을 수 없게되어 (이미 DiaryStorageManager로 변경이 됨) 충돌이 발생한 것이다.

> 해결책

cherry-pick을 통해 충돌나지 않는 부분은 선택하여 merge하고 경고가 뜨는 커밋 부분은 수동으로 직접 수정하여 문제를 해결할 수 있었다.

3️⃣ **날씨 데이터를 못 읽어오는 문제 발생**

CLLocationManagerDelegate의
```swift
func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation])
```
위 메서드를 사용하여 사용자의 위도와 경도를 구해 그 위치를 바탕으로 날씨를 읽어와야했다.
하지만 예상과 달리 시뮬레이터를 작동시키니 날씨를 못 가져오는 문제가 발생하였다.

lldb를 통해 문제를 찾는 도중 위도와 경도가 nil값이 들어오는 것을 확인하고 구현한 코드가 잘못되었나 임시데이터(위도, 경도)를 만들어 테스트를 진행했다. 그 결과 코드는 정상작동하였고 문제는 외부요소에 있을 것으로 판단하여 외부요소를 찾기 시작했다.

그리고 시뮬레이터의 location이 none으로 되어있는 것을 발견했다!🥲

> 해결책

시뮬레이터의 location을 설정해 사용자 위치를 생성해줌으로써 위 문제를 해결하였다!

4️⃣ **키보드 Notification이 두번 불리는 문제**
TextView를 입력할 때 표시되는 키보드로 인해 일부 영역이 가려지는 문제가 있었고 이를 해결하기 위해 UIResponder의 KeyboardWillShow Notification을 통해 받은 키보드의 높이만큼 ScrollView의 ContentInset를 높여주고 KeyboardWillHide가 될때 0으로 초기화 하도록 구현했다.

하지만, 의도한 것과 달리 UIResponder의 KeyboardWillShow Notification은 계속해서 호출이 됐다.

<img width="400" src="https://i.imgur.com/27pjNOx.gif"/> <br/>

> 해결책

Keyboard의 표시 상태를 프로퍼티(isKeyboardVisible)에 저장하고 분기처리를 추가하여 해결했다.

## 실행화면

|앱 시작 화면|메인 ➡️ 상세 페이지: 화면 이동|상세 페이지: 키보드 동작|상세 페이지: 화면 스크롤|
|:---:|:---:|:---:|:---:|
|![](https://i.imgur.com/OVqHlzt.gif)|![](https://i.imgur.com/EjOBh2Q.gif)|![](https://i.imgur.com/GPcQIHy.gif)|![](https://i.imgur.com/VG1QTVi.gif)|

|메인 페이지: 가로모드 변경|상세 페이지: 가로모드 변경|[생성 화면] 일기장 생성 기능|[상세 화면 - 수정] 키보드를 내렸을때 자동 저장|
|:---:|:---:|:---:|:---:|
|![](https://i.imgur.com/Uq10Z33.gif)|![](https://i.imgur.com/woIfzhd.gif)|![](https://i.imgur.com/QzMWrN5.gif)|![](https://i.imgur.com/DU4LsdE.gif)|

|[메인 화면] 공유 기능|[메인 화면] 삭제 기능|[상세 화면 - 수정] 백그라운드 자동 저장|[상세 화면 - 수정] 이전 화면으로 갈때 자동 저장|
|:---:|:---:|:---:|:---:|
|![](https://i.imgur.com/ReUTKjP.gif)|![](https://i.imgur.com/VBxt9BS.gif)|![](https://i.imgur.com/eIYHWNq.gif)|![](https://i.imgur.com/tUPSpmW.gif)|

|[상세 화면] 공유 기능|[상세 화면] 삭제 기능|[생성 화면] 현재 위치 허용 및 날씨 데이터 추가|[메인 화면] 가로 모드일때|
|:---:|:---:|:---:|:---:|
|![](https://i.imgur.com/cUqWiQX.gif)|![](https://i.imgur.com/5Y678OU.gif)|![](https://i.imgur.com/NXnQoYw.gif)|![](https://user-images.githubusercontent.com/94151993/176453868-2b88b0fe-b2d7-4183-b931-8755ba222c86.gif)|
