//
//  DiaryView.swift
//  Diary
//
//  Created by 애종, 애쉬 on 2022/12/27.
//

import UIKit

class DiaryView: UIView {
    let textView: UITextView = {
        let textView = UITextView()
        textView.isEditable = true
        textView.translatesAutoresizingMaskIntoConstraints = false
        textView.font = UIFont.preferredFont(forTextStyle: .body, compatibleWith: .none)
        textView.keyboardDismissMode = .interactive
        textView.alwaysBounceVertical = true
        
        return textView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.configureView()
        self.configureAutoLayout()
        self.setKeyboardObserver()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configureView() {
        self.addSubview(self.textView)
    }
    
    private func configureAutoLayout() {
        self.textView.textContainerInset = .zero
        
        NSLayoutConstraint.activate([
            self.textView.widthAnchor.constraint(equalTo: self.safeAreaLayoutGuide.widthAnchor),
            self.textView.topAnchor.constraint(equalTo: self.safeAreaLayoutGuide.topAnchor),
            self.textView.leadingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.leadingAnchor),
            self.textView.trailingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.trailingAnchor),
            self.textView.bottomAnchor.constraint(equalTo: self.safeAreaLayoutGuide.bottomAnchor)
        ])
    }
    
    func changeTextViewContentInset(for height: CGFloat) {
        self.textView.contentInset.bottom = height
    }
}

extension DiaryView: AddKeyboardNotification {
    func keyboardWillShow(notification: NSNotification) {
        guard let keyboardHeight = self.getKeyboardHeight(from: notification) else { return }
        
        self.changeTextViewContentInset(for: keyboardHeight)
    }
    
    func keyboardWillHide(notification: NSNotification) {
        guard let keyboardHeight = self.getKeyboardHeight(from: notification) else { return }
        
        self.changeTextViewContentInset(for: -keyboardHeight)
    }
}
