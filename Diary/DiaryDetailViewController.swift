//
//  DiaryDetailViewController.swift
//  Diary
//
//  Created by bonf, bard on 2022/08/17.
//

import UIKit

class DiaryDetailViewController: UIViewController {
    // MARK: - properties
    
    private let textView = DiaryDetailTextView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        textView.delegate = self
        view.backgroundColor = .systemBackground
        view.addSubview(textView)
        setupConstraints()
        setupTextView()
        textView.setupConstraints(with: view)
        textView.layoutIfNeeded()
        addNotificationObserver()
    }
    
    private func addNotificationObserver() {
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(keyboardWillShow),
                                               name: UIResponder.keyboardWillShowNotification,
                                               object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide),
                                               name: UIResponder.keyboardWillHideNotification,
                                               object: nil)
    }
    
    func setupTextView() {
        if textView.text == "" {
            textView.text = "내용을 입력해주세요"
            textView.textColor = .lightGray
        } else {
            textView.textColor = .black
        }
    }
    
    func setupConstraints() {
        NSLayoutConstraint.activate([
            textView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            textView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            textView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            textView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor)
        ])
    }
    
    // MARK: - objc functions
    
    @objc private func keyboardWillShow(_ notification: Notification) {
        guard let userInfo = notification.userInfo,
              let keyboardFrame = userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect
        else { return }
        
        moveView(height: keyboardFrame.size.height)
    }
    
    @objc private func keyboardWillHide() {
        moveView(height: 0)
    }
}

// MARK: - extensions

extension DiaryDetailViewController: DataSendable {
    func setupData<T>(_ data: T) {
        guard let diaryInformation = data as? JSONModel else { return }
        navigationItem.title = diaryInformation.createdAt.convertToString()
        
        textView.text = diaryInformation.title + "\n\n" + diaryInformation.body
    }
}

extension DiaryDetailViewController: UITextViewDelegate {
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.text == "내용을 입력해주세요" {
            textView.text = nil
            textView.textColor = .black
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.count == 0 {
            textView.text = "내용을 입력해주세요"
            textView.textColor = .lightGray
        }
    }
}

extension DiaryDetailViewController {
    func moveView(height: CGFloat) {
        self.textView.contentInset.bottom = height
    }
}
