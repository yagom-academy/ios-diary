//
//  EditDiaryViewController.swift
//  Diary
//
//  Created by 유연수 on 2022/12/27.
//

import UIKit

class EditDiaryViewController: UIViewController, AddKeyboardNotification {
    private let editDiaryView = EditDiaryView()
    
    override func loadView() {
        self.view = editDiaryView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.white
        self.setKeyboardObserver()
        self.initializeHideKeyBoard()
    }
    
    func configureView(with diaryData: DiaryModel) {
        self.navigationItem.title = diaryData.createdAt.description
        self.editDiaryView.configureView(with: diaryData)
    }
    
    func keyboardWillShow(notification: NSNotification) {
        guard let keyboardHeight = getKeyboardHeight(from: notification) else { return }
        
        self.editDiaryView.changeTextViewContentInset(for: keyboardHeight)
    }
    
    func keyboardWillHide(notification: NSNotification) {
        guard let keyboardHeight = getKeyboardHeight(from: notification) else { return }
        
        self.editDiaryView.changeTextViewContentInset(for: -keyboardHeight)
    }
    
    private func initializeHideKeyBoard() {
        let tap: UIGestureRecognizer = UITapGestureRecognizer(target: self,
                                                              action: #selector(self.dismissKeyBoard))
        self.navigationController?.navigationBar.addGestureRecognizer(tap)
    }
    
    @objc private func dismissKeyBoard() {
        self.editDiaryView.endEditing(true)
    }
}
