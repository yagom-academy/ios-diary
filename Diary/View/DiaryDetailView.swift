//
//  DiaryDetailView.swift
//  Diary
//
//  Created by 써니쿠키, LJ on 2022/12/21.
//

import UIKit

final class DiaryDetailView: UIView {
    
    let titleTextView = CustomTextView(font: .title1)
    let bodyTextView = CustomTextView(font: .body)
    
    let diaryTextScrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.showsVerticalScrollIndicator = false
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.keyboardDismissMode = .interactive
        
        return scrollView
    }()
    
    private let diaryTextStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.spacing = 10
        stackView.axis = .vertical
        stackView.alignment = .leading
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        return stackView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = .systemBackground
        configureDetailLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configureDetailLayout() {
        [titleTextView, bodyTextView].forEach { diaryTextStackView.addArrangedSubview($0) }
        diaryTextScrollView.addSubview(diaryTextStackView)
        self.addSubview(diaryTextScrollView)
        
        NSLayoutConstraint.activate([
            diaryTextScrollView.frameLayoutGuide.leadingAnchor.constraint(
                equalTo: readableContentGuide.leadingAnchor),
            diaryTextScrollView.frameLayoutGuide.trailingAnchor.constraint(
                equalTo: readableContentGuide.trailingAnchor),
            diaryTextScrollView.frameLayoutGuide.topAnchor.constraint(
                equalTo: readableContentGuide.topAnchor),
            diaryTextScrollView.frameLayoutGuide.bottomAnchor.constraint(
                equalTo: readableContentGuide.bottomAnchor),
            diaryTextScrollView.contentLayoutGuide.leadingAnchor.constraint(
                equalTo: diaryTextScrollView.frameLayoutGuide.leadingAnchor),
            diaryTextScrollView.contentLayoutGuide.trailingAnchor.constraint(
                equalTo: diaryTextScrollView.frameLayoutGuide.trailingAnchor),
            
            diaryTextStackView.leadingAnchor.constraint(
                equalTo: diaryTextScrollView.contentLayoutGuide.leadingAnchor),
            diaryTextStackView.trailingAnchor.constraint(
                equalTo: diaryTextScrollView.contentLayoutGuide.trailingAnchor),
            diaryTextStackView.topAnchor.constraint(
                equalTo: diaryTextScrollView.contentLayoutGuide.topAnchor),
            diaryTextStackView.bottomAnchor.constraint(
                equalTo: diaryTextScrollView.contentLayoutGuide.bottomAnchor)
        ])
    }
}
