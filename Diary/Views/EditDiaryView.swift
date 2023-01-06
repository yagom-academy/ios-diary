//
//  AddDiaryView.swift
//  Diary
//
//  Created by Kyo, Baem on 2022/12/20.
//

import UIKit

final class EditDiaryView: UIView {
    weak var delegate: KeyboardActionSavable?
    private var textStackViewBottomConstraints: NSLayoutConstraint?
    private let currentDiaryData: CurrentDiary?
    private var beforeCount = 0
    
    private lazy var contentsTextView: UITextView = {
        let textView = UITextView()
        textView.textColor = .label
        textView.font = .preferredFont(forTextStyle: .body)
        textView.layer.borderColor = UIColor.systemGray5.cgColor
        textView.text = Placeholder.textViewPlaceHolder.sentence
        textView.translatesAutoresizingMaskIntoConstraints = false
        return textView
    }()
    
    init(currentDiaryData: CurrentDiary?) {
        self.currentDiaryData = currentDiaryData
        super.init(frame: .zero)
        setupUI()
        bindData(currentDiaryData)
        setupConstraints()
        presentKeyboard()
        contentsTextView.delegate = self
        setupNotification()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func bindData(_ data: CurrentDiary?) {
        guard let data = data else { return }
        self.contentsTextView.text = data.contentText
        
        var seperateText = self.contentsTextView.text.components(separatedBy: "\n")
        let range = (seperateText.first! as NSString).range(of: seperateText.removeFirst())
        self.contentsTextView.attributedText = NSMutableAttributedString.customAttributeTitle(
            text: self.contentsTextView.text,
            range: range
        )
        contentsTextView.textColor = .label
    }
    
    private func presentKeyboard() {
        if currentDiaryData?.id == nil {
            contentsTextView.becomeFirstResponder()
        }
    }
    
    func packageData() -> String {
        if contentsTextView.text == Placeholder.textViewPlaceHolder.sentence {
            return ""
        }
        return contentsTextView.text
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
            textView.textColor = .label
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
            textView.text = Placeholder.textViewPlaceHolder.sentence
            textView.textColor = .systemGray
        }
        delegate?.saveWhenHideKeyboard()
    }
    
    func textViewDidChange(_ textView: UITextView) {
        guard let range = textView.selectedTextRange else { return }
        guard let position = textView.position(from: range.start, offset: 0) else { return }
        
        let seperateText = self.contentsTextView.text.components(separatedBy: "\n")
        guard let titleText = seperateText.first else { return }
        let ranges = (titleText as NSString).range(of: titleText)
        self.contentsTextView.attributedText = NSMutableAttributedString.customAttributeTitle(
            text: self.contentsTextView.text,
            range: ranges
        )
        textView.textColor = .label
        textView.selectedTextRange = textView.textRange(from: position, to: position)
    }
}

// MARK: - UIConstraints
extension EditDiaryView {
    private func setupUI() {
        self.backgroundColor = .systemBackground
        contentsTextView.layer.borderWidth = 1
        contentsTextView.layer.cornerRadius = 10
        contentsTextView.layer.borderColor = UIColor.systemGray4.cgColor
        self.addSubview(contentsTextView)
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
        
        textStackViewBottomConstraints = contentsTextView.bottomAnchor.constraint(
            equalTo: safeArea.bottomAnchor, constant: -10)
        textStackViewBottomConstraints?.isActive = true
    }
    
    private func setupTextViewBottomConstraints(constant: CGFloat) {
        textStackViewBottomConstraints?.isActive = false
        textStackViewBottomConstraints = contentsTextView.bottomAnchor.constraint(
            equalTo: self.safeAreaLayoutGuide.bottomAnchor, constant: constant)
        textStackViewBottomConstraints?.isActive = true
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
            UIResponder.keyboardFrameEndUserInfoKey] as? NSValue {
            let keyboardRectangle = keyboardFrame.cgRectValue
            let keyboardHeight = keyboardRectangle.height
            self.setupTextViewBottomConstraints(constant: -(keyboardHeight + 10))
        }
    }
    
    @objc private func hideKeyboard() {
        self.setupTextViewBottomConstraints(constant: -10)
    }
}

// MARK: - Nested Type
extension EditDiaryView {
    private enum Placeholder: String {
        case textViewPlaceHolder = "Content"
        
        var sentence: String {
            return self.rawValue
        }
    }
}
