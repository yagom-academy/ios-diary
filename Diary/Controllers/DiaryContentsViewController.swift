//
//  DiaryContentsViewController.swift
//  Diary
//
//  Created by Finnn, 수꿍 on 2022/08/16.
//

import UIKit

final class DiaryContentsViewController: UIViewController {
    
    // MARK: - Properties
    
    private let diaryContentView = DiaryContentView()
    
    // MARK: Life Cycle
    
    override func loadView() {
        view = diaryContentView
        view.backgroundColor = .systemBackground
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        title = Date().localizedString
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
              let keyboardFrame = userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect else {
            return
        }
        
        let contentInset = UIEdgeInsets(top: 0.0,
                                        left: 0.0,
                                        bottom: keyboardFrame.size.height,
                                        right: 0.0)
        
        diaryContentView.textView.contentInset = contentInset
        diaryContentView.textView.scrollIndicatorInsets = contentInset
    }
    
    @objc private func keyboardWillHide() {
        let contentInset = UIEdgeInsets.zero
        
        diaryContentView.textView.contentInset = contentInset
        diaryContentView.textView.scrollIndicatorInsets = contentInset
    }
}
