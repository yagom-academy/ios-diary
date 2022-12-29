//
//  AddDiaryViewController.swift
//  Diary
//
//  Created by jin on 12/22/22.
//

import UIKit

final class AddDiaryViewController: UIViewController {
    
    enum Constant {
        static let placeholder = "내용을 입력하세요."
    }
    
    private let titleTextField: UITextField = {
        let textField = UITextField()
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.placeholder = "제목"
        textField.font = .preferredFont(forTextStyle: .body)
        return textField
    }()
    
    private let contentTextView: UITextView = {
        let textView = UITextView()
        textView.translatesAutoresizingMaskIntoConstraints = false
        textView.font = .preferredFont(forTextStyle: .body)
        return textView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        configureNavigationItem()
        configureTextView()
        configureNotificationCenter()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    private func configureNavigationItem() {
        let currentDate = DateFormatter.conversionLocalDate(date: Date(), locale: .current, dateStyle: .long)
        self.navigationItem.title = currentDate
    }
    
    private func configureUI() {
        self.view.backgroundColor = .white
        
        self.view.addSubview(titleTextField)
        self.view.addSubview(contentTextView)
        
        NSLayoutConstraint.activate([
            titleTextField.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            titleTextField.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor,
                                                    constant: 10),
            titleTextField.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor,
                                                     constant: -10),
            
            contentTextView.topAnchor.constraint(equalTo: titleTextField.bottomAnchor, constant: 15),
            contentTextView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 5),
            contentTextView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor,
                                                      constant: -10),
            contentTextView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }
    
    private func configureTextView() {
        self.contentTextView.delegate = self
        self.contentTextView.text = Constant.placeholder
        self.contentTextView.textColor = .lightGray
    }
}

// MARK: - Keyboard adjusting
extension AddDiaryViewController {
    
    private func configureNotificationCenter() {
        NotificationCenter.default.addObserver(self, selector: #selector(self.adjustForKeyboard), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.adjustForKeyboard), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    @objc func adjustForKeyboard(notification: NSNotification) {
        guard let keyboardValue = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue else { return }
        let keyboardScreenEndFrame = keyboardValue.cgRectValue
        let keyboardViewEndFrame = view.convert(keyboardScreenEndFrame, from: view.window)
        
        if notification.name == UIResponder.keyboardWillHideNotification {
            contentTextView.contentInset = .zero
        } else {
            contentTextView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: keyboardViewEndFrame.height - view.safeAreaInsets.bottom, right: 0)
        }
        
        contentTextView.verticalScrollIndicatorInsets = contentTextView.contentInset

        let selectedRange = contentTextView.selectedRange
        contentTextView.scrollRangeToVisible(selectedRange)
    }
}

// MARK: - TextView Method
extension AddDiaryViewController: UITextViewDelegate {
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.text == Constant.placeholder {
            textView.text = nil
            textView.textColor = .black
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
            textView.text = Constant.placeholder
            textView.textColor = .lightGray
        }
    }
}
