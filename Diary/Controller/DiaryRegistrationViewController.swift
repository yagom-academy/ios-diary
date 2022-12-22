//
//  DiaryRegistrationViewController.swift
//  Diary
//
//  Created by Mangdi, junho on 2022/12/22.
//

import UIKit

final class DiaryRegistrationViewController: UIViewController {
    private var keyboardConstraints: NSLayoutConstraint?
    private let spacing = CGFloat(8)
    private let titleTextField: UITextField = {
        let textField = UITextField()
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.font = UIFont.preferredFont(forTextStyle: .title3)
        textField.adjustsFontForContentSizeCategory = true
        textField.placeholder = "title"
        return textField
    }()
    private let bodyTextView: UITextView = {
        let textView = UITextView()
        textView.translatesAutoresizingMaskIntoConstraints = false
        textView.font = UIFont.preferredFont(forTextStyle: .body)
        textView.adjustsFontForContentSizeCategory = true
        textView.text = "body"
        textView.textContainer.lineFragmentPadding = 0
        return textView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .systemBackground
        configureNavigationItem()
        configureSubViews()
    }

    override func viewWillAppear(_ animated: Bool) {
        if #unavailable(iOS 15.0) {
            NotificationCenter.default.addObserver(self,
                                                   selector: #selector(keyboardWillShow(_:)),
                                                   name: UIResponder.keyboardWillShowNotification,
                                                   object: nil)
            NotificationCenter.default.addObserver(self,
                                                   selector: #selector(keyboardWillHide(_:)),
                                                   name: UIResponder.keyboardWillHideNotification,
                                                   object: nil)
        }
    }

    override func viewWillDisappear(_ animated: Bool) {
        if #unavailable(iOS 15.0) {
            NotificationCenter.default.removeObserver(self,
                                                      name: UIResponder.keyboardWillShowNotification,
                                                      object: nil)
            NotificationCenter.default.removeObserver(self,
                                                      name: UIResponder.keyboardWillHideNotification,
                                                      object: nil)
        }
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }

    private func configureNavigationItem() {
        let timeInterval = Date().timeIntervalSince1970
        navigationItem.title = DateFormatter.convertToCurrentLocalizedText(timeIntervalSince1970: timeInterval)
    }

    private func configureSubViews() {
        view.addSubview(titleTextField)
        view.addSubview(bodyTextView)

        NSLayoutConstraint.activate([
            titleTextField.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            titleTextField.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: spacing),
            titleTextField.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: spacing),
            bodyTextView.topAnchor.constraint(equalTo: titleTextField.bottomAnchor, constant: spacing),
            bodyTextView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: spacing),
            bodyTextView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: spacing)
        ])

        if #available(iOS 15.0, *) {
            bodyTextView.bottomAnchor.constraint(equalTo: view.keyboardLayoutGuide.topAnchor, constant: -spacing).isActive = true
        } else {
            keyboardConstraints = bodyTextView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
            keyboardConstraints?.isActive = true
        }
    }
}

extension DiaryRegistrationViewController {
    @objc private func keyboardWillShow(_ notification: NSNotification) {
        guard bodyTextView.isFirstResponder,
              let keyboardFrame: NSValue =
                notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue else {
            return
        }
        let keyboardHeight = keyboardFrame.cgRectValue.height
        keyboardConstraints?.constant = -(keyboardHeight + spacing)
    }

    @objc private func keyboardWillHide(_ notification: NSNotification) {
        keyboardConstraints?.constant = 0
    }
}
