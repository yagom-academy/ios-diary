//
//  DiaryPostViewController.swift
//  Diary
//
//  Created by Hugh, Derrick on 2022/08/17.
//

import UIKit

final class DiaryPostViewController: UIViewController {
    private let diaryDescriptionTextView: UITextView = {
        let textView = UITextView()
        textView.translatesAutoresizingMaskIntoConstraints = false
        textView.font = UIFont.preferredFont(forTextStyle: .caption1)
        return textView
    }()
    
    var diaryViewModel: DiaryViewModelLogic?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupDefault()
        configureTextView()
        registerNotificationForKeyboard()
    }
    
    private func setupDefault() {
        self.view.backgroundColor = .white
        self.title = Date.currentFormattedDate
        
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "완료", style: .plain, target: self, action: #selector(didTappedDoneButton))
    }
    
    @objc private func didTappedDoneButton() {
        diaryDescriptionTextView.resignFirstResponder()
        diaryViewModel?.save(diaryDescriptionTextView.text, Date())
    }
    
    private func configureTextView() {
        self.view.addSubview(diaryDescriptionTextView)
        
        NSLayoutConstraint.activate([
            diaryDescriptionTextView.leadingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leadingAnchor),
            diaryDescriptionTextView.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor),
            diaryDescriptionTextView.trailingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.trailingAnchor),
            diaryDescriptionTextView.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor)
        ])
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
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(didEnterBackground),
            name: UIApplication.didEnterBackgroundNotification,
            object: nil)
    }
    
    @objc private func didEnterBackground() {
        diaryViewModel?.save(diaryDescriptionTextView.text, Date())
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
