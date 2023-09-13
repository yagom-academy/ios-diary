//
//  UITextView+.swift
//  Diary
//
//  Created by hoon, karen on 2023/09/08.
//

import UIKit

extension UITextView {
    func addDoneButtonOnKeyboard() {
        let doneToolbar = UIToolbar(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 50))
        let flexSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let done = UIBarButtonItem(title: "Done", primaryAction: UIAction(handler: { [weak self] _ in
            self?.endEditing(true)
        }))
        let items = [flexSpace, done]
        
        doneToolbar.barStyle = .default
        doneToolbar.items = items
        doneToolbar.sizeToFit()
        inputAccessoryView = doneToolbar
    }
}
