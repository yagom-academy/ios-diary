# ✍️ 일기장 프로젝트 저장소 
 
> 프로젝트 기간 2022.06.13 ~ 2022.07.01 </br> 
팀원 : [@Quokkaaa](https://github.com/Quokkaaa) [@Taeangel] (https://github.com/Taeangel) / 리뷰어 : [@라자냐] 
 
## 목차
 
- [프로젝트 소개](#프로젝트-소개) 
 
- [STEP 1](#step-1) 
    + [기능구현](#기능구현) 
    + [타임라인](#) 
    + [고민한점](#고민한점) 
    + [궁금한점](#궁금한점) 

- [그라운드 룰](#그라운드-룰)
    + [활동 시간](#활동-시간)
    + [코딩 컨벤션](#코딩-컨벤션)

---
## [STEP 1]

# 🎥 기능 구현

|세로화면|에러화면|
|:---:|:---:|
|![](https://user-images.githubusercontent.com/91132536/174265726-815a4148-049b-45a3-9a05-7ea53f3f55ed.gif)|![](https://user-images.githubusercontent.com/91132536/174265714-28bc11b4-e890-47ce-9efa-7c18d2405eae.gif)|


|가로화면|
|:---:|
|![](https://user-images.githubusercontent.com/91132536/174265724-877d64e6-3b6e-4172-b7ff-e5c6ed28f5a1.gif)|

# 🗓 타임라인
- 월 - 그라운드룰 정하기 및 issue 설정 / swift lint 적용해보기(optional)
- 화 - UIKit: Apps for Every Size and Shape 시청
- 수 - Making Apps Adaptive, Part 1 / Script, Making Apps Adaptive, Part 2 / Script / 학습활동예습(Core Graphics)
- 목 - 오전 학습 활동 예습 / 학습활동 정리 및 프로젝트 PR보내기
- 금 - README작성 및 리펙토링

# 🤔 고민한점
**가로 길이가 모호하다는 말**

가로 길이가 모호하다는 에러에 대해서 공식문서를 확인해보니 뷰의 위치와 크기를 정해주지않았을때, 동일한 우선순위를 가진 뷰가 존재할때 발생하는것으로 확인하였습니다. 저의 에러같은경우 후자 문제였고 horizontal stackView내에 두개의 UILabel이 존재하는데 이 두 레이블의 길이의 우선도를 정해줌으로써 해결할 수 있었습니다.
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


# 🔥 Trouble Shooting
<img width="400px" src="https://i.imgur.com/JQ8LhpV.png"/>

위 사진과 같이 cell이 계단형식으로 나오는 문제가 발생하여 계속 찾아보았는데요 문제가 cell이 겹치는 것이 문제라 생각했습니다 그래서 문제를 해결 하려고 cell안에 폰트를 변경하여 cell이 겹치지 않도록 해결하였습니다.

## swiftlint를 적용후 gitignore에 추가하지 않고 commit
gitignore swiftlint 적용방법
```
# swiftlint
/Pods    //폴더라 /붙여줌
Podfile.lock
Podfile
```
를 gitignore에 넣어주면 된다 

이미 gitignore에 올라간 파일을 지우기위해서는 
gitignore에 무시할 파일을 넣어준다음에 

```
git rm -r --cached .
git add. 
git commit -m "커밋메세지"
git push origin {브랜치명}
```
위순으로 입력해주면된다.

# STEP2

## 고민한점
- 키보드를 내리고 list화면으로 이동하면 두번이 저장이된다. 이를 어떻게 해결할 수 있을까 ??
- background에서 데이터저장 기능을 수행할 수 있는 방법을 고민
- Background로 진입했을때의 @objc 메서드 네이밍에 설정에 관하여
- writeViewcontroller과 DetailViewController가 겹치는 부분에 대하여 어떻게 처리할 것이가에 대한 고민 -> 겹치는 부분이 많다는 점과 @objc 메서드로 인해 상속으로 중복코드를 해결하려 결정
- data가 업데이트를 전체를 viewWillAppear에서 업로드 하는 부분은 낭비라는 고민 


```swift=
// MARK: saveDiaryData Notification

private extension WriteViewController {
  // SceneDidEnterBackground
  func addSaveDiaryObserver() {
    NotificationCenter.default.addObserver(
      self,
      selector: #selector(diarDataSave),
      name: Notification.Name("saveDiaryData"),
      object: nil)
  }
  
  func removeSaveDiaryObserver() {
    NotificationCenter.default.removeObserver(self)
  }
	// 1
  @objc func diarDataSave() {
    self.saveDiaryData()
  }
}
	// 2
  @objc func diarDataSaveDidEnterBackground() {
    self.saveDiaryData()
  }
```
- Entity Diary로 update할때 발생하는 번거로움

```swift
func updateContext(diary: Diary) {
    let  request = Diary.fetchRequest()
    
    guard let identifier = diary.identifier,
    let title = diary.title,
    let content = diary.content,
    let date = diary.createdDate else { return }
    
    request.predicate = NSPredicate(format: "identifier == %@", identifier)
    
    do {
      let diarys = try viewContext.fetch(request)
      diarys.forEach {
        if $0.identifier == identifier {
          $0.title = title
          $0.createdDate = date
          $0.content = content
        }
      }
    } catch {
      
    }
  }
```
![](https://i.imgur.com/lG7AWrI.png)

Diary타입자체가 static으로 선언되어있기 떄문에 NSPredicate인스턴스를 에 static 값을 할당해주려면 일일히 바인딩을 해주어야하는 번거로움이 발생했다.

이렇게 바인딩을 해주는방법이있고 DiaryModel Type을 하나만들어서 인스턴스를 사용하는 방법도 있을것같다. 어떻게해야할까 ?


```swift=

 func deleteContext(identifier: String) {
    let request = Diary.fetchRequest()
    request.predicate = NSPredicate(format: "identifier == %@", identifier)
    
    do {
      let diarys = try viewContext.fetch(request)
      diarys.forEach {  viewContext.delete($0) }
    } catch {
      fatalError()
    }
  }

```

```swift=
func deleteContext(identifier: String) {
    let request = Diary.fetchRequest()
    request.predicate = NSPredicate(format: "identifier == %@", identifier)
    
    do {
      guard let diary = try viewContext.fetch(request).first else {
        return
      }
      viewContext.delete(diary)
    } catch {
      fatalError()
    }
  }
```
두개중 고민 어느 방식이 좋을지 아니면 fetch가 first만 반환하는 메서드를만들지?

```swift=
func tableView(
    _ tableView: UITableView,
    trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath
  ) -> UISwipeActionsConfiguration? {
    
    let context = UIContextualAction(style: .destructive, title: "삭제") { _, _, completion in
      guard let diary = self.diarys?[indexPath.row].identifier else {
        return
      }

      self.diarys = CoredataManager.sherd.deleteContext(identifier: diary)
      completion(true)
    }
    
    let configuration = UISwipeActionsConfiguration(actions: [context])
    configuration.performsFirstActionWithFullSwipe = false
    return configuration
  }
```
cell을 삭제할 방법에 대해 고민을 하였습니다.

## Trouble Shooting

1. 에러에 원인을 모르겠습니다.
### [Error]
![](https://i.imgur.com/8V4yaRO.png)

### [Before]

![](https://i.imgur.com/inHPQAn.png)

### [After]
![](https://i.imgur.com/8oNM1AI.png)

### [파일복제해야만하는가]
![](https://i.imgur.com/4zyBuEt.png)

2. 일의 순서를 대충 정했을때 발생한 오류
textView의 title과 content를 구분하는 작업부터 했어야 했는데 일단 넘어가자~ 라는 안일함으로 삽질을 시작했다.

핵심은 데이터 저장 및 업데이트 시 title과 content 모두 textView.text에 들어가있었다.프로잭트 마지막에 title과 content를 분리하는 기능을 구현하는 순으로 계획을 했었는데 textView.text에서 title과 content를 처음부터 분리하여 넣었으면 이처럼 고생하지 않았을 텐데 일의 순서를 차례대로 정했어야 했는데 처음에 순서를 정할때 좀더 공들여 순서를 정해야 겠다. 그래야 나중에 삽질을 하지 않을 확률이 올라갈 것 같다.

- title과 content를 분리하고 다시 textView에 합치는 구조이다. 그런데 여기서 분리하고 합친후 특정 cell을 클릭하고 나갔다가를 계속반복(업데이트를 반복)했을때 textView의 text가 배로 늘어나거나 content가 cell에 업데이트가 안되던가 하는 문제가 발생했다.

[문제 발생의 원인]
title과 content를 분리할때 첫문단을 title로 꺼내와서 저장을하는데 전에 데이터를 업데이트하면서 title 과 content가 붙어서 첫문단에 기록이 되는 현상이 발생했다.

[해결방법]
title과 content 사이에 `\n`을 넣어줌으로써 첫문단을 content를 구분해주었다.

3. 더보기에서 글 삭제 후 MainVC의 TableViewCell 뒤섞임 오류 해결

이전에는 deleteContext메서드에서 viewContext.save를 해주지않았었지만 아래와 같이 저장 코드 추가하여 해결했따.

```swift=
      guard viewContext.hasChanges else {
        return []
      }
      
      try viewContext.save()
```
정확한 원인은 모르겠으나 캠퍼의 도움으로 해결했음.

4. delegate패턴으로 값을 넘겨주면 


[Before]
```swift=
final class MainViewController: UIViewController {
  private lazy var baseView = ListView(frame: view.bounds)
  private var diarys: [Diary]? {
    didSet {
      DispatchQueue.main.async {
        self.baseView.tableView.reloadData()
      }
    }
  }
	
extension MainViewController: Diaryable {
  func updateDiary(from diary: Diary) {
    self.diarys?.forEach ({
      if $0.identifier == diary.identifier {
        $0.title = diary.title
        $0.content = diary.content
      }
    })
  }
```

[After]

```swift=
extension MainViewController: Diaryable {
  func updateDiary(from diary: Diary) {
    self.diarys?.forEach ({
      if $0.identifier == diary.identifier {
        $0.title = diary.title
        $0.content = diary.content
      }
    })
    DispatchQueue.main.async {
      self.baseView.tableView.reloadData()
    }
  }
```

[After]

```swift=
extension MainViewController: Diaryable {
  func updateDiary(from diary: Diary) {
    DispatchQueue.main.async {
      self.baseView.tableView.reloadData()
    }
  }
```

기존에 self.diarys의 데이터를 수정하면 내부적으로 tableView.reloadData가 실행되도록 설정해놓았다.
그래서 Delegate를 실행한 후에도 이와같이 리로드를 해줄 것으로 예상되기때문에 데이터전달 만해주고 값을 바꿔주었는데 
MainView에 반영이 되질않았다. 한참을 의심하다가 디버그해보니 tableViewDataSource메서드가 재실행이 되고 있지를 않았던것이다.
그래서 reload를 명시적으로 진행해주었다.

델리게이트를 실행할때는 왜 반영이 되질않는걸까 >?

4-1. 충격적인 사실을 발견했다
델리게이트로 diary 값을 넘겨주고 나서 diary값을 업데이트 해주지않고 reloadData만 해줘도 값이 갱신이된다.
Diary 값이 원본은 참조하고 있어서 그런건가 확인을 해보았지만 그런이유는 아닌 것으로 판단했따.

reloadData와 CoreData값을 저장하는 diarys데이터와 어떤 연관이 존재하길래..이런 현상이 발생하는걸까 ?

reloadData가 CoreData를 불러와주기라도 하는걸까 ?


## ✅ 그라운드 룰

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
- 

