//
//  AddDiaryViewController.swift
//  Diary
//
//  Created by 애종, 애쉬 on 2022/12/20.
//

import UIKit

final class AddDiaryViewController: UIViewController, AddKeyboardNotification {
    private let addDiaryView = AddDiaryView()
    
    override func loadView() {
        self.view = addDiaryView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = DateFormatter().longDate
        self.view.backgroundColor = UIColor.white
        
        self.setKeyboardObserver()
        self.initializeHideKeyBoard()
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
                                                              action: #selector(self.dismissKeyBoard))
        self.navigationController?.navigationBar.addGestureRecognizer(tap)
    }
    
    @objc private func dismissKeyBoard() {
        self.addDiaryView.endEditing(true)
    }
}
