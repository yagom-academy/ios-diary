//
//  DiaryRegisterViewController.swift
//  Diary
//
//  Created by 재재, 그루트 on 2022/08/18.
//

import UIKit
import CoreLocation

final class DiaryRegisterViewController: DataTaskViewController {
    // MARK: - properties
    
    private let diaryRegisterView = DiaryRegisterView()
    private var locationManager = CLLocationManager()
    private var latitude: Double?
    private var longtitude: Double?
    
    // MARK: - view life cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        
        configureView()
        configureViewLayout()
        configureKeyboardNotification()
        diaryRegisterView.showKeyBoard()
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        
        if CLLocationManager.locationServicesEnabled() {
            locationManager.requestLocation()
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        saveData()
        removeRegisterForKeyboardNotification()
    }

    // MARK: - methods
    
    func saveData() {
        let inputText = diaryRegisterView.seperateText()
        saveDiaryData(title: inputText.title,
                      body: inputText.body,
                      createdAt: Double(Date().timeIntervalSince1970),
                      isExist: false)
    }
    
    @objc override func keyBoardShowAction(notification: NSNotification) {
        guard let userInfo: NSDictionary = notification.userInfo as? NSDictionary,
              let keyboardFrame = userInfo.value(forKey: UIResponder.keyboardFrameEndUserInfoKey) as? NSValue
        else { return }
        
        let keyboardRectangle = keyboardFrame.cgRectValue
        let keyboardHeight = keyboardRectangle.height
        
        diaryRegisterView.configureDetailTextViewInset(inset: keyboardHeight)
    }
    
    @objc override func keyboardDownAction() {
        view.endEditing(true)
        diaryRegisterView.configureDetailTextViewInset(inset: 0)
    }
    
    private func configureView() {
        view.addSubview(diaryRegisterView)
        navigationItem.title = Double(Date().timeIntervalSince1970).convertDate()
    }
    
    private func configureViewLayout() {
        NSLayoutConstraint.activate([
            diaryRegisterView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            diaryRegisterView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            diaryRegisterView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 8),
            diaryRegisterView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -8)
        ])
    }
}

extension DiaryRegisterViewController: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.first else { return }
        
        latitude = location.coordinate.latitude
        longtitude = location.coordinate.longitude
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error)
    }
}
