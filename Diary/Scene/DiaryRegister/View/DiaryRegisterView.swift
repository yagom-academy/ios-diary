//
//  DiaryRegisterView.swift
//  Diary
//
//  Created by 재재, 그루트 on 2022/08/25.
//

import UIKit

final class DiaryRegisterView: UIView {
    // MARK: - properties
    
    private let registerTextView: UITextView = {
        let textView = UITextView()
        textView.translatesAutoresizingMaskIntoConstraints = false
        textView.font = .preferredFont(forTextStyle: .body)
        textView.keyboardDismissMode = .interactive
        textView.alwaysBounceVertical = true
        
        return textView
    }()
    
    // MARK: - initializer
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        commonInit()
    }
    
    // MARK: - methods
    
    func configureDetailTextViewInset(inset: CGFloat) {
        registerTextView.contentInset.bottom = inset
        registerTextView.verticalScrollIndicatorInsets.bottom = inset
    }
    
    func seperateText() -> (title: String, body: String) {
        let title = registerTextView.text.components(separatedBy: "\n")[0]
        let body = registerTextView.text.components(separatedBy: "\n")
            .filter { $0 != title }
            .joined(separator: "\n")
        
        return (title, body)
    }
    
    func showKeyBoard() {
        registerTextView.becomeFirstResponder()
    }
    
    private func commonInit() {
        configureView()
        configureViewLayouts()
    }
    
    private func configureView() {
        addSubview(registerTextView)
        translatesAutoresizingMaskIntoConstraints = false
    }
    
    private func configureViewLayouts() {
        NSLayoutConstraint.activate([
            registerTextView.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor),
            registerTextView.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor),
            registerTextView.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor),
            registerTextView.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor)
        ])
    }
}
