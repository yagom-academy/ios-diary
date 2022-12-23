//  Diary - DiaryView.swift
//  Created by Ayaan, zhilly on 2022/12/21

import UIKit

final class DiaryView: UIView {
    private enum Constant {
        static let titlePlaceholder = "제목"
        static let bodyPlaceholder = "내용"
    }
    
    private let titleTextField: UITextField = {
        let textField = UITextField()
        
        textField.font = .preferredFont(forTextStyle: .title3)
        textField.textColor = .black
        textField.textAlignment = .left
        textField.placeholder = Constant.titlePlaceholder
        
        return textField
    }()
    
    private let bodyTextView: DiaryTextView = {
        let textView = DiaryTextView(placeholder: Constant.bodyPlaceholder,
                                     defaultTextColor: .black)
        
        textView.font = .preferredFont(forTextStyle: .body)
        textView.textAlignment = .left
        textView.textContainer.lineFragmentPadding = 0
        textView.isScrollEnabled = false
        
        return textView
    }()
    
    private let stackView: UIStackView = {
        let stackView = UIStackView()
        
        stackView.axis = .vertical
        stackView.spacing = 8
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        return stackView
    }()
    
    private let scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        
        return scrollView
    }()
    
    var titleText: String? { return titleTextField.text }
    var bodyText: String? { return bodyTextView.text }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    private func setupViews() {
        backgroundColor = .systemBackground
        stackView.addArrangedSubview(titleTextField)
        stackView.addArrangedSubview(bodyTextView)
        scrollView.addSubview(stackView)
        addSubview(scrollView)
        
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: 8),
            keyboardLayoutGuide.topAnchor.constraint(equalToSystemSpacingBelow: scrollView.bottomAnchor,
                                                     multiplier: 1.0),
            scrollView.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor, constant: 8),
            scrollView.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor, constant: -8)
        ])
        
        let stackViewHeightConstraint = stackView.heightAnchor.constraint(
            equalTo: scrollView.frameLayoutGuide.heightAnchor
        )
        
        stackViewHeightConstraint.priority = .defaultLow
        
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: scrollView.contentLayoutGuide.topAnchor),
            stackView.bottomAnchor.constraint(equalTo: scrollView.contentLayoutGuide.bottomAnchor),
            stackView.leadingAnchor.constraint(equalTo: scrollView.contentLayoutGuide.leadingAnchor),
            stackView.trailingAnchor.constraint(equalTo: scrollView.contentLayoutGuide.trailingAnchor),
            stackView.widthAnchor.constraint(equalTo: scrollView.frameLayoutGuide.widthAnchor),
            stackViewHeightConstraint
        ])
    }
    
    func setupBodyTextViewDelegate(textViewDelegate: UITextViewDelegate) {
        bodyTextView.delegate = textViewDelegate
    }
    
    func setupScrollViewDelegate(scrollViewDelegate: UIScrollViewDelegate) {
        scrollView.delegate = scrollViewDelegate
    }
    
    func setupData(of diary: Diary) {
        titleTextField.text = diary.title
        
        if diary.body.isEmpty == false {
            bodyTextView.text = diary.body
            bodyTextView.textColor = .black
        }
    }
}
