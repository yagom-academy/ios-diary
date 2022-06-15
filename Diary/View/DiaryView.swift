//
//  DiaryView.swift
//  Diary
//
//  Created by 두기, marisol on 2022/06/15.
//

import UIKit

final class DiaryView: UIView {
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureLayout()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    private lazy var diaryTextView: UITextView = {
        let textView = UITextView()
        textView.translatesAutoresizingMaskIntoConstraints = false
        return textView
    }()
    
    private func configureLayout() {
        self.addSubview(diaryTextView)
        self.backgroundColor = .white
        NSLayoutConstraint.activate([
            diaryTextView.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor),
            diaryTextView.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor),
            diaryTextView.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor),
            diaryTextView.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor)
        ])
    }
}
