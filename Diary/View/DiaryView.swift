//
//  DiaryView.swift
//  Diary
//
//  Created by 허건 on 2022/08/17.
//

import UIKit

class DiaryView: UIView {
    
    let diaryTextView: UITextView = {
        let textView = UITextView()

        return textView
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        self.configureTextField()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    private func configureTextField() {
        self.addSubview(diaryTextView)
        self.diaryTextView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            self.diaryTextView.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor),
            self.diaryTextView.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor),
            self.diaryTextView.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor),
            self.diaryTextView.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor)
        ])
    }
}
