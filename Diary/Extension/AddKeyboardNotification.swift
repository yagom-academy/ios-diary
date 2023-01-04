//
//  AddKeyboardNotification.swift
//  Diary
//
//  Created by 애종, 애쉬 on 2022/12/22.
//

import UIKit

@objc protocol AddKeyboardNotification {
    @objc func keyboardWillShow(notification: NSNotification)
    @objc func keyboardWillHide(notification: NSNotification)
}

extension AddKeyboardNotification {
    func setKeyboardObserver() {
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(self.keyboardWillShow),
                                               name: UIResponder.keyboardWillShowNotification,
                                               object: nil)
        
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(self.keyboardWillHide),
                                               name: UIResponder.keyboardWillHideNotification,
                                               object: nil)
    }
    
    func getKeyboardHeight(from notification: NSNotification) -> CGFloat? {
        guard let userInfo: NSDictionary = notification.userInfo as? NSDictionary else {
            return nil
        }
        
        guard let keyboardFrame = userInfo.value(forKey: UIResponder.keyboardFrameEndUserInfoKey) as? NSValue else {
            return nil
        }
        
        let keyboardRectangle = keyboardFrame.cgRectValue
        
        return keyboardRectangle.height
    }
}
