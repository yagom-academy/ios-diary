//
//  Diary - DetailDiaryViewController.swift
//  Created by Rhode, 무리.
//  Copyright © yagom. All rights reserved.
//

import UIKit

final class DetailDiaryViewController: UIViewController {
    private let contentStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 5
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        return stackView
    }()
    
    private let titleTextView: UITextView = {
        let textView = UITextView()
        textView.font = UIFont.preferredFont(forTextStyle: .title3)
        textView.adjustsFontForContentSizeCategory = true
        textView.text = "제목을 입력하세요"

        return textView
    }()
    
    private let bodyTextView: UITextView = {
        let textView = UITextView()
        textView.font = UIFont.preferredFont(forTextStyle: .body)
        textView.adjustsFontForContentSizeCategory = true
        textView.text = "내용을 입력하세요"
        
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
        title = Date().convertDate()
    }
    
    private func configureSubview() {
        view.addSubview(contentStackView)
        contentStackView.addArrangedSubview(titleTextView)
        contentStackView.addArrangedSubview(bodyTextView)
    }
    
    private func configureConstraint() {
        NSLayoutConstraint.activate([
            contentStackView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            contentStackView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            contentStackView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            contentStackView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            titleTextView.heightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.heightAnchor, multiplier: 1/14)
        ])
    }
    
    func configureContent(diary: Diary) {
        titleTextView.text = diary.title
        bodyTextView.text = diary.body
    }
    
    private func addKeyboardNotification() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    private func removeKeyboardNotification() {
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    @objc
    private func keyboardWillShow(notification: NSNotification) {
        if let keyboardFrame: NSValue = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue {
            let keyboardRectangle = keyboardFrame.cgRectValue
            let keyboardHeight = keyboardRectangle.height
            let changedHeight = keyboardHeight - UIApplication.shared.windows.first!.safeAreaInsets.bottom
            UIView.animate(withDuration: 1) {
                NSLayoutConstraint.activate([
                    self.bodyTextView.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor, constant: -changedHeight)
                
                ])
            }
        }
    }
    
    @objc
    private func keyboardWillHide(notification: NSNotification) {
        if self.view.window?.frame.origin.y != 0 {
            if let keyboardFrame: NSValue = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue {
                let keyboardRectangle = keyboardFrame.cgRectValue
                let keyboardHeight = keyboardRectangle.height
                let changedHeight = keyboardHeight - UIApplication.shared.windows.first!.safeAreaInsets.bottom
                UIView.animate(withDuration: 1) {
                    self.view.window?.frame.origin.y += changedHeight
                }
            }
        }
    }
}
