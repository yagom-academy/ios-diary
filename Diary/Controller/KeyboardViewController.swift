//
//  KeyboardViewController.swift
//  Diary
//
//  Created by 김동욱 on 2022/06/14.
//

import UIKit

class KeyboardViewController: UIViewController {
    var bottomContraint: NSLayoutConstraint?
    
    func setUpKeyboardNotification() {
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(keyboardWillAppear),
                                               name: UIResponder.keyboardWillShowNotification,
                                               object: nil)
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(keyboardWillHide),
                                               name: UIResponder.keyboardWillHideNotification,
                                               object: nil)
    }
    
    @objc private func keyboardWillAppear(_ notification: Notification) {
        guard let keyboardBounds = notification.userInfo?["UIKeyboardBoundsUserInfoKey"] as? NSValue else { return }
        
        bottomContraint?.constant = -keyboardBounds.cgRectValue.height
    }
    
    @objc private func keyboardWillHide() {
        bottomContraint?.constant = .zero
    }
}
