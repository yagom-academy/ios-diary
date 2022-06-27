## 📝 일기장
Core Data를 활용하여 로컬에 데이터를 저장하는 일기장 앱

## 🥳 팀원(마리솔 & 두기)

|[마리솔](https://github.com/marisol-develop)|[두기](https://github.com/doogie97)|
|:-:|:-:|
|![](https://i.imgur.com/D1eMxU3.png)|<img src="https://i.imgur.com/ItogH6r.png" width="380" height="380"/>


## 📅 프로젝트 기간
>2022-06-13 ~ 2022-07-01

## ⏰ 타임라인

| 날짜     | 진행 내용                                                                                     |
| -------- | - |
| 6/13(월) | SwiftLint 설치, SwiftLint rule 설정  |
| 6/14(화) | 코드로 리스트뷰와 다이어리 뷰 구성, JSON 데이터 파싱 |
| 6/14(수) | 다이어리 뷰에 데이터 할당 기능 구현, 키보드 자동스크롤 기능 구현, STEP1 PR |
| 6/15(목) | Core Data 학습 |
| 6/16(금) | STEP1 리팩터링 |
| 6/20(월) | Core Data의 CRUD 구현 |
| 6/21(화) | Core Data에서 가져온 데이터를 뷰에 띄우는 기능 구현 (DiaryViewController의 공통기능으로 구현) |
| 6/22(수) | 일기 공유와 삭제 기능 구현 |
| 6/23(목) | 개인 공부 |
| 6/24(금) | STEP2 리팩터링 |

## 📱 실행 화면

|1. List View와 Diary View|2. 키보드 자동 스크롤 기능|
|:-:|:-:|
|![](https://i.imgur.com/Rcangs4.gif)|![](https://i.imgur.com/5pnZc5m.gif)|

|3. Create(생성하기)|4. Read(읽어오기)|
|:-:|:-:|
|![](https://i.imgur.com/AuqnAF0.gif)|![](https://i.imgur.com/GXAfQKI.gif)|

|5. Update(수정하기)|6. Delete(삭제하기)|
|:-:|:-:|
|![](https://i.imgur.com/j9lKUvv.gif)|![](https://i.imgur.com/UtSg01N.gif)|

|7. Share(공유하기)|
|:-:|
|![](https://i.imgur.com/VRtuyP1.gif)|

## 💡 트러블 슈팅

### 📌 tableview cell hierarchy 확인시 요소들이 점점 앞으로 나오는 현상

![](https://i.imgur.com/tTYTlu3.png)
테이블 뷰에서 cell을 추가한 뒤 hierarchy를 확인하면 위 사진과 같이 앞으로 점점 나오는 현상이 있었다.
기능 요구서와 최대한 동일하게 구현하고 싶어서 아래코드와 같이 셀의 높이를 지정해줬었는데, 
```swift=
if UIDevice.current.orientation.isLandscape {
    return UIScreen.main.bounds.width * 0.08
} else {
    return UIScreen.main.bounds.width * 0.17
}
```

아마 셀의 높이보다 컨텐츠의 높이가 더 커서 이런 현상이 발생하지 않았나 추측하고 있다.

위 문제와 더불어서 SE와 같은 노치가 없는 디바이스에서는 가로모드시 아래와 같이 cell 내에서 글자의 위 아래가 잘리는 현상이 있었다.(가로에 대한 비율로 높이를 만들다 보니 노치가 없을 때의 비율에서 뭉개지는 것이다)
![](https://i.imgur.com/sdJ6jUq.gif)


cell의 높이를 지정하지 않아도, cell 내부 컨텐츠의 크기에 따라 cell의 크기가 조정될 것이라고 생각해서 cell의 높이를 지정해주는 코드를 제거하였더니 노치 없는 디바이스에서 가로모드시 글자가 잘리는 현상과, 뷰 hierarchy에서 cell이 점점 나오는 현상 모두 해결되었다.


### 📌 ListViewController -> DiaryViewController -> DiaryView로 데이터 전달

view는 “정보를 보여주는 역할” 만 해야한다고 생각했다.

그래서 ListViewController에서 cell을 클릭했을 때, 바로 diaryView에게 diary 정보를 넘기는 것이 아니라, ListViewController -> DiaryViewController -> DiaryView 순서로 Diary 데이터 전달 하고자 했다.

![](https://i.imgur.com/6nkpd9W.png)
```셀 터치시 DiaryViewController로 push 하면서 메서드를 호출```

![](https://i.imgur.com/Zvvzfu3.png)

![](https://i.imgur.com/ajSHN9K.png)
```위에서 호출된 메서드는 바로 DiaryView의 메서드(뷰에 할당하는 메서드)를 호출```

그렇게 하기 위해서 위와 같이 메서드를 통해 DiaryViewController에서 diary 데이터를 받고 diaryView에 그 데이터로 뷰를 그려주는 메서드를 만들어서 didSelectRowAt에서 호출했으나, 화면에 그 데이터를 표시하지 못하는 현상이 발생 했는데...

이는 DiaryView가 DiaryViewController의 viewDidLoad가 아닌 메서드를 통해 각 뷰 요소들에게 할당해주는 방식 이어서, 
즉, view가 로드되기 전에 뷰 요소들에게 diary요소들을 할당해주는 메서드를 호출해 주기 때문에 할당이 되지 않았던 것으로 추측하고 아래와 같이 로직을 변경했다.
<img src="https://i.imgur.com/FxUVGUx.png" width="572" height="150"/>

![](https://i.imgur.com/wsKw6Vl.png)


위와 같이 DiaryViewController가 init 될 때 diary를 파라미터로 받고 viewDidLoad에서 뷰 요소들에게 할당해주는 방식으로 구현 하니 정상 작동 하였다.

### 📌 DiaryViewController상속을 통한 공통화
`AddViewController`와 `EditViewController가` 동일한 뷰를 사용하고 있고, 공통으로 사용하는 메서드들이 있어서 `DiaryViewController`라는 부모 ViewController를 만들어서 자식 뷰가 상속 받도록 구현했다.

1) 키보드가 내려가거나
2) 백그라운드에 진입했을 때 

자동으로 저장 또는 업데이트 해야했는데,
cell을 선택해서 (didSelectRowAt) EditViewController에 진입했을 때에는 diary를 전달해주기 때문에, 전역변수로 선언된 diary가 nil이 아닐 때 (Edit)와
diary가 nil일 때 (Add)로 분기 처리를 해주는 방식으로 처리했다.

![](https://i.imgur.com/TQTQBBi.png)
그리고 공통화 기능 구현 전에는 새로운 일기 내용을 저장하는 방식이

textView.text -> core data에 저장하는 방식이었는데,
이렇게 하니 공통화가 힘들어져서
textView.text -> DiaryViewController의 diary 프로퍼티에 저장 -> 저장된 diary를 core data에 저장

하는 방식으로 변경했다.

### 📌 사용자가 일기를 작성할 때 생기는 여러 변수
최초에는 textview에서 가져온 내용 중 첫 번째줄은 title, 두번째 줄은 body 이런 식으로 저장을 했었는데 사용자가 일기를 작성할 때 꼭 위와같은 형식으로 작성하지 않을것이기 때문에 그 대응을 아이폰 기본 어플인 메모 어플을 예시로 수정했다.

![](https://i.imgur.com/LMMtmw7.png)
`(대표적인 예외 케이스로는 줄바꿈 및 띄어쓰기 이후 글을 작성한 케이스)`

공백을 제거하고 가장 먼저 만나는 첫 번째 글은 `title` , 두 번째 글은 `body`로 지정하는게 요구서 사항이지만 위와 같은 상황에서 일기 본문은 사용자가 위와 같은 모양을 의도하고 작성했을 것이다.

그래서 저장된 `title`과 `body`는 list에 표시하기 위한 용도로만 사용하고 `text`라는 요소를 추가하여 일기화면에서는 사용자가 작성한 text 그대로를 보여줄 수 있게 했다.

![](https://i.imgur.com/ar8E2qe.png)
