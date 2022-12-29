//
//  EditorView.swift
//  Diary
//
//  Created by JPush, Wonbi on 2022/12/21.
//

import UIKit

final class EditorView: UIView {
    lazy var textViewBottomConstraint = self.textView.bottomAnchor.constraint(equalTo: self.bottomAnchor)
    
    private let textView: UITextView = {
        let textView = UITextView()
        textView.translatesAutoresizingMaskIntoConstraints = false
        
        return textView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureView()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configureView() {
        self.backgroundColor = .systemBackground
        self.addSubview(textView)
        
        configureConstraints()
    }

    private func configureConstraints() {
        NSLayoutConstraint.activate([
            textView.topAnchor.constraint(equalTo: self.topAnchor),
            textView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            textView.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            textViewBottomConstraint
        ])
    }
    
    func fetchDiaryData() -> String {
        return textView.text
    }
    
    func setupTextView(from text: String) {
        textView.text = text
    }
    
    func scrollToTop() {
        let contentHeight = textView.contentSize.height
        let offSet = textView.contentOffset.x
        let contentOffset = contentHeight - offSet
        textView.contentOffset = CGPoint(x: 0, y: -contentOffset)
    }
    
    func focusTextView() {
        self.textView.becomeFirstResponder()
    }
    
    private func changeBottomConstant(to constant: CGFloat) {
        self.textViewBottomConstraint.constant = constant
    }
    
    @objc func keyboardWillAppear(_ notification: NSNotification) {
        if let userInfokey = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey],
           let keyboardSize = (userInfokey as? NSValue)?.cgRectValue {
            self.changeBottomConstant(to: -keyboardSize.height)
            self.layoutIfNeeded()
        }
    }
    
    @objc func keyboardWillDisappear(_ notification: NSNotification) {
        self.changeBottomConstant(to: 0)
        self.layoutIfNeeded()
    }
}
