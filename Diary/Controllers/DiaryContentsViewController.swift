//
//  DiaryContentsViewController.swift
//  Diary
//
//  Created by Toy, Morgan on 1/3/24.
//

import UIKit

final class DiaryContentsViewController: UIViewController {
    private let coreDataManager = CoreDataManager.shared
    var titleDate: String?
    var diaryTitle: String?
    var diaryBody: String?
    var diaryData: DiaryData?
    
    private let textTitle = {
        let textView = UITextView()
        textView.translatesAutoresizingMaskIntoConstraints = false
        textView.textContainerInset = UIEdgeInsets(top: 5, left: 10, bottom: 5, right: 10)
        textView.isScrollEnabled = false
        textView.font = .boldSystemFont(ofSize: 15)
        return textView
    }()
    
    private let textBody = {
        let textView = UITextView()
        textView.translatesAutoresizingMaskIntoConstraints = false
        textView.textContainerInset = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        textView.isScrollEnabled = true
        textView.font = UIFont.systemFont(ofSize: 15)
        return textView
    }()
    
    private let textStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.alignment = .fill
        stackView.distribution = .fill
        return stackView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setupData()
        setupStackView()
        setStackViewConstraints()
        setupKeyboardNotification()
    }
    
    private func setupData() {
        textTitle.text = diaryData?.title
        textBody.text = diaryData?.body
        navigationItem.title = diaryData?.date
    }
    
    private func setupStackView() {
        textStackView.addArrangedSubview(textTitle)
        textStackView.addArrangedSubview(textBody)
        view.addSubview(textStackView)
    }
    
    private func setStackViewConstraints() {
        NSLayoutConstraint.activate([
            textStackView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            textStackView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            textStackView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            textStackView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
    
    private func setupKeyboardNotification() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    @objc private func keyboardWillShow(_ notification: Notification) {
        guard let userInfo = notification.userInfo as NSDictionary?,
              let keyboardFrame = (userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue else {
            return
        }
        
        textBody.contentInset.bottom = keyboardFrame.size.height
        textBody.scrollIndicatorInsets = textBody.contentInset
    }
    
    @objc private func keyboardWillHide(_ notification: Notification) {
        textBody.contentInset = UIEdgeInsets.zero
        textBody.scrollIndicatorInsets = textBody.contentInset
    }
}
