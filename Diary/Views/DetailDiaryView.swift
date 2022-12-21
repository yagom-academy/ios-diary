//
//  DetailDiaryView.swift
//  Diary
//
//  Created by Kyo, Baem on 2022/12/20.
//

import UIKit

final class DetailDiaryView: UIView {
    private let textFieldPlaceHolder = "Title을 입력해주세요."
    private let textViewPlaceHolder = "Content를 입력해주세요."
    
    private var textViewBottomConstraints: NSLayoutConstraint?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = .white
        setupUI()
        setupConstraints()
        titleTextField.delegate = self
        contentsTextView.delegate = self
        setupNotification()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private lazy var titleTextField: UITextField = {
        let textfield = UITextField()
        textfield.placeholder = textFieldPlaceHolder
        textfield.layer.borderWidth = 1
        textfield.layer.cornerRadius = 10
        textfield.returnKeyType = .done
        textfield.font = .preferredFont(forTextStyle: .title1)
        textfield.layer.borderColor = UIColor.systemGray5.cgColor
        return textfield
    }()
    
    private lazy var contentsTextView: UITextView = {
        let textView = UITextView()
        textView.layer.borderWidth = 1
        textView.layer.cornerRadius = 10
        textView.textColor = .lightGray
        textView.text = textViewPlaceHolder
        textView.font = .preferredFont(forTextStyle: .body)
        textView.layer.borderColor = UIColor.systemGray5.cgColor
        return textView
    }()
}

// MARK: - UITextFieldDelegate, UITextViewDelegate
extension DetailDiaryView: UITextFieldDelegate, UITextViewDelegate {
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        titleTextField.resignFirstResponder()
        contentsTextView.resignFirstResponder()
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if titleTextField.text != "" {
            contentsTextView.becomeFirstResponder()
            return true
        }
        return false
    }

    func textFieldDidEndEditing(_ textField: UITextField) {
        guard let text = textField.text else { return }
        if text.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty{
            textField.text = nil
            textField.placeholder = textFieldPlaceHolder
        }
    }
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.text == textViewPlaceHolder {
            textView.text = nil
            textView.textColor = .black
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
            textView.text = textViewPlaceHolder
            textView.textColor = .lightGray
        }
    }
}

// MARK: - UIConstraints
extension DetailDiaryView {
    private func setupUI() {
        [titleTextField, contentsTextView].forEach { component in
            self.addSubview(component)
            component.translatesAutoresizingMaskIntoConstraints = false
        }
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            titleTextField.topAnchor.constraint(
                equalTo: self.safeAreaLayoutGuide.topAnchor, constant: 10),
            titleTextField.leadingAnchor.constraint(
                equalTo: self.safeAreaLayoutGuide.leadingAnchor, constant: 10),
            titleTextField.trailingAnchor.constraint(
                equalTo: self.safeAreaLayoutGuide.trailingAnchor, constant: -10),
            
            contentsTextView.topAnchor.constraint(
                equalTo: titleTextField.bottomAnchor, constant: 10),
            contentsTextView.leadingAnchor.constraint(
                equalTo: self.safeAreaLayoutGuide.leadingAnchor, constant: 10),
            contentsTextView.trailingAnchor.constraint(
                equalTo: self.safeAreaLayoutGuide.trailingAnchor, constant: -10),
            contentsTextView.bottomAnchor.constraint(
                equalTo: self.safeAreaLayoutGuide.bottomAnchor, constant: -10),
        ])
        
        textViewBottomConstraints = contentsTextView.bottomAnchor.constraint(
            equalTo: self.safeAreaLayoutGuide.bottomAnchor, constant: -10)
        textViewBottomConstraints?.isActive = true
    }
    
    private func setupTextViewBottomConstraints(constant: CGFloat) {
        textViewBottomConstraints?.isActive = false
        textViewBottomConstraints = contentsTextView.bottomAnchor.constraint(
            equalTo: self.safeAreaLayoutGuide.bottomAnchor, constant: constant)
        textViewBottomConstraints?.isActive = true
    }
}

//MARK: - KeyboardResponse Notification
extension DetailDiaryView {
    private func setupNotification() {
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(showKeyboard),
                                               name: UIResponder.keyboardWillShowNotification,
                                               object: nil) 

        NotificationCenter.default.addObserver(self,
                                               selector: #selector(hideKeyboard),
                                               name: UIResponder.keyboardWillHideNotification,
                                               object: nil)
    }
    
    @objc private func showKeyboard(_ notification: NSNotification) {
        if let keyboardFrame: NSValue = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue, contentsTextView.isFirstResponder {
            let keyboardRectangle = keyboardFrame.cgRectValue
            let keyboardHeight = keyboardRectangle.height
            self.setupTextViewBottomConstraints(constant: -(keyboardHeight + 10))
        }
    }
    
    @objc private func hideKeyboard() {
        self.setupTextViewBottomConstraints(constant: -10)
    }
}
