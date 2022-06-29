//
//  UIViewController+extension.swift
//  Diary
//
//  Created by Donnie, OneTool on 2022/06/29.
//

import UIKit

extension UIViewController {
    func registerKeyboardNotifications() {
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
    }
    
    @objc private func keyboardWillShow(notification: NSNotification) {
        guard let keyboardSize = (
            notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue
        )?.cgRectValue else { return }
        DetailView().mainScrollView.contentInset.bottom = keyboardSize.height
    }
    
    @objc func keyboardWillHide(notification: NSNotification) {
        DetailView().mainScrollView.contentInset.bottom = .zero
    }
}
