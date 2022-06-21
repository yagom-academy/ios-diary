//
//  DetailView.swift
//  Diary
//
//  Created by Donnie, OneTool on 2022/06/15.
//

import UIKit

final class DetailView: UIView {
    
    private enum Constants {
        static let mainStackViewSpacing: CGFloat = 5
        static let mainStackViewLayoutMargin: CGFloat = 10
        static let mainScrollViewSpacingFromViewLeading: CGFloat = 15
        static let mainScrollViewSpacingFromViewTrailing: CGFloat = -15
    }
    
    let mainScrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.isScrollEnabled = true
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.showsVerticalScrollIndicator = true
        return scrollView
    }()
    
    private lazy var mainStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [titleField, descriptionView])
        stackView.axis = .vertical
        stackView.distribution = .fill
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.spacing = Constants.mainStackViewSpacing
        stackView.isLayoutMarginsRelativeArrangement = true
        stackView.layoutMargins = UIEdgeInsets(
            top: Constants.mainStackViewLayoutMargin,
            left: Constants.mainStackViewLayoutMargin,
            bottom: 0,
            right: Constants.mainStackViewLayoutMargin
        )
        return stackView
    }()
    
    private lazy var titleField: UITextField = {
        let textField = UITextField()
        textField.textAlignment = .left
        return textField
    }()
    
    private lazy var descriptionView: UITextView = {
        let textView = UITextView()
        textView.font = .preferredFont(forTextStyle: .body)
        textView.textAlignment = .left
        textView.isScrollEnabled = false
        return textView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .systemBackground
        setConstraints()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
}

// MARK: - Method

extension DetailView {
    
    private func setConstraints() {
        self.addSubview(mainScrollView)
        NSLayoutConstraint.activate([
            mainScrollView.topAnchor.constraint(equalTo: self.topAnchor),
            mainScrollView.bottomAnchor.constraint(equalTo: self.bottomAnchor),
            mainScrollView.leadingAnchor.constraint(
                equalTo: self.leadingAnchor,
                constant: Constants.mainScrollViewSpacingFromViewLeading),
            mainScrollView.trailingAnchor.constraint(
                equalTo: self.trailingAnchor,
                constant: Constants.mainScrollViewSpacingFromViewTrailing
            )
        ])
        
        mainScrollView.addSubview(mainStackView)
        NSLayoutConstraint.activate([
            mainStackView.topAnchor.constraint(equalTo: mainScrollView.topAnchor),
            mainStackView.bottomAnchor.constraint(equalTo: mainScrollView.bottomAnchor),
            mainStackView.leadingAnchor.constraint(equalTo: mainScrollView.leadingAnchor),
            mainStackView.trailingAnchor.constraint(equalTo: mainScrollView.trailingAnchor),
            mainStackView.widthAnchor.constraint(equalTo: mainScrollView.widthAnchor)
        ])
    }
    
    func setUpView(diaryData: DiaryModel) {
        titleField.text = diaryData.title
        descriptionView.text = diaryData.body
    }
}
