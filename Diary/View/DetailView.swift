//
//  DetailView.swift
//  Diary
//
//  Created by mmim, grumpy, mino on 2022/06/14.
//

import UIKit

final class DetailView: UIView {
    private var bottomConstraint: NSLayoutConstraint?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setUpView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    let contentTextView: UITextView = {
        let textView = ContentTextView()
        textView.translatesAutoresizingMaskIntoConstraints = false
        textView.font = .preferredFont(forTextStyle: .body)
        return textView
    }()
    
    private func setUpView() {
        addSubviews()
        makeConstraints()
        backgroundColor = .systemBackground
    }
    
    private func addSubviews() {
        addSubview(contentTextView)
    }
    
    private func makeConstraints() {
        let bottomConstraint = contentTextView.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor)
        
        NSLayoutConstraint.activate([
            contentTextView.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor),
            contentTextView.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor),
            contentTextView.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor),
            bottomConstraint
        ])
        
        self.bottomConstraint = bottomConstraint
    }
    
    func setUpContents(data: DiaryEntity) {
        guard let title = data.title,
              let body = data.body
        else {
            return
        }
        
        contentTextView.text = title + "\n" + body
    }
    
    func scrollTextViewToTop() {
        contentTextView.contentOffset = .zero
    }
    
    func adjustConstraint(by keyboardHeight: CGFloat) {
        bottomConstraint?.constant = -keyboardHeight
        UIView.animate(withDuration: 0.25, delay: .zero) {
            self.layoutIfNeeded()
        }
    }
}
