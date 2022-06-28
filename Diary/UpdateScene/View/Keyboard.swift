//
//  Keyboard.swift
//  Diary
//
//  Created by 김동욱 on 2022/06/14.
//

import UIKit

final class Keyboard {
    enum Const {
        static let keyboardBounds = "UIKeyboardBoundsUserInfoKey"
    }
    
    private let bottomConstraint: NSLayoutConstraint?
    private let textView: UITextView?
    
    init(bottomContraint: NSLayoutConstraint, textView: UITextView) {
        self.textView = textView
        self.bottomConstraint = bottomContraint
        
        setUpKeyboard()
    }
    
    private func setUpKeyboard() {
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(keyboardWillAppear),
            name: UIResponder.keyboardWillShowNotification,
            object: nil
        )
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(keyboardWillHide),
            name: UIResponder.keyboardWillHideNotification,
            object: nil
        )
        
        let swipeDown =  UISwipeGestureRecognizer(target: self, action: #selector(swipeDownGesture))
        
        swipeDown.direction = .down
        textView?.addGestureRecognizer(swipeDown)
    }
    
    @objc private func keyboardWillAppear(notification: Notification) {
        guard let keyboardBounds = notification.userInfo?[Const.keyboardBounds] as? NSValue else {
            return
        }
        
        bottomConstraint?.constant = -keyboardBounds.cgRectValue.height
    }
    
    @objc private func keyboardWillHide() {
        bottomConstraint?.constant = .zero
    }
    
    @objc private func swipeDownGesture(gesture: UISwipeGestureRecognizer) {
        textView?.endEditing(true)
    }
}
