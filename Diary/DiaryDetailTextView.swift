//
//  DiaryDetailTextView.swift
//  Diary
//
//  Created by bonf, bard on 2022/08/18.
//

import UIKit

class DiaryDetailTextView: UITextView {
    // MARK: - initializers

    override init(frame: CGRect, textContainer: NSTextContainer?) {
        super.init(frame: frame, textContainer: textContainer)
        commonInit()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        commonInit()
    }
    
    // MARK: - functions

    func setupConstraints(with superview: UIView) {
        let safeArea = superview.safeAreaLayoutGuide
        
        NSLayoutConstraint.activate([
            topAnchor.constraint(equalTo: safeArea.topAnchor),
            bottomAnchor.constraint(equalTo: safeArea.bottomAnchor),
            leadingAnchor.constraint(equalTo: safeArea.leadingAnchor),
            trailingAnchor.constraint(equalTo: safeArea.trailingAnchor)
        ])
    }
    
    private func commonInit() {
        translatesAutoresizingMaskIntoConstraints = false
        font = UIFont.preferredFont(forTextStyle: .body)
        scrollsToTop = true
    }
}
