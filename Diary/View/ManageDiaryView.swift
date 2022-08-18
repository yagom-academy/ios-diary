//
//  AddDiaryView.swift
//  Diary
//
//  Created by 백곰,주디 on 2022/08/17.
//

import UIKit

final class ManageDiaryView: UIView {
    private let bodyTextView: UITextView = {
        let textView = UITextView()
        textView.adjustsFontForContentSizeCategory = true
        textView.translatesAutoresizingMaskIntoConstraints = false
        textView.font = UIFont.preferredFont(forTextStyle: .body)
        textView.keyboardType = .default
        textView.textContainerInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        return textView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubView()
        setConstraint()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        addSubView()
        setConstraint()
    }
}

extension ManageDiaryView {
    private func addSubView() {
        self.addSubview(bodyTextView)
        self.backgroundColor = .white
    }
    
    private func setConstraint() {
        NSLayoutConstraint.activate([
            bodyTextView.leadingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.leadingAnchor),
            bodyTextView.topAnchor.constraint(equalTo: self.safeAreaLayoutGuide.topAnchor, constant: 10),
            bodyTextView.trailingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.trailingAnchor),
            bodyTextView.bottomAnchor.constraint(equalTo: self.bottomAnchor)
        ])
    }
    
    func adjustContentInset(height: CGFloat) {
        self.bodyTextView.contentInset.bottom = height
    }
}
