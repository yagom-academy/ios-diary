//
//  DiaryFormView.swift
//  Diary
//  Created by inho, dragon on 2022/12/21.
//

import UIKit

final class DiaryFormView: UIView {
    // MARK: Properties
    
    private let diaryTextView: UITextView = {
        let textView = UITextView()
        textView.translatesAutoresizingMaskIntoConstraints = false
        return textView
    }()
    var components: [String] {
        return diaryTextView.text.components(separatedBy: NameSpace.lineBreak)
    }
    var diaryTitle: String {
        return components.first ?? String()
    }
    var diaryBody: String {
        var components = components
        components.removeFirst()
        
        return components.filter { !$0.isEmpty }.first ?? String()
    }
    var diaryTotalText: String {
        return diaryTextView.text
    }
    
    // MARK: Initializer
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        configureLayout()
        setUpNotification()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: Internal Methods
    
    func assignTextViewToFirstResponder() {
        diaryTextView.becomeFirstResponder()
    }
    
    func setupTextView(with text: String) {
        diaryTextView.text = text
    }
    
    // MARK: Private Methods
    
    private func configureLayout() {
        translatesAutoresizingMaskIntoConstraints = false
        addSubview(diaryTextView)
        
        NSLayoutConstraint.activate([
            diaryTextView.leadingAnchor.constraint(equalTo: leadingAnchor),
            diaryTextView.topAnchor.constraint(equalTo: topAnchor),
            diaryTextView.trailingAnchor.constraint(equalTo: trailingAnchor),
            diaryTextView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }
    
    private func setUpNotification() {
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
        let textView = diaryTextView
        
        if let userInfo = notification.userInfo,
           let keyboardFrame = userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect {
            let contentInset = UIEdgeInsets(
                top: 0.0,
                left: 0.0,
                bottom: keyboardFrame.size.height,
                right: 0.0
            )
            
            textView.contentInset = contentInset
            textView.scrollIndicatorInsets = contentInset
        }
    }
    
    @objc private func keyboardWillHide(_ notification: Notification) {
        let textView = diaryTextView
        
        textView.contentInset = UIEdgeInsets.zero
        textView.scrollIndicatorInsets = textView.contentInset
    }
}

// MARK: - NameSpace

private enum NameSpace {
    static let lineBreak = "\n"
}
