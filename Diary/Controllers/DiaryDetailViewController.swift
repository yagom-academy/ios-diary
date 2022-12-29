//
//  DiaryDetailViewController.swift
//  Diary
//
//  Created by Mangdi, junho on 2022/12/22.
//

import UIKit

final class DiaryDetailViewController: UIViewController {
    private var keyboardConstraints: NSLayoutConstraint?
    private let spacing = CGFloat(8)
    private let titleTextField: UITextField = {
        let textField = UITextField()
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.font = UIFont.preferredFont(forTextStyle: .title3)
        textField.adjustsFontForContentSizeCategory = true
        textField.placeholder = NSLocalizedString("Title", comment: "title placeholder")
        return textField
    }()
    private let bodyTextView: UITextView = {
        let textView = UITextView()
        textView.translatesAutoresizingMaskIntoConstraints = false
        textView.font = UIFont.preferredFont(forTextStyle: .body)
        textView.adjustsFontForContentSizeCategory = true
        textView.textContainer.lineFragmentPadding = 0
        return textView
    }()
    private var diary: Diary

    init(diary: Diary) {
        self.diary = diary
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .systemBackground
        configureNavigationItem()
        configureSubViews()
        configureDiaryText()
    }

    override func viewWillAppear(_ animated: Bool) {
        if #unavailable(iOS 15.0) {
            addKeyboardObserver()
        }
    }

    override func viewWillDisappear(_ animated: Bool) {
        if #unavailable(iOS 15.0) {
            removeKeyboardObserver()
        }
    }

    private func configureNavigationItem() {
        navigationItem.title = diary.createdAt.currentLocalizedText()
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

    private func configureDiaryText() {
        titleTextField.text = diary.title
        bodyTextView.text = diary.body
    }
}

// MARK: - Keyboard
extension DiaryDetailViewController {
    private func addKeyboardObserver() {
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(keyboardWillShow(_:)),
                                               name: UIResponder.keyboardWillShowNotification,
                                               object: nil)
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(keyboardWillHide(_:)),
                                               name: UIResponder.keyboardWillHideNotification,
                                               object: nil)
    }

    private func removeKeyboardObserver() {
        NotificationCenter.default.removeObserver(self,
                                                  name: UIResponder.keyboardWillShowNotification,
                                                  object: nil)
        NotificationCenter.default.removeObserver(self,
                                                  name: UIResponder.keyboardWillHideNotification,
                                                  object: nil)
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }

    @objc private func keyboardWillShow(_ notification: NSNotification) {
        guard bodyTextView.isFirstResponder,
              let keyboardFrame = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue else {
            return
        }
        let keyboardHeight = keyboardFrame.cgRectValue.height
        keyboardConstraints?.constant = -(keyboardHeight + spacing)
    }

    @objc private func keyboardWillHide(_ notification: NSNotification) {
        keyboardConstraints?.constant = 0
    }
}
