//
//  DiaryDetailView.swift
//  Diary
//
//  Created by Kiwi, Brad. on 2022/08/25.
//

import UIKit

final class DiaryDetailView: UIView {
    
    private lazy var diaryTextViewBottomConstraint = diaryTextView.bottomAnchor.constraint(
        equalTo: safeAreaLayoutGuide.bottomAnchor
    )
    
    let diaryTextView: UITextView = {
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
    
    func configure(with content: DiaryContent) {
        let title = content.title
        let body = content.body
        
        self.diaryTextView.attributedText = setAttributedString(with: title, and: body)
    }
 
    private func setAttributedString(with title: String, and body: String) -> NSMutableAttributedString {
        let attributedString = NSMutableAttributedString(string: title,
                                                         attributes: [NSAttributedString.Key.font: UIFont.preferredFont(forTextStyle: .title1)])
        attributedString.append(NSMutableAttributedString(string: "\n" + body,
                                                          attributes: [NSAttributedString.Key.font: UIFont.preferredFont(forTextStyle: .body)]))
        return attributedString
    }
}
