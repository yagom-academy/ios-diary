//
//  DiaryFormViewController.swift
//  Diary
//  Created by inho, dragon on 2022/12/21.
//

import CoreData
import CoreLocation
import UIKit

final class DiaryFormViewController: UIViewController {
    // MARK: Properties
    
    private let diaryFormView = DiaryFormView()
    private var selectedDiary: Diary?
    private var weather: Weather?
    private let locationManager = CLLocationManager()
    private var weatherManager = WeatherManager()
    
    // MARK: Initializer
    
    init(diary: Diary? = nil) {
        selectedDiary = diary
        
        if let diary = diary {
            diaryFormView.setupTextView(with: diary.totalText)
        }
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        configureDiaryViewLayout()
        configureNavigationBar()
        configureCoreLocation()
        setUpNotification()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        diaryFormView.assignTextViewToFirstResponder()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        selectSaveOrUpdate()
    }
    
    // MARK: Internal Methods
    
    func selectSaveOrUpdate() {
        let diary = createDiary()
        
        if selectedDiary != nil {
            update(diary: diary)
        } else {
            if !diary.totalText.isEmpty {
                selectedDiary = diary
                save(diary: diary)
            }
        }
    }
    
    // MARK: Private Methods
    
    private func configureDiaryViewLayout() {
        view.addSubview(diaryFormView)
        
        NSLayoutConstraint.activate([
            diaryFormView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            diaryFormView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            diaryFormView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            diaryFormView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }
    
    private func configureNavigationBar() {
        navigationItem.title = DateFormatter.koreanDateFormatter.string(from: Date())
        navigationItem.rightBarButtonItem = UIBarButtonItem(
            image: UIImage(systemName: NameSpace.rightBarButtonImage),
            style: .plain,
            target: self,
            action: #selector(showActionSheet)
        )
    }
    
    private func setUpNotification() {
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(keyboardWillHide),
            name: UIResponder.keyboardWillHideNotification,
            object: nil
        )
    }
    
    private func createDiary() -> Diary {
        var uuid = UUID()
        var title = diaryFormView.diaryTitle
        let body = diaryFormView.diaryBody
        
        if let id = selectedDiary?.id {
            uuid = id
        }
        
        if title.isEmpty {
            title = NameSpace.emptyTitle
        }
        
        let diary = Diary(
            title: title,
            body: body,
            createdAt: Int(Date().timeIntervalSince1970),
            totalText: diaryFormView.diaryTotalText,
            id: uuid,
            iconName: weather?.icon ?? ""
        )
        
        return diary
    }
    
    private func configureCoreLocation() {
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        locationManager.requestLocation()
    }
    
    private func showDeleteAlert() {
        guard let diary = selectedDiary else { return }
        
        presentDeleteAlert({
            self.delete(diary: diary)
            self.navigationController?.popViewController(animated: true)
        })
    }
    
    private func showActivityController() {
        let totalText = diaryFormView.diaryTotalText
        if !totalText.isEmpty {
            presentActivity(textToShare: totalText)
        }
    }
    
    // MARK: Action Methods
    
    @objc private func showActionSheet() {
        presentActionSheet(showActivityController, showDeleteAlert)
    }
    
    @objc private func keyboardWillHide(_ notification: Notification) {
        selectSaveOrUpdate()
    }
}

// MARK: - CoreDataProcessable

extension DiaryFormViewController: CoreDataProcessable {
    func save(diary: Diary) {
        let result = saveCoreData(diary: diary)
        
        switch result {
        case .success(_):
            break
        case .failure(let error):
            presentErrorAlert(error)
        }
    }
    
    func update(diary: Diary) {
        let result = updateCoreData(diary: diary)
        
        switch result {
        case .success(_):
            break
        case .failure(let error):
            presentErrorAlert(error)
        }
    }
    
    func delete(diary: Diary) {
        let result = deleteCoreData(diary: diary)
        
        switch result {
        case .success(_):
            break
        case .failure(let error):
            presentErrorAlert(error)
        }
    }
}

// MARK: - AlertPresentable

extension DiaryFormViewController: AlertPresentable {}

// MARK: - ActivityPresentable

extension DiaryFormViewController: ActivityPresentable {}

// MARK: - CLLocationManagerDelegate
extension DiaryFormViewController: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.last {
            locationManager.stopUpdatingLocation()
            let latitude = location.coordinate.latitude
            let longitude = location.coordinate.longitude
            
            weatherManager.fetchWeather(latitude: latitude, longitude: longitude) { weather in
                self.weather = weather
            }
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error.localizedDescription)
    }
}

// MARK: - NameSpace

private enum NameSpace {
    static let rightBarButtonImage = "ellipsis.circle"
    static let emptyTitle = "[제목없음]"
}
