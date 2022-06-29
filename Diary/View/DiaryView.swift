//
//  DiaryView.swift
//  Diary
//
//  Created by 두기, marisol on 2022/06/15.
//

import UIKit

final class DiaryView: UIView {
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureView()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    lazy var diaryTextView: UITextView = {
        let textView = UITextView()
        textView.translatesAutoresizingMaskIntoConstraints = false
        return textView
    }()
    
    private func configureView() {
        self.addSubview(diaryTextView)
        self.backgroundColor = .white
        
        NSLayoutConstraint.activate([
            diaryTextView.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor),
            diaryTextView.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor),
            diaryTextView.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor),
            diaryTextView.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor)
        ])
        addKeyboardObserver()
        addHideButtonOnKeyboard()
    }
    
    func configureContents(diary: Diary) {
        diaryTextView.text = diary.text
        diaryTextView.contentOffset = CGPoint(x: 0, y: 0)
    }
}

// MARK: - about keyboard
extension DiaryView {
    @objc private func keyboardWillShow(_ notification: Notification) {
        guard let userInfo = notification.userInfo,
              let keyboardFrame = userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect else {
            return
        }
        
        let contentInset = UIEdgeInsets(top: 0.0, left: 0.0, bottom: keyboardFrame.height, right: 0.0)
        diaryTextView.contentInset = contentInset
        diaryTextView.scrollIndicatorInsets = contentInset
    }
    
    @objc private func keyboardWillHide() {
        let contentInset = UIEdgeInsets.zero
        diaryTextView.contentInset = contentInset
        diaryTextView.scrollIndicatorInsets = contentInset
    }
    
    private func addKeyboardObserver() {
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(keyboardWillShow),
                                               name: UIResponder.keyboardWillShowNotification,
                                               object: nil)
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(keyboardWillHide),
                                               name: UIResponder.keyboardWillHideNotification,
                                               object: nil)
    }
    
    private func addHideButtonOnKeyboard() {
        let barButton = UIBarButtonItem(image: UIImage(systemName: "keyboard.chevron.compact.down"),
                                        style: .plain,
                                        target: self,
                                        action: #selector(hideKeyboard))
        
        barButton.tintColor = .darkGray
        
        let emptySpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        
        let toolBar = UIToolbar(frame: CGRect(x: 0, y: 0, width: 40, height: 0))
        
        toolBar.sizeToFit()
        toolBar.barStyle = .default
        toolBar.setItems([emptySpace, barButton], animated: false)
        
        diaryTextView.inputAccessoryView = toolBar
    }
    
    @objc private func hideKeyboard() {
        self.diaryTextView.endEditing(true)
    }    
}
