//
//  DiaryDetailView.swift
//  Diary
//
//  Created by safari, Eddy on 2022/06/14.
//

import UIKit

final class DiaryDetailView: UIView {
    private var bottomConstraint: NSLayoutConstraint?
    
    private let diaryTextView: UITextView = {
        let textView = UITextView()
        textView.translatesAutoresizingMaskIntoConstraints = false
        
        return textView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureLayout()
        configureView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(diary: Diary) {
        diaryTextView.text = "\(diary.title ?? "제목 없음") \n\n \(diary.body ?? "내용 없음")"
        diaryTextView.contentOffset = .zero
    }
    
    private func configureView() {
        self.translatesAutoresizingMaskIntoConstraints = false
    }
    
    private func configureLayout() {
        self.addSubview(diaryTextView)
        NSLayoutConstraint.activate([
            diaryTextView.leadingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.leadingAnchor),
            diaryTextView.topAnchor.constraint(equalTo: self.safeAreaLayoutGuide.topAnchor),
            diaryTextView.trailingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.trailingAnchor)
        ])
        bottomConstraint = diaryTextView.bottomAnchor.constraint(equalTo: self.safeAreaLayoutGuide.bottomAnchor)
        bottomConstraint?.isActive = true
    }
    
    func changeBottomConstraint(value: CGFloat) {
        bottomConstraint?.constant = -value
        self.layoutIfNeeded()
    }
}
