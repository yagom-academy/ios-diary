//
//  TextView.swift
//  Diary
//
//  Created by 김동욱 on 2022/06/14.
//

import UIKit

final class TextView: UITextView {
    enum Const {
        static let keyboardBounds = "UIKeyboardBoundsUserInfoKey"
    }
    
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
    
    @objc private func keyboardWillAppear(notification: Notification) {
        guard let keyboardBounds = notification.userInfo?[Const.keyboardBounds] as? NSValue else {
            return
        }
        
        bottomContraint?.constant = -keyboardBounds.cgRectValue.height
    }
    
    @objc private func keyboardWillHide() {
        bottomContraint?.constant = .zero
    }
}
