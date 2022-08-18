//
//  DiaryContentsViewController.swift
//  Diary
//
//  Created by Finnn, 수꿍 on 2022/08/16.
//

import UIKit

class DiaryContentsViewController: UIViewController {
    
    // MARK: Life Cycle
    
    override func loadView() {
        view = diaryContentView
        view.backgroundColor = .systemBackground
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        title = Date().formatToStringDate()
        configureNotificationCenter()
    }
    
    // MARK: - Methods
    
    private func configureNotificationCenter() {
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(keyboardWillShow),
                                               name: UIResponder.keyboardWillShowNotification,
                                               object: nil)
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(keyboardWillHide),
                                               name: UIResponder.keyboardWillHideNotification,
                                               object: nil)
    }
    
    @objc private func keyboardWillShow(_ notification: Notification) {
        guard let userInfo = notification.userInfo,
              let keyboardFrame = userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect,
              let view = view as? DiaryContentView else {
            return
        }
        
        let contentInset = UIEdgeInsets(top: 0.0,
                                        left: 0.0,
                                        bottom: keyboardFrame.size.height,
                                        right: 0.0)
        
        view.textView.contentInset = contentInset
        view.textView.scrollIndicatorInsets = contentInset
    }
    
    @objc private func keyboardWillHide() {
        guard let view = view as? DiaryContentView else {
            return
        }
        
        let contentInset = UIEdgeInsets.zero
        
        view.textView.contentInset = contentInset
        view.textView.scrollIndicatorInsets = contentInset
    }
}
