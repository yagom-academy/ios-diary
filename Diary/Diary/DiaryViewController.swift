//
//  DiaryViewController.swift
//  Diary
//
//  Created by unchain, 웡빙 on 2022/08/17.
//

import UIKit
import CoreLocation

final class DiaryViewController: UIViewController {
    // MARK: - NameSpace
    
    private enum AlertMassage {
        static let shareActionTitle = "share..."
        static let deleteActionTitle = "Delete"
        static let cancel = "취소"
        static let deleteAlertTitle = "진짜요?"
        static let deleteAlertMessage = "정말로 삭제하시겠어요?"
        static let cancelActionTitle = "Cancel"
        static let newDiary = "새로운일기장"
    }
    
    // MARK: - Properties
    
    var location: [String: String] = [:]
    var icon: String?
    let locationManager = CLLocationManager()
    let diaryView = DiaryView(frame: .zero)
    var diary: Diary?
    var mode: PageMode? = .create
    
    // MARK: - ViewLifeCycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavigationBar()
        setupInitialView()
        setupKeyboard()
        setupNotification()
        setupLocationManager()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        showUpKeyboard()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        performAppropriateMode()
    }
    
    // MARK: - UI Methods
    
    private func setupNavigationBar() {
        let now = Date()
        navigationItem.title = now.timeIntervalSince1970.translateToDate()
        
        if mode == .modify {
            navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(systemName: SystemName.moreViewIcon),
                                                                style: .plain,
                                                                target: self,
                                                                action: #selector(showActionSheet))
        }
    }
    
    private func setupInitialView() {
        view.backgroundColor = .systemBackground
        view.addSubview(diaryView)
        setDiaryViewConstraint()
        diaryView.setupData(with: diary)
    }
    
    private func setDiaryViewConstraint() {
        diaryView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            diaryView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            diaryView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            diaryView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            diaryView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor)
        ])
    }
    
    private func generateAlertController(title: String?, message: String?, style: UIAlertController.Style, actions: [UIAlertAction]) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: style)
        actions.forEach { action in
            alert.addAction(action)
        }
        present(alert, animated: true)
    }
    
    private func generateShareAlertAction() -> UIAlertAction {
        let model = DiaryModel(title: "d", body: "d", createdAt: 1, weatherIcon: "")
        let share = UIAlertAction(title: AlertMassage.shareActionTitle, style: .default) { [weak self] _ in
            guard let self = self else { return }
            let diaryToShare: [MyActivityItemSource] = [MyActivityItemSource(title: model.title, text: model.body)]
            let activityViewController = UIActivityViewController(activityItems: diaryToShare, applicationActivities: nil)
            activityViewController.popoverPresentationController?.sourceView = self.diaryView
            
            self.present(activityViewController, animated: true)
        }
        return share
    }
    
    private func generateDeleteAlertAction() -> UIAlertAction {
        let delete = UIAlertAction(title: AlertMassage.deleteActionTitle, style: .destructive) { [weak self] _ in
            guard let self = self, let coreDataDiary = self.diary else { return }
            let cancel = UIAlertAction(title: AlertMassage.cancel, style: .cancel)
            let delete = UIAlertAction(title: NameSpace.delete, style: .destructive) { [weak self] _ in
                guard let self = self else { return }
                CoreDataManager.shared.delete(diary: coreDataDiary)
                self.mode = nil
                self.navigationController?.popViewController(animated: true)
            }
            self.generateAlertController(title: AlertMassage.deleteAlertTitle,
                                         message: AlertMassage.deleteAlertMessage,
                                         style: .alert,
                                         actions: [cancel, delete])
        }
        return delete
    }
    
    private func generateCancelAlertAction() -> UIAlertAction {
        return UIAlertAction(title: AlertMassage.cancelActionTitle, style: .cancel)
    }
    
    @objc private func showActionSheet() {
        let share = generateShareAlertAction()
        let delete = generateDeleteAlertAction()
        let cancel = generateCancelAlertAction()
        generateAlertController(title: nil, message: nil, style: .actionSheet, actions: [share, cancel, delete])
    }
}

// MARK: - CoreDataManager Methods

extension DiaryViewController {
    private func setupNotification() {
        NotificationCenter.default.addObserver(self, selector: #selector(updateDiary), name: .update, object: nil)
    }
    
    private func performAppropriateMode() {
        switch mode {
        case .create:
            createDiary()
        case .modify:
            modifyDiary()
        case .none:
            return
        }
    }
    
    private func createDiary() {
        guard diaryView.diaryTextView.text.isEmpty == false else { return }
        NetworkManager.shared.requestWeatherData(latitude: location["lat"], longitude: location["lon"]) { [self] data in
            DispatchQueue.main.async { [weak self] in
                guard let diaryModel = self?.makeDiaryModel(with: data.weather[0].icon) else { return }
                CoreDataManager.shared.create(with: diaryModel)
            }
        }
    }
    
    private func modifyDiary() {
        guard let coreDataDiary = diary else { return }
        if diaryView.diaryTextView.text.isEmpty || diaryView.diaryTextView.text == NameSpace.placeHolder {
            CoreDataManager.shared.delete(diary: coreDataDiary)
        } else {
            updateDiary()
        }
    }
    
    private func makeDiaryModel(with icon: String) -> DiaryModel {
        let distinguishedTitleAndBody = diaryView.diaryTextView.text.components(separatedBy: NameSpace.twiceLineChange)
        let createdAt = Date().timeIntervalSince1970
        let filteredList = distinguishedTitleAndBody.filter { return $0 != NameSpace.whiteSpace && $0 != NameSpace.lineChange }
        guard filteredList.isEmpty == false else {
            let title = AlertMassage.newDiary
            let body = NameSpace.whiteSpace
            return DiaryModel(title: String(title), body: String(body), createdAt: createdAt, weatherIcon: icon)
        }
        
        let title = distinguishedTitleAndBody[0] == NameSpace.whiteSpace ? " " : distinguishedTitleAndBody[0]
        let body = distinguishedTitleAndBody.count == 1 ? NameSpace.whiteSpace : distinguishedTitleAndBody[1...distinguishedTitleAndBody.count-1].joined(separator: NameSpace.twiceLineChange)
        return DiaryModel(title: String(title), body: String(body), createdAt: createdAt, weatherIcon: icon)
    }
    
    @objc private func updateDiary() {
        guard let coreDataDiary = diary else { return }
        NetworkManager.shared.requestWeatherData(latitude: location["lat"], longitude: location["lon"]) { [self] data in
            DispatchQueue.main.async { [weak self] in
                guard let diaryModel = self?.makeDiaryModel(with: data.weather[0].icon) else { return }
                CoreDataManager.shared.update(diary: coreDataDiary, with: diaryModel)
            }
        }
    }
}

// MARK: - Keyboard Methods

extension DiaryViewController {
    private func setupKeyboard() {
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(keyboardWillAppear),
                                               name: UIResponder.keyboardWillShowNotification,
                                               object: nil)
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(keyboardWillDisAppear),
                                               name: UIResponder.keyboardWillHideNotification,
                                               object: nil)
        diaryView.closeButton.addTarget(self,
                                        action: #selector(hideKeyboard),
                                        for: .touchUpInside)
    }
    
    private func showUpKeyboard() {
        if mode == .create {
            diaryView.diaryTextView.becomeFirstResponder()
        }
    }
    
    @objc private func keyboardWillAppear(_ sender: Notification) {
        guard let userInfo = sender.userInfo, let keyboardFrame = userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect else { return }
        let contentInset = UIEdgeInsets(top: .zero, left: .zero, bottom: keyboardFrame.size.height, right: .zero)
        diaryView.diaryTextView.contentInset = contentInset
        diaryView.diaryTextView.scrollIndicatorInsets = contentInset
    }
    
    @objc private func keyboardWillDisAppear(_ sender: Notification) {
        let contentInset = UIEdgeInsets.zero
        diaryView.diaryTextView.contentInset = contentInset
        diaryView.diaryTextView.scrollIndicatorInsets = contentInset
    }
    
    @objc private func hideKeyboard(_ sender: Any) {
        view.endEditing(true)
        updateDiary()
    }
}

// MARK: - CLLocationManagerDelegate

extension DiaryViewController: CLLocationManagerDelegate {
    private func setupLocationManager() {
        locationManager.delegate = self
        locationManager.requestAlwaysAuthorization()
        locationManager.startUpdatingLocation()
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let coordinate = locations.last?.coordinate {
            locationManager.stopUpdatingLocation()
            location["lat"] = String(coordinate.latitude)
            location["lon"] = String(coordinate.longitude)
            print("위치확인 완료")
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error.localizedDescription)
    }
}
