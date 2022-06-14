//
//  DiaryDetailView.swift
//  Diary
//
//  Created by safari, Eddy on 2022/06/14.
//

import UIKit

final class DiaryDetailView: UIView {
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
        self.addSubview(diaryTextView)
        NSLayoutConstraint.activate([
            diaryTextView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            diaryTextView.topAnchor.constraint(equalTo: self.safeAreaLayoutGuide.topAnchor),
            diaryTextView.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            diaryTextView.bottomAnchor.constraint(equalTo: self.bottomAnchor)
        ])
    }
}
