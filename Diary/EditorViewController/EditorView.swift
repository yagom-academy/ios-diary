//
//  EditorView.swift
//  Diary
//
//  Created by JPush, Wonbi on 2022/12/21.
//

import UIKit

final class EditorView: UIView {
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

    func setupTextView(from text: String? = nil) {
        textView.text = text
    }
    
    func scrollToTop() {
        let contentHeight = textView.contentSize.height
        let offSet = textView.contentOffset.x
        let contentOffset = contentHeight - offSet
        textView.contentOffset = CGPoint(x: 0, y: -contentOffset)
    }
    
    private func configureView() {
        self.addSubview(textView)
        configureConstraints()
    }

    private func configureConstraints() {
        NSLayoutConstraint.activate([
            textView.topAnchor.constraint(equalTo: self.topAnchor),
            textView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            textView.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            textView.bottomAnchor.constraint(equalTo: self.bottomAnchor)
        ])
    }
}
