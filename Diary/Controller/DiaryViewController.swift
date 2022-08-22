//
//  DiaryViewController.swift
//  Diary
//
//  Created by Kiwi, Brad. on 2022/08/17.
//

import UIKit

final class DiaryViewController: UIViewController {
    
    private let diaryView = DiaryView()
    
    override func loadView() {
        self.view = diaryView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .systemBackground
        self.setupNavigationbar()
        self.registerForKeyboardNotification()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        self.removeRegisterForKeyboardNotification()
    }
    
    private func setupNavigationbar() {
        let date = Date().formatted("yyyy년 MM월 dd일")
        self.navigationItem.title = date
    }
    
    private func registerForKeyboardNotification() {
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(keyBoardShow),
                                               name: UIResponder.keyboardWillShowNotification,
                                               object: nil)
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(keyBoardDownAction),
                                               name: UIResponder.keyboardWillHideNotification,
                                               object: nil)
    }
    
    private func removeRegisterForKeyboardNotification() {
        NotificationCenter.default.removeObserver(self,
                                                  name: UIResponder.keyboardWillShowNotification,
                                                  object: nil)
        NotificationCenter.default.removeObserver(self,
                                                  name: UIResponder.keyboardWillHideNotification,
                                                  object: nil)
    }
    
    @objc private func keyBoardShow(notification: NSNotification) {
        guard let userInfo: NSDictionary = notification.userInfo as? NSDictionary,
              let keyboardFrame = userInfo.value(forKey: UIResponder.keyboardFrameEndUserInfoKey) as? NSValue else {
            return
        }
       
        let keyboardRectangle = keyboardFrame.cgRectValue
        let keyboardHeight = keyboardRectangle.height
        
        self.diaryView.changeTextViewBottomAutoLayout(keyboardHeight)
    }
    
    @objc private func keyBoardDownAction(_ sender: Notification) {
        self.diaryView.changeTextViewBottomAutoLayout()
    }
}
