//
//  AddDiaryView.swift
//  Diary
//
//  Created by Kyo, Baem on 2022/12/20.
//

import UIKit

final class AddDiaryView: UIView {
    private enum Placeholder: String {
        case textFieldPlaceHolder = "Title을 입력해주세요."
        case textViewPlaceHolder = "Content를 입력해주세요."
        
        var sentence: String {
            return self.rawValue
        }
    }
    
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
        textfield.returnKeyType = .done
        textfield.layer.borderWidth = 1
        textfield.layer.cornerRadius = 10
        textfield.leftViewMode = .always
        textfield.leftView = UIView(frame: CGRect(x: .zero, y: .zero, width: 5, height: .zero))
        textfield.font = .preferredFont(forTextStyle: .title1)
        textfield.layer.borderColor = UIColor.systemGray5.cgColor
        textfield.placeholder = Placeholder.textFieldPlaceHolder.sentence
        return textfield
    }()
    
    private lazy var contentsTextView: UITextView = {
        let textView = UITextView()
        textView.layer.borderWidth = 1
        textView.layer.cornerRadius = 10
        textView.textColor = .lightGray
        textView.font = .preferredFont(forTextStyle: .body)
        textView.layer.borderColor = UIColor.systemGray5.cgColor
        textView.text = Placeholder.textViewPlaceHolder.sentence
        return textView
    }()
    
    func packageData() -> Result<(title: String, body: String), DataError> {
        guard let title = titleTextField.text,
              let contents = contentsTextView.text else {
            return .failure(.nonDataError)
        }
        return .success((title, contents))
    }
}

// MARK: - UITextFieldDelegate, UITextViewDelegate
extension AddDiaryView: UITextFieldDelegate, UITextViewDelegate {
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.titleTextField.resignFirstResponder()
        self.contentsTextView.resignFirstResponder()
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if titleTextField.text != "" {
            self.contentsTextView.becomeFirstResponder()
            return true
        }
        return false
    }

    func textFieldDidEndEditing(_ textField: UITextField) {
        guard let text = textField.text else { return }
        if text.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
            textField.text = nil
            textField.placeholder = Placeholder.textFieldPlaceHolder.sentence
        }
    }
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.text == Placeholder.textViewPlaceHolder.sentence {
            textView.text = nil
            textView.textColor = .black
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
            textView.text = Placeholder.textViewPlaceHolder.sentence
            textView.textColor = .lightGray
        }
    }
}

// MARK: - UIConstraints
extension AddDiaryView {
    private func setupUI() {
        [titleTextField, contentsTextView].forEach { component in
            self.addSubview(component)
            component.translatesAutoresizingMaskIntoConstraints = false
        }
    }
    
    private func setupConstraints() {
        let safeArea = self.safeAreaLayoutGuide
        NSLayoutConstraint.activate([
            titleTextField.topAnchor.constraint(
                equalTo: safeArea.topAnchor, constant: 10),
            titleTextField.leadingAnchor.constraint(
                equalTo: safeArea.leadingAnchor, constant: 10),
            titleTextField.trailingAnchor.constraint(
                equalTo: safeArea.trailingAnchor, constant: -10),
            
            contentsTextView.topAnchor.constraint(
                equalTo: titleTextField.bottomAnchor, constant: 10),
            contentsTextView.leadingAnchor.constraint(
                equalTo: safeArea.leadingAnchor, constant: 10),
            contentsTextView.trailingAnchor.constraint(
                equalTo: safeArea.trailingAnchor, constant: -10)
        ])
        
        textViewBottomConstraints = contentsTextView.bottomAnchor.constraint(
            equalTo: safeArea.bottomAnchor, constant: -10)
        textViewBottomConstraints?.isActive = true
    }
    
    private func setupTextViewBottomConstraints(constant: CGFloat) {
        textViewBottomConstraints?.isActive = false
        textViewBottomConstraints = contentsTextView.bottomAnchor.constraint(
            equalTo: self.safeAreaLayoutGuide.bottomAnchor, constant: constant)
        textViewBottomConstraints?.isActive = true
    }
}

// MARK: - KeyboardResponse Notification
extension AddDiaryView {
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
        if let keyboardFrame: NSValue = notification.userInfo?[
            UIResponder.keyboardFrameEndUserInfoKey] as? NSValue,
            contentsTextView.isFirstResponder {
            let keyboardRectangle = keyboardFrame.cgRectValue
            let keyboardHeight = keyboardRectangle.height
            self.setupTextViewBottomConstraints(constant: -(keyboardHeight + 10))
        }
    }
    
    @objc private func hideKeyboard() {
        self.setupTextViewBottomConstraints(constant: -10)
    }
}
