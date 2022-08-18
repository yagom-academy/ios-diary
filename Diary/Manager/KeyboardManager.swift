//
//  KeyboardManager.swift
//  Diary
//
//  Created by bonf, bard on 2022/08/18.
//

import UIKit

class KeyboardManager {
    let textView: UITextView
    
    // MARK: - initializer
    
    init(_ textView: UITextView) {
        self.textView = textView
        setupUiToolbar()
        textView.keyboardDismissMode = .onDrag
    }
    
    // MARK: - functions
    
    func addNotificationObserver() {
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(keyboardWillShow),
                                               name: UIResponder.keyboardWillShowNotification,
                                               object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide),
                                               name: UIResponder.keyboardWillHideNotification,
                                               object: nil)
    }
    
    private func moveView(height: CGFloat) {
        textView.contentInset.bottom = height
    }
    
    private func setupUiToolbar() {
        let keyboardToolbar = UIToolbar(frame: CGRect(x: 0, y: 0, width: 0, height: 44))
        let doneBarButton = UIBarButtonItem(title: "done",
                                            style: .plain,
                                            target: self,
                                            action: #selector(endEditing))
        let flexibleSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: self, action: nil)
        
        keyboardToolbar.items = [flexibleSpace, doneBarButton]
        keyboardToolbar.sizeToFit()
        keyboardToolbar.tintColor = UIColor.systemGray
        
        textView.inputAccessoryView = keyboardToolbar
    }
    
    // MARK: - objc functions
    
    @objc func endEditing() {
        textView.resignFirstResponder()
    }
    
    @objc private func keyboardWillShow(_ notification: Notification) {
        guard let userInfo = notification.userInfo,
              let keyboardFrame = userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect
        else { return }
        
        moveView(height: keyboardFrame.size.height)
    }
    
    @objc private func keyboardWillHide() {
        moveView(height: 0)
    }
}

