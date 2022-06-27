# 📔 일기장

> 프로젝트 기간: 2022.06.13 ~ 2022.07.01 
> 팀원: [우롱차](https://github.com/dnwhd0112), [Red](https://github.com/cherrishRed) 리뷰어: [웨더](https://github.com/SungPyo)

## 목차 

## 프로젝트 소개 
📔 일기장
나만의 일기를 만들어 보세요!
저장을 깜빡하셨다구요? 걱정 없습니다. 
자동저장 됩니다!

## 타임라인
- [x] 첫째주 : 화면구성, 키보드, Core Data CRUD 구현
- [x] 둘째주 : Core Data를 이용한 기능 구현, TableView 세세한 동작구현, alert 구현 
- [ ] 셋째주 : 


## 프로젝트 구조

![](https://i.imgur.com/beEnYhe.png)

## 프로젝트 실행 화면
![](https://i.imgur.com/tJfrO7x.gif)

## 🚀 트러블 슈팅
### STEP1
* 키보드 올라오고 내려가는거에 따른 View 변경
* iOS 낮은 버전 시뮬레이터 실행

### 키보드 올라오고 내려가는거에 따른 View 변경
`🤔문제` 
아래 코드와 같이 키보드 관련하여 레이아웃을 주면 textFied 나 textView 가 키보드에 가려지지 않게 알아서 bottom 레이아웃을 수정한다.
```swift
textView.bottomAnchor.constraint(equalTo: keyboardLayoutGuide.topAnchor).isActive = true
```
하지만 위의 기능은 iOS 15버전부터 지원하기 때문에 낮은 버전에서는 실행되지 않았다.

`😆해결`
`if #available(iOS 15.0, *)`를 사용해서 iOS 15.0 보다 버전이 낮다면, Notification을 이용해 키보드가 나타날 때, 메서드를 통해서 아래의 오토레이아웃을 적용해 주었다.

```swift
textViewBottomConstraint = textView.bottomAnchor.constraint(
            equalTo: safeAreaLayoutGuide.bottomAnchor,
            constant: -height // 여기서 height 는 키보드의 높이
        )
```
이때 기존에 적용된 오토레이아웃을 해제해줘야되기 때문에 변수로 관리를 해야한다.

```swift
@objc private func keyBoardShow(notification: NSNotification) {
    guard let userInfo: NSDictionary = notification.userInfo as? NSDictionary else {
        return
    }
    guard let keyboardFrame = userInfo.value(forKey: UIResponder.keyboardFrameEndUserInfoKey) as? NSValue else {
        return
    }
    let keyboardRectangle = keyboardFrame.cgRectValue
    let keyBoardHeight = keyboardRectangle.height
    detailView.changeTextViewHeight(keyBoardHeight)
}
```
키보드의 높이는 Notification 을 이용하면 위의 코드처럼 가져올 수 있다. 

### iOS 낮은 버전 시뮬레이터 실행
`🤔문제`
낮은 버전의 iOS 시뮬레이터를 돌릴 수가 없었다.

`😆해결`
![](https://i.imgur.com/UmDj211.png)
위쪽 시뮬레이터 선택하는 창에서 Download Simulators 를 선택하여 낮은 버전의 시뮬레이터를 설치하면 된다. 하지만 빌드되는 버전에 설정에 따라 실행이 되지 않을수도 있으니 주의해야한다.


### STEP2
* Core Data Fetch 문제
* ViewModel 하나를 두개의 ViewController 가 나눠서 사용해도 되는가?

### Core Data Fetch 문제
`🤔문제`
![](https://i.imgur.com/5ItH8hw.png)
설명 : CoreData에서 fetch로 가져온 데이터 배열을 바로 접근할려고할때 생기는 문제.(다른 팀들에는 이러한 문제가 없었다. 오류문도 Expected DiaryData but found DiaryData로 이상하다.)

이를 해결하기 위해 `as [AnyObjcet]`으로 형변환을 시켰다.


`😆해결`

#### Core Data Fetch 문제 해결

저장할때 NSManagedObject 타입으로 저장을 했었던게 문제가 되었다. 저장할때 사용할 데이터 모델(DiaryData)로 저장해야 문제가 일어나지 않는다. 그래서 우리는 다음과 같이 저장하는 로직을 변경하엿다. 이후 읽어올때 `as [AnyObjcet]`로 변환하지 않아도 오류가 나지않았다.
```swift=
guard let diaryData = NSEntityDescription.insertNewObject(
            forEntityName: DiaryInfo.entityName,
            into: context
        ) as? DiaryData else {
            throw CoreDataError.createError
        }
```


### 두개의 ViewController와 하나의 ViewModel
`🤔문제`

`MainViewController` 와 `DetailVewController` 가 사용하는 데이터가 (DiaryCoreData) 동일하다고 생각 되어서 `TableViewModel` 에서 이를 모두 처리를 해주고 있었다. 
어떤 방식으로 ViewModel 을 나눠 사용해야 하는지에 관한 문제가 있었다.

`1️⃣첫번째 방법`

`Delegate패턴`을 사용해서 `DetailViewController`가 `CoreData`를 변경할때 `MainViewController`가 처리하게 끔 구성이다.
(`ViewModel`이 `MainViewController`에만 있으므로)

```swift 
extension MainViewController: UpdateDelegateable {
    func updatae(diaryInfo: DiaryInfo) {
        do {
            try viewModel.update(data: diaryInfo)
            try viewModel.loadData()
            mainView.reloadData()
        } catch {
            alertMaker.makeErrorAlert(error: error)
        }
    }
    
    func delete(diarInfo: DiaryInfo) {
        do {
            try viewModel.delete(data: diarInfo)
            try viewModel.loadData()
            mainView.reloadData()
        } catch {
            alertMaker.makeErrorAlert(error: error)
        }
    }
}

protocol UpdateDelegateable: UIViewController {
    func updatae(diaryInfo: DiaryInfo)
    func delete(diarInfo: DiaryInfo)
}

final class DetailViewController: UIViewController {
    ...
    weak var delegate: UpdateDelegateable?
    ...
}
```

DetailViewController 에서 일어난 사건을 MainViewController 를 통해 처리해야 한다는 구조가 조금은 이상하다.

`2️⃣두번째 방법`
DetailViewController의 TableViewModel 프로퍼티를 가지게 하여, MainViewController 와 DetailVewController 모두 TableViewModel 에 직접 접근하도록 하는 방법 
```swift 
final class MainViewController: UIViewController {
    ...
    private var viewModel: TableViewModel<DiaryUseCase>
    ...
}

final class DetailViewController: UIViewController {
    ...
    private var viewModel: TableViewModel<DiaryUseCase>
    ...
}
```

`😆해결`
🛑 이부분 해결하고 다시 작성하기

### 유사한 로직의 통일, 분리 

`🤔문제`
delete 버튼 share 버튼을 눌렀을때 동작하는 메서드가 mainViewController 와 DetailViewController 에서 사용되고 있는데, 두 로직이 유사하지만 세세한 부분이 다르다. 

data 를 삭제하고, 공유하는 `handler` 를 `MainViewController` 와 `DetailViewController` 에서 모두 사용있다.

같은 로직이지만 차이는
어떤 `controller` 에서 `TableViewModel` 에 접근하느냐 이다.
이 두 로직이 겹치는 부분이 많다고 생각되는데 같은 클로저를 공유해서 사용할 수 있는 방법이 있는지 궁금하다. 

`😆해결`
🛑 이부분 해결하고 다시 작성하기


### SceneDelegate, AppDelegate 활용
`🤔문제`
어플이 홈화면으로 전환할때 `DetailView` 화면의 data 를 자동 저장 해주기 위해 `SceneDelegate` 에 있는 홈화면으로 전환될 때 불리는 `sceneDidEnterBackground` 메서드를 이용했다.

`1️⃣첫번째 방법`

`AppDelegate` 에서 `delegate` 프로퍼티를 가지고 `SceneDelegate`에서 호출하는 방법이다. (`AppDelegate`는 전역적으로 접근이 가능함으로). 
이 방법은 수정해야 하는 사항이 많고, AppDelegate가 delegate 프로퍼티를 가지고 있어야 한다는 단점이 있다. 

`2️⃣두번째 방법`
두번째 방법은 SceneDelegate에서 뷰를 확인해서 메소드를 실행하는 방법이다. 
```swift=
func sceneDidEnterBackground(_ scene: UIScene) {
((self.window?.rootViewController as? UINavigationController)?.topViewController as? DetailViewController)?.saveData()
}
```

`😆해결`
🛑 이부분 어떤 로직을 선택했는지 고른뒤 다시 작성하기

## ✏️ 학습내용
* CoreData
* KeyBoard
* ActionSheet 
* ActivityVeiw
* TableView Cell 삭제, 추가 
* TableView Swipe
