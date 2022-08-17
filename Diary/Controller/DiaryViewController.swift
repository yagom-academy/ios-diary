//
//  DiaryViewController.swift
//  Diary
//
//  Created by Kiwon Song on 2022/08/17.
//

import UIKit

class DiaryViewController: UIViewController {
    
    let diaryView = DiaryView()
    
    override func loadView() {
        self.view = diaryView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .systemBackground
        self.setNavigationbar()
        setViewGesture()
        registerForKeyboardNotification()
    }
   
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        removeRegisterForKeyboardNotification()
    }
    
    private func setNavigationbar() {
        let date = Date().formatted("yyyy년 MM월 dd일")
        self.navigationItem.title = date
    }
    
    private func setViewGesture() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(keyboardDownAction))
        view.addGestureRecognizer(tapGesture)
    }

    @objc func keyboardDownAction(_ sender: UISwipeGestureRecognizer) {
        self.view.endEditing(true)
        diaryView.changeTextViewBottomAutoLayout()
    }
    
    private func registerForKeyboardNotification() {
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(keyBoardShow),
                                               name: UIResponder.keyboardWillShowNotification,
                                               object: nil)
     }
    
    @objc private func keyBoardShow(notification: NSNotification) {
    
        guard let userInfo: NSDictionary = notification.userInfo as? NSDictionary else {
            return
        }
        guard let keyboardFrame = userInfo.value(forKey: UIResponder.keyboardFrameEndUserInfoKey) as? NSValue else {
            return
        }
        let keyboardRectangle = keyboardFrame.cgRectValue
        let keyboardHeight = keyboardRectangle.height
    
        diaryView.changeTextViewBottomAutoLayout(keyboardHeight)
    }
    
    private func removeRegisterForKeyboardNotification() {
        NotificationCenter.default.removeObserver(self,
                                                  name: UIResponder.keyboardWillShowNotification,
                                                  object: nil)
    }
}
