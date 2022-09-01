//
//  DiaryViewController.swift
//  Diary
//
//  Created by unchain, 웡빙 on 2022/08/17.
//

import UIKit
import CoreLocation

final class DiaryViewController: UIViewController {
    
    // MARK: - Properties
    
    var location: [String: String] = [:]
    let locationManager = CLLocationManager()
    let diaryView = DiaryView(frame: .zero)
    var diary: Diary?
    
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
        
        if diary != nil {
            navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(systemName: SystemName.moreViewIcon),
                                                                style: .plain,
                                                                target: self,
                                                                action: #selector(showActionSheet))
        }
    }
    
    private func setupInitialView() {
        view.backgroundColor = .systemBackground
        view.addSubview(diaryView)
        setupDiaryViewConstraint()
        diaryView.setupData(with: diary)
    }
    
    private func setupDiaryViewConstraint() {
        diaryView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            diaryView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            diaryView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            diaryView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            diaryView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor)
        ])
    }
    
    @objc private func showActionSheet() {
        let alertManager = AlertManager()
        alertManager.showActionSheet(in: self, with: diary)
    }
}

// MARK: - CoreDataManager Methods

extension DiaryViewController {
    private func setupNotification() {
        NotificationCenter.default.addObserver(self, selector: #selector(updateDiary), name: .update, object: nil)
    }
    
    private func performAppropriateMode() {
        switch diary == nil {
        case true:
            createDiary()
        case false:
            modifyDiary()
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
            return
        }
        updateDiary()
    }
    
    private func makeDiaryModel(with icon: String) -> DiaryModel {
        let titleAndBody = diaryView.diaryTextView.text.components(separatedBy: NameSpace.twiceLineChange)
        let createdAt = Date().timeIntervalSince1970
        let filteredList = titleAndBody.filter { return $0 != NameSpace.whiteSpace && $0 != NameSpace.lineChange }
        guard filteredList.isEmpty == false else {
            let title = "새로운 일기"
            let body = NameSpace.whiteSpace
            return DiaryModel(title: String(title), body: String(body), createdAt: createdAt, weatherIcon: icon)
        }
        
        let title = titleAndBody[0] == NameSpace.whiteSpace ? " " : titleAndBody[0]
        let body = titleAndBody.count == 1 ? NameSpace.whiteSpace : titleAndBody[1...titleAndBody.count-1].joined(separator: NameSpace.twiceLineChange)
        return DiaryModel(title: String(title), body: String(body), createdAt: createdAt, weatherIcon: icon)
    }
    
    @objc private func updateDiary() {
        guard let coreDataDiary = diary else { return }
        NetworkManager.shared.requestWeatherData(latitude: location["lat"], longitude: location["lon"]) { [self] data in
            DispatchQueue.main.async {
                let diaryModel = self.makeDiaryModel(with: data.weather[0].icon)
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
        if diary == nil {
            diaryView.diaryTextView.becomeFirstResponder()
        }
    }
    
    @objc private func keyboardWillAppear(_ sender: Notification) {
        guard let userInfo = sender.userInfo,
              let keyboardFrame = userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect else { return }
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
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error.localizedDescription)
    }
}
