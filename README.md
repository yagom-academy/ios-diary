## 일기장
Core Data를 활용하여 로컬에 데이터를 저장하는 일기장 앱

## 팀원(마리솔 & 두기)

![](https://i.imgur.com/D1eMxU3.png) <img src="https://i.imgur.com/b9JhIqK.jpg" width="250" height="350"/>

[마리솔](https://github.com/marisol-develop),[두기](https://github.com/doogie97)

## 프로젝트 기간
>2022-06-13 ~ 2022-07-01
## 타임라인
>6/13(월): SwiftLint 설치, SwiftLint rule 설정
6/14(화): 코드로 리스트뷰와 다이어리 뷰 구성, JSON 데이터 파싱
6/14(수): 다이어리 뷰에 데이터 할당 기능 구현, 키보드 자동스크롤 기능 구현, STEP1 PR
6/15(목): Core Data 학습
>6/16(금): STEP1 리팩터링

## 실행 화면(기능 설명)
### 1. List View와 Diary View
![](https://i.imgur.com/Rcangs4.gif)

### 2. 키보드 자동 스크롤 기능 
![](https://i.imgur.com/5pnZc5m.gif)

### 3. 가로모드 지원
![](https://i.imgur.com/uU1r5WO.gif)

## 트러블 슈팅

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

![](https://i.imgur.com/FxUVGUx.png)

![](https://i.imgur.com/wsKw6Vl.png)


위와 같이 DiaryViewController가 init 될 때 diary를 파라미터로 받고 viewDidLoad에서 뷰 요소들에게 할당해주는 방식으로 구현 하니 정상 작동 하였다.

