//
//  AddDiaryViewController.swift
//  Diary
//
//  Created by 애종, 애쉬 on 2022/12/20.
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

final class AddDiaryViewController: UIViewController, AddKeyboardNotification {
    private let addDiaryView = AddDiaryView()
    
    override func loadView() {
        self.view = addDiaryView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = DateFormatter().longDate
        
        setKeyboardObserver()
        initializeHideKeyBoard()
    }
    
    func keyboardWillShow(notification: NSNotification) {
        guard let keyboardHeight = getKeyboardHeight(from: notification) else { return }
        
        self.addDiaryView.changeTextViewContentInset(for: keyboardHeight)
    }
    
    func keyboardWillHide(notification: NSNotification) {
        guard let keyboardHeight = getKeyboardHeight(from: notification) else { return }
        
        self.addDiaryView.changeTextViewContentInset(for: -keyboardHeight)
    }
    
    private func initializeHideKeyBoard() {
        let tap: UIGestureRecognizer = UITapGestureRecognizer(target: self,
                                                              action: #selector(dismissKeyBoard))
        self.navigationController?.navigationBar.addGestureRecognizer(tap)
    }
    
    @objc private func dismissKeyBoard() {
        self.addDiaryView.endEditing(true)
    }
}
