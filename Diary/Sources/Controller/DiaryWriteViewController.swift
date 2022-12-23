//
//  DiaryWriteViewController.swift
//  Diary
//
//  Copyright (c) 2022 Minii All rights reserved.

import UIKit

final class DiaryWriteViewController: UIViewController {
    let titleTextField: UITextField = {
        let titleTextField = UITextField()
        titleTextField.placeholder = "제목을 입력해주세요."
        titleTextField.font = UIFont.boldTitle1
        titleTextField.adjustsFontForContentSizeCategory = true
        
        return titleTextField
    }()
    
    let contentTextView: UITextView = {
        let textView = UITextView()
        textView.font = .preferredFont(forTextStyle: .body)
        textView.adjustsFontForContentSizeCategory = true
        textView.textContainer.lineFragmentPadding = 0
        textView.textContainerInset = .zero
        textView.showsVerticalScrollIndicator = false
        
        return textView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .systemBackground
        setNavigationBar()
        configureLayout()
        bindKeyboardObserver()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        NotificationCenter.default.removeObserver(self)
    }
}

// MARK: Business Logic
extension DiaryWriteViewController {
    private func bindKeyboardObserver() {
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(willShowKeyboard),
            name: UIResponder.keyboardWillShowNotification,
            object: nil
        )
        
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(willHideKeyboard),
            name: UIResponder.keyboardWillHideNotification,
            object: nil
        )
    }
}

// MARK: Objc Method
extension DiaryWriteViewController {
    @objc private func willShowKeyboard(notification: Notification) {
        if contentTextView.isFirstResponder,
           let userInfo = notification.userInfo,
           let keyboardFrame = userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue,
           contentTextView.textContainerInset.bottom == 0 {
            contentTextView.textContainerInset.bottom = keyboardFrame.cgRectValue.height
        }
    }
    
    @objc private func willHideKeyboard(notification: Notification) {
        contentTextView.contentInset.bottom = 0
    }
}

// MARK: UI Configuration
extension DiaryWriteViewController {
    private func addElementViews() {
        [titleTextField, contentTextView].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            view.addSubview($0)
        }
    }
    
    private func configureLayout() {
        addElementViews()
        setTitleTextFieldAnchor()
        setContentTextViewAnchor()
    }
    
    private func setTitleTextFieldAnchor() {
        let safeArea = view.safeAreaLayoutGuide
        
        titleTextField.anchor(
            top: safeArea.topAnchor,
            leading: safeArea.leadingAnchor,
            trailing: safeArea.trailingAnchor,
            paddingTop: 8,
            paddingLeading: 16,
            paddingTrailing: 16
        )
    }
    
    private func setContentTextViewAnchor() {
        let safeArea = view.safeAreaLayoutGuide
        
        contentTextView.anchor(
            top: titleTextField.bottomAnchor,
            leading: view.leadingAnchor,
            bottom: safeArea.bottomAnchor,
            trailing: view.trailingAnchor,
            paddingTop: 8
        )
    }
    
    private func setNavigationBar() {
        let currentDate = Date().convertString()
        navigationItem.setNavigationTitle(title: currentDate)
    }
}
