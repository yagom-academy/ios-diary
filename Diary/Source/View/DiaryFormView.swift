//
//  DiaryFormView.swift
//  Diary
//  Created by inho, dragon on 2022/12/21.
//

import UIKit

final class DiaryFormView: UIView {
    private let diaryTextView: UITextView = {
        let textView = UITextView()
        textView.translatesAutoresizingMaskIntoConstraints = false
        return textView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        configureLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configureLayout() {
        addSubview(diaryTextView)
        
        NSLayoutConstraint.activate([
            diaryTextView.leadingAnchor.constraint(equalTo: leadingAnchor),
            diaryTextView.topAnchor.constraint(equalTo: topAnchor),
            diaryTextView.trailingAnchor.constraint(equalTo: trailingAnchor),
            diaryTextView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }
}
