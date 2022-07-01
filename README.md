# 📒 일기장
> 프로젝트 기간 2022.06.13 ~ 2022.07.01  
팀원 : [malrang](https://github.com/malrang-malrang) [Tiana](https://github.com/Kim-TaeHyun-A) / 리뷰어 : [stevenkim](https://github.com/stevenkim18)

- [Ground Rules](#ground-rules)
- [실행화면](#실행화면)
- [UML](#uml)
- [핵심 고민사항](#핵심-고민사항)
- [챕터별 고민 사항](#챕터별-고민-사항)

## Ground Rules
### 🌈 스크럼
- 10시 ~ 10시30분

### 주간 활동 시간
- 월, 화,수, 목, 금 : 10시 ~ 22시
- 수요일 : 개인공부
- 점심시간 : 12시 ~ 13시
- 저녁시간 : 18시 ~ 20시
- 상황에 따라 조정 가능

###  🪧 코딩 컨벤션

#### Commit 규칙
커밋 제목은 최대 50자 입력
본문은 한 줄 최대 72자 입력

#### Commit 메세지
chore: 코드 수정, 내부 파일 수정.  
feat: 새로운 기능 구현.  
style: 스타일 관련 기능.(코드의 구조/형태 개선)  
add: feat 이외의 부수적인 코드 추가, 라이브러리 추가  
file: 새로운 파일 생성, 삭제 시  
fix: 버그, 오류 해결.  
docs: README나 WIKI 등의 문서 개정.   
correct: 주로 문법의 오류나 타입의 변경, 이름 변경 등에 사용합니다.  
move: 프로젝트 내 파일이나 코드(리소스)의 이동.  
refactor: 전면 수정이 있을 때 사용합니다  
test: 테스트 코드를 작성할 때 사용합니다.  

#### Commit Body 규칙
제목 끝에 마침표(.) 금지
한글로 작성

#### 브랜치 이름 규칙
`STEP1`, `STEP2`, `STEP3`

## 실행화면
<img src="https://i.imgur.com/gXsywNE.gif" width="240"><img src="https://i.imgur.com/CO9T9Sx.gif" width="240"><img src="https://i.imgur.com/dukLNU2.gif" width="240">

## UML
![](https://i.imgur.com/McvowSR.png)

## 핵심 고민사항
### 1️⃣ **MVC 아키텍처에 맞게 역할 분리**


1. **변경 전후의 코드 비교: 커밋내역**


- [refactor: DiaryDataSource, DiaryTableView 커스텀 타입 구현](https://github.com/yagom-academy/ios-diary/pull/27/commits/f9d792ddf033ff7d272d17a5f79094ac9a3b8a1f#diff-0750dfcb7d5c73b8ed5a7346bf47c88e3f9fddd09938586c0b1d6f08394590d9)
- [refactor: DiaryTextView 구현](https://github.com/yagom-academy/ios-diary/pull/27/commits/2bab07567b481818b910770e735d4ff45821de2b)
- [refactor: DiaryViewController navigationController분리](https://github.com/yagom-academy/ios-diary/pull/27/commits/ccfb2f18401056a4ef185c97872300b87e72eab0)

2. **변경전의 구조**


    ![](https://i.imgur.com/I02upmi.png)

    ViewController가 별도의 view 프로퍼티로 가지지 않도록 controller와 view의 역할을 분리했습니다.
    UIViewController의 기본 프로퍼티인 view에 커스텀 view를 할당하고 view의 요소가 필요할 때는 메서드를 통해 간접적으로 접근합니다.


* **DiaryViewController과 DiaryView, tableView, DiaryViewModel, dataSource**


    DiaryViewController의 경우, 커스텀 view(DiaryView)의 tableView의 dataSource 설정이 필요해서 DiaryViewModel를 구현했습니다. view와 관련된 모델이라는 생각으로 viewModel이라는 네이밍을 했습니다.
DiaryViewController는 프로퍼티로 DiaryViewModel을 가지고 tableView는 매개변수로 접근하도록 구현했습니다.(viewController의 view가 이미 tableView를 프로퍼티로 가지기 때문에 viewModel이 굳이 tableView를 프로퍼티로 가지지 않아도 된다고 생각합니다. 또한 model에 view를 가지면 제대로 역할 분리가 되지 않았다고 생각합니다.)

* **DiaryCell과 WeatherAPIManager**


    DiaryCell에서 이미지를 로드할 때 url을 알 필요가 없습니다. 따라서, 네크워크를 관리하는 타입인 WeatherAPIManager를 extension하고 이미지를 받아오는 메서드를 구현했고(setImage 메서드) view에서는 메서드 호출 시 icon 문자열만 넘겨주면 이미지를 세팅할 수 있습니다. WeatherAPIManager의 메서드(setImage 메서드)를 호출하는 부분도 셀이 알 필요는 없을 것 같아서 UIImageView에 메서드를 구현해서 숨겼습니다.

* **UpdateViewController과 UpdateView, keyboard**


    UpdateViewController에서도 view를 따로 분리해서(UpdateView) keyboard 프로퍼티를 view만 가질 수 있습니다.
    

3. **변경후의 구조**


    ![](https://i.imgur.com/ORMIYdS.png)

    각각의 ViewController(DiaryViewController의)에서 사용되는customView(DiaryView)는 내부에서 tableView를 프로퍼티로 갖고 tableView를 화면에 보여주기 위한 기능들만 가지고있기에 customView를 활용하기보다는 tableView자체를 custom하도록 수정하였습니다.

- 3-1 **customView, tableView**


    **변경전 customView**

    ```swift
    final class DiaryView: UIView {
        private let tableView: UITableView = {
            let tableView = UITableView()
            
            tableView.translatesAutoresizingMaskIntoConstraints = false

            return tableView
        }()
    ```

    **변경후 customTableView**
    
    ```swift
    final class DiaryTableView: UITableView {}
    ```
    위와 동일한 방식으로 UpdateViewController에서 사용되는 textView도 custom하여 구현하였습니다.

    DiaryViewController에서 사용되던 DiaryViewModel또한 내부에서 사용되던 UITableViewDiffableDataSource를 custom하여 구현하도록 수정하였습니다.


- 3-2 **viewModel과 datasource**

    **변경전 DiaryViewModel**
    
    ```swift
    final class DiaryViewModel {
        private var dataSource: UITableViewDiffableDataSource<Int, DiaryDTO>?
    }
    ```


    **변경후 datasource**
    
    ```swift
    final class DiaryDataSource: UITableViewDiffableDataSource<Int, DiaryDTO> {}
    ```
    기존 변경 전 코드에서는 DiaryView, DiaryViewModel 내부의 private tableView, private dataSource에 접근하기위해 각각 tableView를 반환하는 메서드, dataSource를 반환하는 메서드 를 사용하여 활용했지만 구조와 타입을 변경하여 dataSource의 메서드들이 tableView를매개변수로 받지 않아도 작동하도록 변경, DiaryView내부의 tableView에 접근하지 않고 직접 tableView를 활용하는 방식으로 수정되었습니다.


    **변경전 DiaryViewController의 datasource관련 로직**
    
    ```swift
    final class DiaryViewController: UIViewController, DiaryProtocol {
        private let viewModel = DiaryViewModel()
        
        private var diaryView: DiaryView? {
            guard let view = view as? DiaryView else {
                return nil
            }
            return view
        }
    override func viewWillAppear(_ animated: Bool) {
            viewModel.updataTableView(tableView: diaryView?.getTableView())
        }
    }
    ```

    **변경후 DiaryViewController의 datasource관련 로직**
    
    ```swift
    final class DiaryViewController: UIViewController, DiaryProtocol {
        ...    
        private lazy var dataSource = DiaryDataSource(tableView: tableView) {
            tableView, indexPath, itemIdentifier in
            return self.setUpDataSource(tableView: tableView,
                                        indexPath: indexPath,
                                        itemIdentifier: itemIdentifier)
        }
        
        override func viewDidLoad() {
            super.viewDidLoad()
                    
            ...
            
            #if DEBUG
                dataSource.setUpSampleData()
            #else
                dataSource.setUpCoreData()
            #endif
        }
        ...
    }
    ```

    DiaryViewController, UpdateViewController에서 사용되는 NavigationController 관련 로직들은 DiaryViewController, UpdateViewController에서 각각의 파일 내부에 UINavigationController를 extension하여 구현하도록 수정했습니다.

- 3-3 **viewController의 NavigationController**

    **변경전 DiaryViewController의 NavigationController관련 로직**
    
    ```swift 
    final class DiaryViewController {
        enum Const {
            static let navigationTitle = "일기장"
            static let registerButton = "+"
        }
            private func setUpNavigationController() {
            func setUpRightItem() {
                let weight = UIFont.systemFont(ofSize: 35, weight: .light)
                let attributes = [NSAttributedString.Key.font: weight]
                let registerButton = UIBarButtonItem(
                    title: Const.registerButton,
                    style: .plain,
                    target: self,
                    action: #selector(moveRegisterViewController)
                )
                
            registerButton.setTitleTextAttributes(attributes, for: .normal)
            
            navigationItem.rightBarButtonItem = registerButton
            }
            
            navigationItem.title = Const.navigationTitle
            setUpRightItem()
        }
    
        @objc private func moveRegisterViewController() {
            let viewContoller = UpdateViewController()
            
            navigationController?.pushViewController(viewContoller, animated: true)
        }
    
    }
    ```


    **변경후 UINavigationController extension**
    
    ```swift
    private extension UINavigationController {
        private enum Const {
            static let navigationTitle = "일기장"
            static let registerButton = "+"
        }
        
        func setUpNavigationController(viewController: UIViewController) {
            func setUpRightItem() {
                let weight = UIFont.systemFont(ofSize: 35, weight: .light)
                let attributes = [NSAttributedString.Key.font: weight]
                let registerButton = UIBarButtonItem(
                    title: Const.registerButton,
                    style: .plain,
                    target: self,
                    action: #selector(moveRegisterViewController)
                )
                
                registerButton.setTitleTextAttributes(attributes, for: .normal)
                
                viewController.navigationItem.rightBarButtonItem = registerButton
            }
            
            viewController.navigationItem.title = Const.navigationTitle
            setUpRightItem()
        }
        
        @objc private func moveRegisterViewController() {
            let viewContoller = UpdateViewController()
            
            pushViewController(viewContoller, animated: true)
        }
    }
    ```
### 2️⃣ **새로 작성된 데이터와 수정된 데이터를 리스트에서 어떻게 보여줄까🤔**
데이터 작성 페이지에서 목록 페이지로 넘어올 때 코어 데이터의 내용을 전부 읽어서 테이블 리스트를 보여주려니 코어데이터로 접근하는 시점 문제가 생겼습니다. 데이터 저장 완료되지 않는 상태에서 데이터를 가져와서 읽으려니 셀의 위치가 움직이고 새로 추가한 데이터가 바로 나타나지 않았습니다.(수정한 경우는 잘 반영 되었습니다.)

* #### 시행착오
    * 시도 1: 코어데이터 접근은 최초 리스트 페이지 로딩 때만 시도하고 이후는 snapshot을 활용한다.
    * 시도 2: 데이터를 1초 후에 읽어온다.
    * 시도 3: 데이터가 다 저장되면 코어데이터에서 읽어오도록 데리게이트 패턴을 사용( `최종 수정 결과!`)

* #### 최종 리팩토링 결과
시도 1은 실패했고 시도 2로 구현했으나 불필요하게 사용자가 기다려야 하는 경우(수정의 경우 빨리 데이터가 업데이트되어서 1초를 기다릴 필요 X) UX가 나쁠 것 같아서 시도 3으로 리팩토링했습니다.

* #### (시도1) 스냅샷 적용 과정 시의 문제사항
coreData를 최초에 목록페이지를 불러올 때(viewDidLoad()에서) 한 번만 load하고 이후부터는 snapshot을 수정해서 데이터를 테이블에 반영하고 싶었습니다.

이를 해결하기 위해 데이터를 추가하면 코어데이터에서 가져오는 것이 아니라 작성 페이지에서 추가한 데이터를 바로 데이터를 넘기고 싶습니다. 추가한 데이터를 이전 화면의 스냅샷에 추가하는 것은 아래 작성한 코드로 성공했습니다.
그렇지만 수정하는 경우는 아래의 에러가 발생합니다.😢

> Invalid item identifier specified for reload: Diary.DiaryDTO(identifier: ED4AB649-9DF0-40CB-87D8-EA7210C03F9E, title: \"Koopoo\", body: \"\", date: 2022-06-27 15:00:00 +0000, icon: nil)"

```swift
protocol UpdateProtocol: UIViewController {
    func updateList(data: DiaryDTO)
    func edit(data: DiaryDTO)
}

final class UpdateViewController {
    private weak var delegate: UpdateProtocol?
    
    init(diaryData: DiaryDTO? = nil, delegate: UpdateProtocol) {
        self.diaryData = diaryData
        self.delegate = delegate
        super.init(nibName: nil, bundle: nil)
    }
    
    private func saveData() {
        ...
        
        if isSavingData == false {
            DiaryDAO.shared.save(data, isNew: isNew)
            isSavingData = true
            if isNew {
                delegate?.updateList(data: data)
            } else {
                delegate?.edit(data: data)
            }
        }
    }
}

extension DiaryViewController: UpdateProtocol {
    func updateList(data: DiaryDTO) {
        currentSnapShot.appendItems([data])
        dataSource?.apply(currentSnapShot)
    }
    
    func edit(data: DiaryDTO) {
        currentSnapShot.reloadItems([data])//특정 아이템만 수정
        dataSource?.apply(currentSnapShot)
    }
}

final class DiaryViewController: UIViewController, DiaryProtocol {
    ...
    private var currentSnapShot = NSDiffableDataSourceSnapshot<Int, DiaryDTO>()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        ...
        
        currentSnapShot.appendSections([.zero])
        
        setUpCoreData() //ViewWillAppear에서 하던 것 여기로 이동
    }
    
    ...
    
    private func setUpSnapshot(data: [DiaryDTO]) {//프로퍼티 snapshot 이용
        currentSnapShot.appendItems(data)
        dataSource?.apply(currentSnapShot)
    }
}
```

만약 일기장 추가 시에는 추가 페이지에서 데이터를 넘겨서 그 정보만 스냅샷에 반영해서 리스트를 보여주고 일기장 수정 시에는 코어데이터에서 특정 데이터만 읽어오고 스냅샷에 append 시키면, 수정 시 기존 셀이 리스트에 그대로 남아있는 문제가 생깁니다.

* #### (시도1) 스냅샷 적용 과정 시의 결론
스냅샷이 내부적으로 차이를 비교해서 변경된 사항만 알아서 교체하기 때문에 수정된 것을 반영하려면 새로운 스냅샷을 적용해야 합니다.(즉, 특정 아이템 교체만 불가능한 것 같습니다.)
따라서, 기존의 방식처럼 코어데이터에서 데이터를 직접 읽어서 새로 적용하는 것이 가장 좋은 방법인 것 같다고 생각했습니다.

* #### (시도2) 1초 딜레이
1초 후 코어데이터에서 데이터를 읽어오도록 구현했습니다.
이때의 문제점은 네트워크 환경에 따라 유동적이 반응이 어렵습니다. 데이터를 불러오는 시간이 1초 이상 되는 경우 리스트와 코어데이터의 싱크가 맞지 않습니다. 또한 1초보다 빨리 데이터를 불러 올 수 있는 경우도 늘 사용자는 1초를 기다려야 합니다.
```swift
func updataTableView(tableView: UITableView?) {
        guard let tableView = tableView else {
            return
        }
        
        tableView.refreshControl?.beginRefreshing()
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) { [weak self] in
            self?.setUpCoreData(tableView: tableView)
        }
    }
```

* #### (시도3) 델리게이트 패턴
네트워크로 데이터를 받아오면 save 메서드를 통해 코어 데이터에 저장합니다. 저장 자체는 빨리 진행되어서 저장 메서드 호출 후 UI 업데이트 메서드를 호출하도록 구현했습니다.
```swift
protocol DataSourceDelegate: AnyObject {
    func updatePage()
}

extension DiaryViewController: DataSourceDelegate {
    func updatePage() {
        dataSource.setUpCoreData(tableView: tableView)
    }
}

final class DiaryDAO {
    ...
    private func create(userData: DiaryDTO?) {
        ...
        
        WeatherAPIManager.shared.fetchData(url: EntryPoint.weatherDescription(lat: lat, lon: lon).url) { [weak self] data in
            guard let data = try? data.get(),
                  let weather: WeatherDTO = data.convert() else {
                return
            }
            
            setUpCoreData(at: userModel, textData: userData, weatherData: weather)
            self?.save()
        }
    }
    ...
    private func save() {
        guard viewContext.hasChanges else {
            return
        }
        
        do {
            try viewContext.save()
            delegate?.updatePage()
        } catch let error {
            print("Error: \(error)")
        }
    }
    ...
}
```

## 챕터별 고민 사항
### STEP1 [STEP1 바로가기](https://github.com/malrang-malrang/ios-diary/tree/STEP1)
#### 고민한것들(트러블슈팅)
- 1️⃣ **요구서와 유사하도록 네비게이션바 버튼 text의 크기와 굵기를 두껍게 할수 없을까?🤔**
- 2️⃣ **code로 테이블뷰 셀을 만들 때 어떤 이니셜라이져를 사용해야 할까?🤔**
- 3️⃣ **일기장 추가 시 화면 전환 방식: push vs modal**
- 4️⃣ **init vs loadView vs ViewDidLoad**
- 5️⃣ **범용적인 메서드**
- 6️⃣ DateFormatter
#### 질문한것들
- 1️⃣ **`UITableViewCell()` vs `tableView.dequeueReusableCell(withIdentifier: UITableViewCell.identifier, for: indexPath)`**
- 2️⃣ **싱글턴 패턴을 사용할때 class vs struct 어떤것을 사용하는것이 좋을까요?**
- 3️⃣ **ViewController들의 공통된 기능들을 중복제거 하는 방법🤔**

### STEP2 [STEP2 바로가기](https://github.com/malrang-malrang/ios-diary/tree/STEP2)
#### 고민한것들(트러블슈팅)
- 1️⃣ **UI를 구현하기위한 sample데이터 관련 로직의 위치**
- 2️⃣ **Keyboard타입과 KeyBoard를사용하는 주체 를 주입받는 방법** 
- 3️⃣ **SceneDelegate에서 BackGround로 진입할 때 데이터를 저장하는 방법(Notification vs 델리게이트)**
- 4️⃣ **textView text에서 title 이랑 body 나누기**
- 5️⃣ **tableview 레이아웃 에러**
- 6️⃣ **코드 컨벤션**
- 7️⃣ **빌더 패턴을 적용한 alert**
- 8️⃣ **범용적으로 사용할수있어야할까? vs 중복코드를 줄여야할까? 🫠**
- 9️⃣ **@objc 메서드**
- 🔟 **tableView Cell의 swipe 액션에러**
#### 질문한것들
- 1️⃣ **파일 그룹화하는 방식**
- 2️⃣ **삼항 연산자, nil 병합 연산자의 성능**
- 3️⃣ **코어데이터 에러 처리**
- 4️⃣ **메서드 역할 분리**

### STEP3 [STEP3 바로가기](https://github.com/malrang-malrang/ios-diary/tree/STEP3)
#### 고민한것들(트러블슈팅)
- 1️⃣ **MVC 아키텍처에 맞게 역할 분리**
- 2️⃣ **iOS App 특정 HTTP 접근 허용방법**
#### 질문한것들
- 1️⃣ **새로 작성된 데이터와 수정된 데이터를 리스트에서 어떻게 보여줄까🤔**
- 2️⃣ **기능 요구서의 마이그레이션🤔** 
- 3️⃣ 전처리 구문을 이용한 테스트 코드 표현하는 방법
