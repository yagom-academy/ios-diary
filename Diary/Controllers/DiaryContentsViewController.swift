//
//  DiaryContentsViewController.swift
//  Diary
//
//  Created by Finnn, 수꿍 on 2022/08/16.
//

import UIKit
import CoreLocation

final class DiaryContentsViewController: UIViewController {
    
    // MARK: Properties
    
    private let diaryContentView = DiaryContentView()
    private var creationDate: Date?
    private var id: UUID?
    private var main: String?
    private var icon: String?
    private let locationManager = CLLocationManager()
    private var isDeleted: Bool = false
    private var isFetching: Bool = false
    
    var diary: Diary?
    var isEditingMemo: Bool = false
    
    // MARK: - Life Cycle
    
    override func loadView() {
        view = diaryContentView
        view.backgroundColor = .systemBackground
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureNavigationItems()
        configureUI()
        configureNotificationCenter()
        configureCreationDate()
        configureID()
        configureLocationManager()
        requestCurrentLocation()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        showKeyboard()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        
        renewCoreData()
    }
    
    // MARK: - Methods
    
    private func configureNavigationItems() {
        configureNavigationTitle()
        configureRightBarButtonItem()
    }
    
    private func configureNavigationTitle() {
        guard let diaryCreatedAt = diary?.createdAt else {
            title = Date().localizedString
            return
        }
        
        title = diaryCreatedAt.localizedString
    }
    
    private func configureRightBarButtonItem() {
        navigationItem.rightBarButtonItem = UIBarButtonItem(
            image: SystemImage.ellipsisCircle,
            style: .plain,
            target: self,
            action: #selector(sharedAndDeleteButtonTapped)
        )
    }
    
    @objc private func sharedAndDeleteButtonTapped() {
        let actionSheet = configureActionSheet()
        
        present(actionSheet, animated: true)
    }
    
    private func configureActionSheet() -> UIAlertController {
        let actionSheet = UIAlertController(
            title: nil,
            message: nil,
            preferredStyle: .actionSheet
        )
        
        actionSheet.addAction(configureShareAction())
        actionSheet.addAction(configureDeleteAction(
            title: ActionSheet.deleteActionTitle,
            completion: { [weak self] in
                self?.presentDeleteAlert()
            })
        )
        actionSheet.addAction(configureCancelAction(title: ActionSheet.cancelActionTitle))
        
        return actionSheet
    }
    
    private func configureShareAction() -> UIAlertAction {
        let shareAction = UIAlertAction(
            title: ActionSheet.shareActionTitle,
            style: .default
        ) { [weak self] _ in
            self?.presentActivityView()
        }
        
        return shareAction
    }
    
    private func presentActivityView() {
        let activityViewController = UIActivityViewController(
            activityItems: [diaryContentView.textView.text as Any],
            applicationActivities: nil
        )
        
        present(activityViewController, animated: true)
    }
    
    private func configureDeleteAction(title: String, completion: @escaping () -> Void) -> UIAlertAction {
        let deleteAction = UIAlertAction(
            title: title,
            style: .destructive
        ) { _ in
            completion()
        }
        
        return deleteAction
    }
    
    private func presentDeleteAlert() {
        let deleteAlert = configureDeleteAlert()
        
        present(deleteAlert, animated: true)
    }
    
    private func configureDeleteAlert() -> UIAlertController {
        let alert = UIAlertController(
            title: Alert.deleteAlertTitle,
            message: Alert.deleteAlertMessage,
            preferredStyle: .alert
        )
        
        alert.addAction(configureCancelAction(title: Alert.cancelActionTitle))
        alert.addAction(configureDeleteAction(
            title: Alert.deleteActionTitle,
            completion: { [weak self] in
                self?.isDeleted = true
                self?.navigationController?.popViewController(animated: true)
            })
        )
        
        return alert
    }
    
    private func configureCancelAction(title: String) -> UIAlertAction {
        let cancelAction = UIAlertAction(
            title: title,
            style: .cancel
        )
        
        return cancelAction
    }
    
    private func configureUI() {
        guard let diaryTitle = diary?.title,
              let diaryBody = diary?.body else {
            return
        }
        
        let titleAttributedString = NSMutableAttributedString(
            string: diaryTitle,
            attributes: [.font: UIFont.preferredFont(forTextStyle: .title1)]
        )
        
        let lineBreakAttributedString = NSMutableAttributedString(string: String(NewLine.lineFeed))
        let bodyAttributedString = NSMutableAttributedString(
            string: diaryBody,
            attributes: [.font: UIFont.preferredFont(forTextStyle: .body)]
        )
        
        let diaryContentText = NSMutableAttributedString()
        diaryContentText.append(titleAttributedString)
        diaryContentText.append(lineBreakAttributedString)
        diaryContentText.append(bodyAttributedString)
        diaryContentView.textView.attributedText = diaryContentText
        diaryContentView.textView.contentOffset.y = .zero
    }
    
    private func configureNotificationCenter() {
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
            selector: #selector(resignActive),
            name: UIApplication.willResignActiveNotification,
            object: nil
        )
    }
    
    @objc private func keyboardWillShow(_ notification: Notification) {
        guard let userInfo = notification.userInfo,
              let keyboardFrame = userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect else {
            return
        }
        
        let contentInset = UIEdgeInsets(
            top: 0.0,
            left: 0.0,
            bottom: keyboardFrame.size.height,
            right: 0.0
        )
        
        diaryContentView.textView.contentInset = contentInset
        diaryContentView.textView.scrollIndicatorInsets = contentInset
    }
    
    @objc private func keyboardWillHide() {
        let contentInset = UIEdgeInsets.zero
        
        diaryContentView.textView.contentInset = contentInset
        diaryContentView.textView.scrollIndicatorInsets = contentInset
        
        renewCoreData()
    }
    
    private func renewCoreData() {
        if isFetching == false {
            isFetching = true
            
            guard let (title, body) = extractTitleAndBody(),
                  let creationDate = creationDate,
                  let id = id,
                  let main = main,
                  let icon = icon else {
                isFetching = false
                return
            }
            
            do {
                try determineDataProcessingWith(
                    title,
                    body,
                    creationDate,
                    id,
                    main,
                    icon
                )
            } catch {
                presentErrorAlert(error)
            }
        }
    }
    
    private func extractTitleAndBody() -> (String, String)? {
        guard let diaryConentViewText = diaryContentView.textView.text else {
            return nil
        }
        
        let splitedText = diaryConentViewText.split(separator: NewLine.lineFeed)
        
        guard let title = splitedText.first else {
            return nil
        }
        
        guard splitedText.count > 1 else {
            return (String(title), DiaryCoreData.emptyBody)
        }
        
        let body = diaryConentViewText[splitedText[1].startIndex...]
        
        return (String(title), String(body))
    }
    
    private func determineDataProcessingWith(_ title: String, _ body: String, _ creationDate: Date, _ id: UUID, _ main: String, _ icon: String) throws {
        let fetchSuccess = try? CoreDataManager.shared.fetchDiary(using: id)
        
        switch (fetchSuccess, isDeleted) {
        case (nil, false):
            WeatherImageAPIManager(icon: icon)?.requestImage(id: id) { [weak self] result in
                switch result {
                case .success(let image):
                    do {
                        try CoreDataManager.shared.saveDiary(
                            title: title,
                            body: body,
                            createdAt: creationDate,
                            id: id,
                            main: main,
                            icon: icon,
                            image: image
                        )
                    } catch {
                        self?.presentErrorAlert(error)
                    }
                case .failure(let error):
                    self?.presentErrorAlert(error)
                }
                self?.isFetching = false
            }
        case (_, false):
            try CoreDataManager.shared.update(
                title: title,
                body: body,
                id: id
            )
            
            isFetching = false
        case (_, true):
            try CoreDataManager.shared.delete(using: id)
            
            isFetching = false
        }
    }
    
    @objc func resignActive() {
        renewCoreData()
    }
    
    private func configureCreationDate() {
        guard let diary = diary else {
            creationDate = Date()
            
            return
        }
        
        creationDate = diary.createdAt
    }
    
    private func configureID() {
        guard let diary = diary else {
            id = UUID()
            
            return
        }
        
        id = diary.id
    }
    
    private func showKeyboard() {
        if isEditingMemo == false {
            diaryContentView.textView.becomeFirstResponder()
        }
    }
    
    private func configureLocationManager() {
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
    }
    
    private func requestCurrentLocation() {
        if locationManager.authorizationStatus == .authorizedWhenInUse {
            locationManager.requestLocation()
        }
    }
}

// MARK: - CLLocationManagerDelegate

extension DiaryContentsViewController: CLLocationManagerDelegate {
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        locationManager.requestLocation()
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.first?.coordinate else {
            return
        }
        
        guard let diary = diary else {
            WeatherDataAPIManager(
                latitude: location.latitude,
                longitude: location.longitude
            )?.requestAndDecodeWeather(dataType: WeatherDataEntity.self)  { [weak self] result in
                switch result {
                case .success(let data):
                    guard let firstWeatherData = data.weather.first else {
                        return
                    }
                    self?.main = firstWeatherData.main
                    self?.icon = firstWeatherData.icon
                case .failure(let error):
                    self?.presentErrorAlert(error)
                }
            }
            
            return
        }
        
        main = diary.main
        icon = diary.icon
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        if let error = error as? CLError,
            error.code == .denied {
            presentErrorAlert(GPSError.noAuthorization)
            
            return
        }
    }
}
