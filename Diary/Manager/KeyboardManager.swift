//
//  KeyboardManager.swift
//  Diary
//
//  Created by idinaloq, yetti  on 2023/08/31.
//

import UIKit

final class KeyboardManager {
    private let textView: UITextView
    
    init(textView: UITextView) {
        self.textView = textView
        setUpKeyboardEvent()
    }
    
    private func setUpKeyboardEvent() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    @objc private func keyboardWillShow(_ notification: Notification) {
        guard let userInfo = notification.userInfo as NSDictionary?,
              var keyboardFrame = (userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue else {
            return
        }
        
        keyboardFrame = textView.convert(keyboardFrame, from: nil)
        var contentInset = textView.contentInset
        contentInset.bottom = keyboardFrame.size.height
        textView.contentInset = contentInset
        textView.verticalScrollIndicatorInsets = textView.contentInset
    }
    
    @objc private func keyboardWillHide() {
        textView.contentInset = UIEdgeInsets.zero
        textView.verticalScrollIndicatorInsets = textView.contentInset
    }
}
