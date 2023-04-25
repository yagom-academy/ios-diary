//
//  DiaryDetailViewController.swift
//  Diary
//
//  Created by kimseongjun on 2023/04/25.
//

import UIKit

class DiaryDetailViewController: UIViewController {
    var diary: Diary?
    
    init(_ diary: Diary?) {
        self.diary = diary
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private let scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        
        return scrollView
    }()
    
    private let contentStackView: UIStackView = {
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
        configureViewController()
        configureUIContent()
    }
    
    private func configureViewController() {
        view.backgroundColor = .white
        self.title = diary?.createdAt.convertFormattedDate()
    }
    
    private func configureUIContent() {
        guard let validDiary = diary else {
            self.title = Date.nowDate
            placeholderSetting()
            return
        }
        
        self.title = validDiary.createdAt.convertFormattedDate()
        self.titleTextField.text = validDiary.title
        self.bodyTextView.text = validDiary.body
    }
    
    private func configureUI() {
        view.addSubview(scrollView)
        scrollView.addSubview(contentStackView)
        contentStackView.addArrangedSubview(titleTextField)
        contentStackView.addArrangedSubview(bodyTextView)
    }
    
    private func configureLayout() {
        let safeArea = view.safeAreaLayoutGuide
        
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: safeArea.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: safeArea.bottomAnchor),
            
            contentStackView.topAnchor.constraint(equalTo: scrollView.contentLayoutGuide.topAnchor, constant: 10),
            contentStackView.leadingAnchor.constraint(equalTo: scrollView.contentLayoutGuide.leadingAnchor, constant: 10),
            contentStackView.trailingAnchor.constraint(equalTo: scrollView.contentLayoutGuide.trailingAnchor, constant: -10),
            contentStackView.bottomAnchor.constraint(equalTo: scrollView.contentLayoutGuide.bottomAnchor, constant: -10),
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
        var contentInset = scrollView.contentInset
        contentInset.bottom = keyboardFrame.size.height
        scrollView.contentInset = contentInset
        scrollView.scrollIndicatorInsets = scrollView.contentInset
    }
    
    @objc private func keyboardWillHide(_ notification: Notification) {
        scrollView.contentInset = UIEdgeInsets.zero
        scrollView.scrollIndicatorInsets = scrollView.contentInset
    }
}

extension DiaryDetailViewController: UITextViewDelegate {
    func placeholderSetting() {
        titleTextField.attributedPlaceholder = NSAttributedString(string: "제목을 입력해주세요",
                                                             attributes: [NSAttributedString.Key.foregroundColor : UIColor.lightGray])
        bodyTextView.delegate = self
        bodyTextView.text = "내용을 입력 해주세요."
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
            textView.text = "내용을 입력 해주세요."
            textView.textColor = UIColor.lightGray
        }
    }
    
}
