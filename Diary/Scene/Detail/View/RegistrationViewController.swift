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
    private lazy var viewModel = RegistrationViewModel(delegate: self)
    
    override func loadView() {
        super.loadView()
        view = detailView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        registerNotification()
        setUpNavigationBar()
        setUpView()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        removeKeyboardNotification()
        viewWillDisappearEvent()
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
    
    func textViewDidChange(_ textView: UITextView) {
        viewModel.textViewDidChange(text: textView.text)
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
    
    private func bind() {
        viewModel.error.subscribe { [weak self] errorType in
            guard let self = self else {
                return
            }
            
            self.alertController.showConfirmAlert(
                title: "오류",
                message: errorType.errorDescription,
                presentedViewController: self
            )
        }
        
        viewModel.isLocationDenied.subscribe { [weak self] _ in
            guard let self = self else {
                return
            }
            
            self.alertController.showConfirmAlert(
                title: "위치 권한 설정",
                message: "해당 기능을 사용하기 위해서 위치 권한이 필요합니다.",
                presentedViewController: self
            ) {
                self.showSettingUrl()
            }
        }
    }
}

// MARK: Objc Method
extension RegistrationViewController {
    @objc private func didEnterBackground() {
        didEnterBackgroundEvent()
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
        keyboardWillHideEvent()
    }
}

// MARK: Event Handle

extension RegistrationViewController {
    private func viewWillDisappearEvent() {
        do {
            try viewModel.viewWillDisappear()
        } catch {
            alertController.showConfirmAlert(
                title: "오류",
                message: DiaryError.saveFail.errorDescription,
                presentedViewController: self
            )
        }
    }
    
    private func didEnterBackgroundEvent() {
        do {
            try viewModel.didEnterBackground()
        } catch {
            alertController.showConfirmAlert(
                title: "오류",
                message: DiaryError.saveFail.errorDescription,
                presentedViewController: self
            )
        }
    }
    
    private func keyboardWillHideEvent() {
        do {
            try viewModel.keyboardWillHide()
        } catch {
            alertController.showConfirmAlert(
                title: "오류",
                message: DiaryError.saveFail.errorDescription,
                presentedViewController: self
            )
        }
    }
}

extension RegistrationViewController: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let coordinate = locations.last?.coordinate {
            viewModel.didUpdateLocations(by: coordinate)
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        switch status {
        case .authorizedAlways, .authorizedWhenInUse:
            viewModel.authorizedInUse()
        case .restricted, .notDetermined:
            viewModel.unauthorizedInUse()
        case .denied:
            alertController.showConfirmAlert(
                title: "위치 권한 설정",
                message: "해당 기능을 사용하기 위해서 위치 권한이 필요합니다.",
                presentedViewController: self
            ) {
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
