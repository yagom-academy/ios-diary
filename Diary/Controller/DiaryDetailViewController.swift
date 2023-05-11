//
//  DiaryDetailViewController.swift
//  Diary
//
//  Created by rilla, songjun on 2023/04/25.
//

import UIKit
import CoreLocation

final class DiaryDetailViewController: UIViewController {
    // MARK: - Nested Type
    private enum LocalizationKey {
        static let barButtonTitle = "barButtonTitle"
        static let delete = "delete"
        static let cancel = "cancel"
        static let share = "share"
        static let more = "more"
    }
    
    enum WriteMode {
        case create
        case update
    }
    
    // MARK: - Properties
    private var locationManager: CLLocationManager!
    private let diaryService = DiaryService()
    private let dateFormatter = DiaryDateFormatter.shared
    private var writeMode = WriteMode.create
    private var longitude: Double?
    private var latitude: Double?
    private var diary: Diary?
    private var id = UUID()
    private var iconData: Data?
    private var date: String?
    private var isSave: Bool = true
    
    private let textView: UITextView = {
        let textView = UITextView()
        textView.font = .preferredFont(forTextStyle: .body)
        textView.layer.borderWidth = 0.8
        textView.layer.cornerRadius = 4
        textView.textContainerInset = UIEdgeInsets(top: 8, left: 8, bottom: 8, right: 8)
        textView.translatesAutoresizingMaskIntoConstraints = false
        
        return textView
    }()
    
    private let activityIndicator: UIActivityIndicatorView = {
        let activityIndicator = UIActivityIndicatorView()
        activityIndicator.style = UIActivityIndicatorView.Style.medium
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        return activityIndicator
    }()
    
    // MARK: - Initializer
    init(_ diary: Diary?) {
        self.diary = diary
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - State Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        locationManager = CLLocationManager()
        configureLocationManager()
        checkWriteMode()
        configureUI()
        configureLayout()
        configureNavigationBar()
        configureNotification()
        setActivityIndicator()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        let formatter = DiaryDateFormatter.shared
        
        if writeMode == .create {
            fetchWeatherIcon { resultData in
                let timeInterval = self.diary?.timeIntervalSince1970 ?? formatter.nowTimeIntervalSince1970
                self.date = formatter.convertToString(from: timeInterval)
                
                self.iconData = self.diary?.iconData ?? resultData
                
                DispatchQueue.main.async {
                    let titleView = TitleStackView()
                    titleView.configureContent(iconData: self.iconData, date: self.date)
                    
                    self.navigationItem.titleView = titleView
                    self.activityIndicator.stopAnimating()
                }
               
            }
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(true)
        saveDiaryToStorage()
    }
    
    // MARK: - Methods
    private func configureLocationManager() {
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
    }
    
    private func checkWriteMode() {
        writeMode = diary == nil ? .create : .update
    }
    
    private func configureUI() {
        view.backgroundColor = .white
        
        switch writeMode {
        case .create:
            textView.becomeFirstResponder()
        case .update:
            guard let validDiary = diary else { return }
            
            id = validDiary.id
            textView.text = validDiary.sharedText
        }
    }
    
    private func configureLayout() {
        view.addSubview(textView)
        
        let safeArea = view.safeAreaLayoutGuide
        
        NSLayoutConstraint.activate([
            textView.topAnchor.constraint(equalTo: safeArea.topAnchor, constant: 8),
            textView.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor, constant: 8),
            textView.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor, constant: -8),
            textView.bottomAnchor.constraint(equalTo: safeArea.bottomAnchor, constant: -8)
        ])
    }
    
    private func configureNavigationBar() {
        let buttonItem: UIBarButtonItem = {
            let button = UIBarButtonItem(
                title: LocalizationKey.more.localized(),
                style: .plain,
                target: self,
                action: #selector(presentActionSheet)
            )
            
            return button
        }()
        
        navigationItem.rightBarButtonItem = buttonItem
    }
    
    @objc private func presentActionSheet() {
        let shareActionSheet = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        
        let cancelAction = UIAlertAction(
            title: LocalizationKey.cancel.localized(),
            style: .cancel
        )
        
        let shareAction = UIAlertAction(
            title: LocalizationKey.share.localized(),
            style: .default
        ) { [weak self] _ in
            self?.presentActivityView(diary: self?.diary)
        }
        
        let deleteAction = UIAlertAction(
            title: LocalizationKey.delete.localized(),
            style: .destructive
        ) { [weak self] _ in
            
            self?.presentDeleteAlert(diary: self?.diary) { _ in
                self?.isSave = false
                self?.navigationController?.popViewController(animated: true)
            }
        }
        
        shareActionSheet.addAction(cancelAction)
        shareActionSheet.addAction(shareAction)
        shareActionSheet.addAction(deleteAction)
        
        present(shareActionSheet, animated: true)
    }
    
    private func configureNotification() {
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(keyboardWillShow),
            name: UIResponder.keyboardWillShowNotification,
            object: nil
        )
        
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(keyboardWillHide),
            name: UIResponder.keyboardWillHideNotification,
            object: nil
        )
        
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(didEnterBackground),
            name: UIApplication.didEnterBackgroundNotification,
            object: nil)
        
    }
    
    @objc private func keyboardWillShow(_ notification: Notification) {
        guard let userInfo = notification.userInfo as NSDictionary?,
              var keyboardFrame = (userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue else {
            return
        }
        keyboardFrame = view.convert(keyboardFrame, from: nil)
        
        textView.contentInset.bottom = keyboardFrame.size.height
        textView.scrollIndicatorInsets = textView.contentInset
    }
    
    @objc private func keyboardWillHide(_ notification: Notification) {
        textView.contentInset = UIEdgeInsets.zero
        textView.scrollIndicatorInsets = textView.contentInset
        
        saveDiaryToStorage()
    }
    
    @objc private func didEnterBackground() {
        saveDiaryToStorage()
    }
    
    private func createCurrentDiary() -> Diary? {
        guard let contents = verifyText(text: textView.text) else { return nil }
        let components = contents.split(separator: "\n", maxSplits: 1)
        
        guard let title = components.first,
              let date = self.date,
              let iconData = self.iconData else { return nil }
        
        var body = components[safe: 1] ?? ""
        if body.first == "\n" {
            body.removeFirst()
        }
        
        let currentDiary = Diary(
            id: id,
            title: String(title),
            body: String(body),
            timeIntervalSince1970: dateFormatter.convertToInterval(from: date),
            iconData: iconData
        )
        
        return currentDiary
    }
    
    private func saveDiaryToStorage() {
        guard let diary = createCurrentDiary() else { return }
        self.diary = diary
        
        if isSave {
            if CoreDataManager.shared.search(id: diary.id) == true {
                CoreDataManager.shared.update(diary)
            } else {
                CoreDataManager.shared.create(diary)
            }
        }
    }
    
    private func verifyText(text: String) -> String? {
        let trimmedText = text.trimmingCharacters(in: .whitespaces)
        
        if trimmedText.isEmpty {
            return nil
        } else {
            return trimmedText
        }
    }
    
    private func verifyResult<T, E: Error>(result: Result<T, E>) throws -> T {
        switch result {
        case.success(let data):
            return data
        case .failure(let error):
            throw error
        }
    }
    
    private func fetchWeatherIcon(completion: @escaping (Data) -> Void) {
        guard let latitude = self.latitude,
              let longitude = self.longitude else { return }
        
        diaryService.fetchWeather(lat: latitude, lon: longitude) { result in
            
            guard let data = try? self.verifyResult(result: result),
                  let weather = DecodeManager().decode(data: data, type: DailyWeather.self)  else { return }

            self.diaryService.fetchWeatherIcon(iconId: weather.information.first?.iconId) { result in
                guard let data = try? self.verifyResult(result: result) else { return }
                
                completion(data)
            }
        }
    }
    
    private func setActivityIndicator() {
        self.navigationItem.titleView = activityIndicator
        activityIndicator.startAnimating()
    }
}

extension DiaryDetailViewController: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        switch status {
        case .authorizedAlways, .authorizedWhenInUse:
            print("GPS 권한 설정됨")
            self.locationManager.startUpdatingLocation()
        case .restricted, .notDetermined:
            print("GPS 권한 설정되지 않음")
        case .denied:
            print("GPS 권한 요청 거부됨")
        default:
            print("GPS: Default")
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location: CLLocation = locations.last else { return }
        let longitude1: CLLocationDegrees = location.coordinate.longitude
        let latitude1: CLLocationDegrees = location.coordinate.latitude

        self.latitude = Double(longitude1)
        self.longitude = Double(latitude1)
        
        manager.stopUpdatingLocation()
    }
}
