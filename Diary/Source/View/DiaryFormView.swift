//
//  DiaryFormView.swift
//  Diary
//  Created by inho, dragon on 2022/12/21.
//

import UIKit

final class DiaryFormView: UIView {
    private let diaryTextView: UITextView = {
        let textView = UITextView()
        textView.translatesAutoresizingMaskIntoConstraints = false
        return textView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        configureLayout()
        setUpNotification()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configureLayout() {
        translatesAutoresizingMaskIntoConstraints = false
        addSubview(diaryTextView)
        
        NSLayoutConstraint.activate([
            diaryTextView.leadingAnchor.constraint(equalTo: leadingAnchor),
            diaryTextView.topAnchor.constraint(equalTo: topAnchor),
            diaryTextView.trailingAnchor.constraint(equalTo: trailingAnchor),
            diaryTextView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }
    
    private func setUpNotification() {
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
        if let userInfo = notification.userInfo,
           let keyboardFrame = userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect {
            let contentInset = UIEdgeInsets(top: 0.0,
                                            left: 0.0,
                                            bottom: keyboardFrame.size.height,
                                            right: 0.0)
            
            diaryTextView.contentInset = contentInset
            diaryTextView.scrollIndicatorInsets = contentInset
        }
    }
    
    @objc private func keyboardWillHide(_ notification: Notification) {
        diaryTextView.contentInset = UIEdgeInsets.zero
        diaryTextView.scrollIndicatorInsets = diaryTextView.contentInset
    }
}
