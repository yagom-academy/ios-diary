//
//  AddDiaryView.swift
//  Diary
//
//  Created by Kyo, Baem on 2022/12/20.
//

import UIKit

final class EditDiaryView: UIView {
    private enum Placeholder: String {
        case textViewPlaceHolder = "Content를 입력해주세요."
        
        var sentence: String {
            return self.rawValue
        }
    }
    
    private var textViewBottomConstraints: NSLayoutConstraint?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
        setupConstraints()
        contentsTextView.delegate = self
        setupNotification()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
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
        guard let contents = contentsTextView.text else {
            return .failure(.noneDataError)
        }
        
        if contents == Placeholder.textViewPlaceHolder.sentence {
            return .failure(.noneTitleError)
        }
        
        guard let title = contents.components(separatedBy: "\n").first,
              title.trimmingCharacters(in: .whitespaces).isEmpty == false else {
            return .failure(.noneTitleError)
        }
        
        return .success((title, contents))
    }
    
    func bindData(_ data: DiaryData?) {
        guard let data = data else { return }
        contentsTextView.textColor = .black
        self.contentsTextView.text = data.body
    }
}

// MARK: - UITextViewDelegate
extension EditDiaryView: UITextViewDelegate {
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.contentsTextView.resignFirstResponder()
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
extension EditDiaryView {
    private func setupUI() {
        self.backgroundColor = .white
        self.addSubview(contentsTextView)
        contentsTextView.translatesAutoresizingMaskIntoConstraints = false
    }
    
    private func setupConstraints() {
        let safeArea = self.safeAreaLayoutGuide
        NSLayoutConstraint.activate([
            contentsTextView.topAnchor.constraint(
                equalTo: safeArea.topAnchor, constant: 10),
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
extension EditDiaryView {
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
