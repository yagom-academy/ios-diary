//
//  DetailView.swift
//  Diary
//
//  Created by 조성훈 on 2022/06/14.
//

import UIKit

final class DetailView: UIView {
    override init(frame: CGRect) {
        super.init(frame: frame)
        setUpView()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setUpView()
    }
    
    let baseTextView: UITextView = {
        let textView = UITextView(frame: .zero)
        textView.translatesAutoresizingMaskIntoConstraints = false
        return textView
    }()
    
    private func setUpView() {
        addSubviews()
        makeConstraints()
        backgroundColor = .systemBackground
    }
    
    private func addSubviews() {
        addSubview(baseTextView)
    }
    
    private func makeConstraints() {
        NSLayoutConstraint.activate([
            baseTextView.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor),
            baseTextView.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor),
            baseTextView.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor),
            baseTextView.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor)
        ])
    }
    
    func setUpContents(data: Diary) {
        baseTextView.text = data.title + "\n\n" + data.body
    }
    
    func scrollToTop() {
        baseTextView.contentOffset = .zero
    }
}
