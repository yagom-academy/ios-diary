//
//  Diary - DetailDiaryViewController.swift
//  Created by Rhode, 무리.
//  Copyright © yagom. All rights reserved.
//

import UIKit

final class DetailDiaryViewController: UIViewController {
    private var diaryDate: String?
    private var bottomConstraint: NSLayoutConstraint?
    
    private let diaryTextView: UITextView = {
        let textView = UITextView()
        textView.font = UIFont.preferredFont(forTextStyle: .body)
        textView.adjustsFontForContentSizeCategory = true
        textView.translatesAutoresizingMaskIntoConstraints = false
        textView.text = NameSpace.diaryPlaceholder
        
        return textView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        configureSubview()
        configureConstraint()
        addKeyboardNotification()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(true)
        removeKeyboardNotification()
    }
    
    private func configureUI() {
        view.backgroundColor = .white
        diaryTextView.setContentOffset(.zero, animated: true)
        let endDiaryButton = UIBarButtonItem(barButtonSystemItem: .done,
                                             target: self,
                                             action: #selector(endEditTextView))
        navigationItem.rightBarButtonItem = endDiaryButton
        
        if diaryDate == nil {
            title = Date().convertDate()
        }
    }
    
    @objc
    private func endEditTextView() {
        self.diaryTextView.endEditing(true)
    }
    
    private func configureSubview() {
        view.addSubview(diaryTextView)
    }
    
    private func configureConstraint() {
        bottomConstraint = diaryTextView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        bottomConstraint?.isActive = true
        
        NSLayoutConstraint.activate([
            diaryTextView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            diaryTextView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            diaryTextView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor)
        ])
    }
    
    func configureContent(diary: Diary) {
        diaryTextView.text = diary.title + NameSpace.doubleNewline + diary.body
        diaryTextView.contentOffset = CGPoint.zero
        diaryDate = Date(timeIntervalSince1970: diary.date).convertDate()
        title = diaryDate
    }
    
    private func addKeyboardNotification() {
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(keyboardWillShow),
                                               name: UIResponder.keyboardWillShowNotification,
                                               object: nil)
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(keyboardWillHide),
                                               name: UIResponder.keyboardWillHideNotification,
                                               object: nil)
    }
    
    private func removeKeyboardNotification() {
        NotificationCenter.default.removeObserver(self,
                                                  name: UIResponder.keyboardWillShowNotification,
                                                  object: nil)
        NotificationCenter.default.removeObserver(self,
                                                  name: UIResponder.keyboardWillHideNotification,
                                                  object: nil)
    }
    
    @objc
    private func keyboardWillShow(notification: NSNotification) {
        if let keyboardFrame: NSValue =
            notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue,
           let firstWindow = UIApplication.shared.windows.first {
            let keyboardRectangle = keyboardFrame.cgRectValue
            let keyboardHeight = keyboardRectangle.height
            let changedHeight = keyboardHeight - firstWindow.safeAreaInsets.bottom
            UIView.animate(withDuration: 5) {
                self.bottomConstraint?.isActive = false
                self.bottomConstraint = self.diaryTextView.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor, constant: -changedHeight)
                self.bottomConstraint?.isActive = true
            }
        }
    }
    
    @objc
    private func keyboardWillHide(notification: NSNotification) {
        UIView.animate(withDuration: 5) {
            self.bottomConstraint?.isActive = false
            self.bottomConstraint = self.diaryTextView.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor)
            self.bottomConstraint?.isActive = true
        }
    }
}
