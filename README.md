# 일기장 프로젝트 저장소

> 프로젝트 기간 2022.06.13 ~ 2022.07.01 </br>
팀원 : [@Quokkaaa](https://github.com/Quokkaaa) [@Taeangel](https://github.com/Taeangel) / 리뷰어 : [@라자냐]

## 목차

- [프로젝트 소개](#프로젝트-소개)

- [STEP 1](#step-1)
    + [고민한점](#고민한점)
    + [궁금한점](#궁금한점)


- [그라운드 룰](#그라운드-룰)
    + [활동 시간](#활동-시간)
    + [코딩 컨벤션](#코딩-컨벤션) 

---
## [STEP 1]
### 고민한점
**가로 길이가 모호하다는 말**가로 길이가 모호하다는 에러에 대해서
공식문서를 확인해보니 뷰의 위치와 크기를 정해주지않았을때, 동일한 우선순위를 가진 뷰가 존재할때 발생하는것으로 확인하였습니다. 저의 에러같은경우 후자 문제였고
horizontal stackView내에 두개의 UILabel이 존재하는데 이 두 레이블의 길이의 우선도를 정해줌으로써 해결할 수 있었습니다.
`label.setContentCompressionResistancePriority(.required, for: .horizontal)`

**키보드의 동적인 스크롤 설정**
키보드의 높이만큼 contentInset을 올려주도록 설정하는 방식으로 구현이되는데 이에 필요한 contentInset과 contentOffset의 차이점에대해서 간단하게 알아보았습니다.

**tableView를 구현하는 방법에대해서**
UITableViewController를 상속받아서 구현하는 방법 vs UIViewController를 상속받아서 tableView프로퍼티를 만들어 구현하는 방법이 있었습니다.

STEP1 내용으로만 보면 UITableViewController을 상속받아서 구현해도 전혀 무리가 없어보였습니다. 그런데 다음 STEP과 다른 기능들을 추가하는 확장성을 고려해보니 tableView 프로퍼티를 따로 만들어서 사용하는게 유연할것같아 후자로 구현하였습니다

**JsonSingleton**
만약 제이슨Deoder을 사용할 경우 아래와 같이 사용하게 되는데 
`let diaryData = try? JSONDecoder().decode([Diary].self, from: jsonData)`
이와 같이 사용하게 되면 decode할 때마다 JSONDecoder()계속 생성을 하기 때문에 singleton을 사용하였는데 어떤 방향이 더 효율적인지 고민하였습니다.

**파일분리**
기존에 MVC패턴으로 view와 controller와 model폴더를 각각 만들어서 파일을 관리했었습니다. 그런데 코드를 수정하게될때 특정 화면을 찾아가서 수정하기에는 번거로움이있었습니다. 그래서 Scene별로 폴더를 구분하여 관리를 해주었습니다.

Utils라는 폴더로 extension, sington, protocol, 등을 관리하고있다. 이는 유용한 편리한이라는 뜻을 가지고 있으며 기본적으로 Model에서 사용한 구조에서 더 편리하게 개조를 하거나 데이터를 가져와줄 수 있는 부가적인 구조를 넣어주는것으로 이해하였다.

**폴더네이밍에 대해서**
보편적으로 Extension폴더내에 Extension파일을 생성할때 타입+extension이라는 네이밍을 자주써주는데 Extension폴더내에 있는 파일인데 +extension이라는 네이밍을 붙여줄필요가 있을까?
type.method() 이런식으로 접근하듯 같은 맥락이라고 생각하면 없애도 무방할것같아 지워주는 방향으로 네이밍을 작성하였다. 같은 맥락으로 프로젝트 이름이 Diary인데 내부파일 이름에 Diary를 붙여주는 것도 더 햇갈릴 수 있을것 같아 최대한 중복되는 네이밍은 생략하려고 했습니다.



### 해결한점

<img width="400px" src="https://i.imgur.com/JQ8LhpV.png"/>

위 사진과 같이 cell이 계단형식으로 나오는 문제가 발생하여 계속 찾아보았는데요 문제가 cell이 겹치는 것이 문제라 생각했습니다 그래서 문제를 해결 하려고 cell안에 폰트를 변경하여 cell이 겹치지 않도록 해결하였습니다.

조언부탁드립니다

## 그라운드 룰

### 활동시간
변동사항이 있으면 DM을 보내줄 것

#### 
- 오전 9시 ~ 22시 
- 점심시간 12시 30분 ~ 14시
- 저녁시간 6시 ~ 7시

---

### 공식 문서 및 세션 활동, 일정
- 전날 공부한 것을 공유
- 모르는 내용을 서로 묻기
- 숙지 완료가 되면 프로젝트 진행

---

### 코딩 컨벤션
#### 1. Swift 코드 스타일
[스타일가이드 컨벤션](https://github.com/StyleShare/swift-style-guide#%EC%A4%84%EB%B0%94%EA%BF%88)

#### 2. 커밋 메시지
#### 2-1. 커밋 Titie 규칙
```
feat: [기능] 새로운 기능 구현.
fix: [버그] 버그 오류 해결.
refactor: [리팩토링] 코드 리팩토링 / 전면 수정이 있을 때 사용합니다
style: [스타일] 코드 형식, 정렬, 주석 등의 변경 (코드 포맷팅, 세미콜론 누락, 코드 자체의 변경이 없는 경우)
test: [테스트] 테스트 추가, 테스트 리팩토링(제품 코드 수정 없음, 테스트 코드에 관련된 모든 변경에 해당)
docs: [문서] 문서 수정 / README나 Wiki 등의 문서 개정.
chore: [환경설정] 코드 수정
file: [파일] 내부 파일 수정

```

#### 2-2. 커밋 Body 규칙
- 현재 시제를 사용, 이전 행동과 대조하여 변경을 한 동기를 포함하는 것을 권장
- 문장형으로 끝내지 않기
- subject와 body 사이는 한 줄 띄워 구분하기
- subject line의 글자수는 50자 이내로 제한하기
- subject line의 마지막에 마침표(.) 사용하지 않기
- body는 72자마다 줄 바꾸기
- body는 어떻게 보다 무엇을, 왜 에 맞춰 작성하기
