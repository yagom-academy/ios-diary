//
//  DiaryDetailViewController.swift
//  Diary
//
//  Created by kimseongjun on 2023/04/25.
//

import UIKit

final class DiaryDetailViewController: UIViewController {
    private enum LocalizationKey {
        static let titleTextFieldPlaceHolder = "titleTextFieldPlaceHolder"
        static let bodyTextViewPlaceHolder = "bodyTextViewPlaceHolder"
    }
    
    private let diary: Diary?
    
    init(_ diary: Diary?) {
        self.diary = diary
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private lazy var scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        
        return scrollView
    }()
    
    private lazy var contentStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 20
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        return stackView
    }()
    
    private lazy var titleTextField: UITextField = {
        let textField = UITextField()
        textField.font = .preferredFont(forTextStyle: .title2)
        textField.layer.borderWidth = 0.8
        textField.layer.cornerRadius = 4
        textField.addLeftPadding()
        
        return textField
    }()
    
    private lazy var bodyTextView: UITextView = {
        let textView = UITextView()
        textView.font = .preferredFont(forTextStyle: .body)
        textView.isScrollEnabled = false
        textView.layer.borderWidth = 0.8
        textView.layer.cornerRadius = 4
        textView.textContainerInset = UIEdgeInsets(top: 8, left: 8, bottom: 8, right: 8)
        
        return textView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        configureLayout()
        configureNotification()
    }

    private func configureUI() {
        view.backgroundColor = .white
        
        if diary == nil {
            self.title = Date.nowDate
            placeholderSetting()
        } else {
            self.title = diary?.createdAt.convertFormattedDate()
            titleTextField.text = diary?.title
            bodyTextView.text = diary?.body
        }
    }

    private func configureLayout() {
        view.addSubview(scrollView)
        scrollView.addSubview(contentStackView)
        contentStackView.addArrangedSubview(titleTextField)
        contentStackView.addArrangedSubview(bodyTextView)
        
        let safeArea = view.safeAreaLayoutGuide
        
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: safeArea.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: safeArea.bottomAnchor),
            
            contentStackView.topAnchor.constraint(equalTo: scrollView.contentLayoutGuide.topAnchor, constant: 8),
            contentStackView.leadingAnchor.constraint(equalTo: scrollView.contentLayoutGuide.leadingAnchor, constant: 8),
            contentStackView.trailingAnchor.constraint(equalTo: scrollView.contentLayoutGuide.trailingAnchor, constant: -8),
            contentStackView.bottomAnchor.constraint(equalTo: scrollView.contentLayoutGuide.bottomAnchor, constant: -8),
            contentStackView.widthAnchor.constraint(equalTo: scrollView.frameLayoutGuide.widthAnchor, constant: -20)
        ])
    }
    
    private func configureNotification() {
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(keyboardWillShow),
            name: UIResponder.keyboardWillShowNotification,
            object: nil
        )
        
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(keyboardWillHide),
            name: UIResponder.keyboardWillHideNotification,
            object: nil
        )
    }
    
    @objc private func keyboardWillShow(_ notification: Notification) {
        guard let userInfo = notification.userInfo as NSDictionary?,
              var keyboardFrame = (userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue else {
            return
        }
        keyboardFrame = view.convert(keyboardFrame, from: nil)

        scrollView.contentInset.bottom = keyboardFrame.size.height
        scrollView.scrollIndicatorInsets = scrollView.contentInset
    }
    
    @objc private func keyboardWillHide(_ notification: Notification) {
        scrollView.contentInset = UIEdgeInsets.zero
        scrollView.scrollIndicatorInsets = scrollView.contentInset
    }
}

extension DiaryDetailViewController: UITextViewDelegate {
    private func placeholderSetting() {
        titleTextField.attributedPlaceholder = NSAttributedString(
            string: String.localized(key: LocalizationKey.titleTextFieldPlaceHolder),
            attributes: [NSAttributedString.Key.foregroundColor: UIColor.lightGray]
        )
        
        bodyTextView.delegate = self
        bodyTextView.text = String.localized(key: LocalizationKey.bodyTextViewPlaceHolder)
        bodyTextView.textColor = UIColor.lightGray
    }
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.textColor == UIColor.lightGray {
            textView.text = nil
            textView.textColor = UIColor.black
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.isEmpty {
            textView.text = String.localized(key: LocalizationKey.bodyTextViewPlaceHolder)
            textView.textColor = UIColor.lightGray
        }
    }
    
}
