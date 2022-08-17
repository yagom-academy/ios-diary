//
//  DiaryContentViewController.swift
//  Diary
//
//  Created by Hugh, Derrick on 2022/08/17.
//

import UIKit

final class DiaryContentViewController: UIViewController {
    private let diaryDescriptionTextView: UITextView = {
        let textView = UITextView()
        textView.translatesAutoresizingMaskIntoConstraints = false
        textView.font = UIFont.preferredFont(forTextStyle: .caption1)
        return textView
    }()
    
    var diaryContent: DiaryContent?
    private var diaryViewModel: DiaryViewModel?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupDefault()
        registerNotificationForKeyboard()
        configureTextView()
    }
    
    private func setupDefault() {
        self.view.backgroundColor = .white
        self.view.addSubview(diaryDescriptionTextView)
        
        guard let diaryContent = diaryContent else {
            return
        }
        
        diaryViewModel = DiaryViewModel(data: diaryContent)
        self.title = diaryViewModel?.dateText
        diaryDescriptionTextView.text = diaryViewModel?.longDescriptionText
    }
    
    private func configureTextView() {
        NSLayoutConstraint.activate([
            diaryDescriptionTextView.leadingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leadingAnchor),
            diaryDescriptionTextView.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor),
            diaryDescriptionTextView.trailingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.trailingAnchor),
            diaryDescriptionTextView.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor)
        ])
        
        diaryDescriptionTextView.focusTop()
    }
    
    private func registerNotificationForKeyboard() {
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(keyboardWillShow),
            name: UIResponder.keyboardWillShowNotification,
            object: nil)
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(keyboardWillHide),
            name: UIResponder.keyboardWillHideNotification,
            object: nil)
    }
    
    @objc private func keyboardWillShow(_ notification: Notification) {
        guard let userInfo = notification.userInfo,
              let keyboardFrame = userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect else {
            return
        }
        
        let contentInset = UIEdgeInsets(
            top: 0.0,
            left: 0.0,
            bottom: keyboardFrame.size.height,
            right: 0.0)
        
        diaryDescriptionTextView.contentInset = contentInset
        diaryDescriptionTextView.scrollIndicatorInsets = contentInset
    }
    
    @objc private func keyboardWillHide() {
        let contentInset = UIEdgeInsets.zero
        diaryDescriptionTextView.contentInset = contentInset
        diaryDescriptionTextView.scrollIndicatorInsets = contentInset
    }
}
