//
//  DiaryDetailView.swift
//  Diary
//
//  Created by Kiwon Song on 2022/08/25.
//

import UIKit

class DiaryDetailView: UIView {
    private lazy var diaryTextViewBottomConstraint = diaryTextView.bottomAnchor.constraint(
        equalTo: safeAreaLayoutGuide.bottomAnchor
    )
    
    private let diaryTextView: UITextView = {
        let textView = UITextView()
        
        return textView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.configureTextField()
        self.diaryTextView.keyboardDismissMode = .onDrag
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    private func configureTextField() {
        self.addSubview(diaryTextView)
        self.diaryTextView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            self.diaryTextView.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor),
            self.diaryTextViewBottomConstraint,
            self.diaryTextView.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor),
            self.diaryTextView.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor)
        ])
    }
    
    func changeTextViewBottomAutoLayout(_ keyboardHeight: CGFloat = 0) {
        self.diaryTextViewBottomConstraint.isActive = false
        self.diaryTextViewBottomConstraint = diaryTextView.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor,
                                                                                   constant: -keyboardHeight)
        self.diaryTextViewBottomConstraint.isActive = true
    }
    
    func configure(with content: SampleDiaryContent) {
        self.diaryTextView.text = content.title + "\n"
        self.diaryTextView.text += content.body
    }
}
