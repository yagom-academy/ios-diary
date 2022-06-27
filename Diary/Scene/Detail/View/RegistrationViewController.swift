//
//  RegistrationViewController.swift
//  Diary
//
//  Created by mmim, grumpy, mino on 2022/06/17.
//

import UIKit
import CoreLocation

final class RegistrationViewController: UIViewController {
    private lazy var detailView = DetailView(frame: view.bounds)
    private let viewModel = RegistrationViewModel()
    
    override func loadView() {
        super.loadView()
        view = detailView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        registerNotification()
        setUpNavigationBar()
        setUpView()
        setUpLocationManager()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        removeKeyboardNotification()
        viewModel.saveDiary(text: detailView.contentTextView.text)
        viewModel.locationManager.stopUpdatingLocation()
    }
}

extension RegistrationViewController: UITextViewDelegate {
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        let headerAttributes = [
            NSAttributedString.Key.font: UIFont.preferredFont(forTextStyle: UIFont.TextStyle.title2)
        ]
        let bodyAttributes = [
            NSAttributedString.Key.font: UIFont.preferredFont(forTextStyle: UIFont.TextStyle.body)
        ]
        
        let textAsNSString = textView.text as NSString
        let replaced = textAsNSString.replacingCharacters(in: range, with: text) as NSString
        let boldRange = replaced.range(of: "\n")
        if boldRange.location <= range.location {
            textView.typingAttributes = bodyAttributes
        } else {
            textView.typingAttributes = headerAttributes
        }
        
        return true
    }
}

// MARK: SetUp
extension RegistrationViewController {
    private func registerNotification() {
        let notificationCenter = NotificationCenter.default
        
        notificationCenter.addObserver(
            self,
            selector: #selector(keyboardWillShow),
            name: UIResponder.keyboardWillShowNotification,
            object: nil
        )
        
        notificationCenter.addObserver(
            self,
            selector: #selector(keyboardWillHide),
            name: UIResponder.keyboardWillHideNotification,
            object: nil
        )
        
        notificationCenter.addObserver(
            self,
            selector: #selector(didEnterBackground),
            name: UIApplication.didEnterBackgroundNotification,
            object: nil
        )
    }
    
    private func removeKeyboardNotification() {
        let notificationCenter = NotificationCenter.default
        notificationCenter.removeObserver(
            self,
            name: UIResponder.keyboardWillHideNotification,
            object: nil
        )
    }
    
    private func setUpNavigationBar() {
        title = viewModel.createdAt.formattedString
    }
    
    private func setUpView() {
        detailView.scrollTextViewToTop()
        detailView.contentTextView.delegate = self
    }
    
    func setUpLocationManager() {
        viewModel.locationManager.delegate = self
    }
}

// MARK: Objc Method
extension RegistrationViewController {
    @objc private func didEnterBackground() {
        viewModel.saveDiary(text: detailView.contentTextView.text)
    }
    
    @objc private func keyboardWillShow(notification: NSNotification) {
        guard let userInfo = notification.userInfo else {
            return
        }
        let keyboardInfo = userInfo[UIResponder.keyboardFrameEndUserInfoKey]
        if let keyboardSize = (keyboardInfo as? NSValue)?.cgRectValue {
            detailView.adjustConstraint(by: keyboardSize.height)
        }
    }
    
    @objc private func keyboardWillHide(notification: NSNotification) {
        detailView.adjustConstraint(by: .zero)
        viewModel.saveDiary(text: detailView.contentTextView.text)
    }
}

extension RegistrationViewController: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let coordinate = locations.last?.coordinate {
            viewModel.setUpLocation(by: coordinate)
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        switch status {
        case .authorizedAlways, .authorizedWhenInUse:
            viewModel.locationManager.startUpdatingLocation()
        case .restricted, .notDetermined:
            viewModel.locationManager.requestWhenInUseAuthorization()
        case .denied:
            showAlert(title: "위치 권한 설정", message: "해당 기능을 사용하기 위해서 위치 권한이 필요합니다.") {
                self.showSettingUrl()
            }
        @unknown default:
            return
        }
    }
}

extension RegistrationViewController {
    private func showSettingUrl() {
        guard let settingsUrl = URL(string: UIApplication.openSettingsURLString) else {
            return
        }
        UIApplication.shared.open(settingsUrl)
    }
}

fileprivate extension Date {
    var formattedString: String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .long
        dateFormatter.locale = Locale(identifier: Locale.preferredLanguages.first ?? AppConstants.systemDefaultLanguage)
        return dateFormatter.string(from: self)
    }
}
