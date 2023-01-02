//
//  DiaryDetailView.swift
//  Diary
//
//  Created by 써니쿠키, LJ on 2022/12/21.
//

import UIKit

final class DiaryDetailView: UIView {
    
    private let titleTextView = CustomTextView(font: .title1)
    private let bodyTextView = CustomTextView(font: .body)
    private let titlePlaceHolder = CustomLabel(text: Constant.titlePlaceHolder,
                                               textColor: .systemGray2,
                                               font: .title1)
    private let bodyPlaceHolder = CustomLabel(text: Constant.bodyPlaceHolder,
                                              textColor: .systemGray2,
                                              font: .body)
    
    private let diaryTextScrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.showsVerticalScrollIndicator = false
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.keyboardDismissMode = .interactive
        scrollView.alwaysBounceVertical = true
        
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
    
    var title: String {
        return titleTextView.text
    }
    var body: String {
        return bodyTextView.text
    }
    var scrollViewBottomInset: CGFloat {
        return diaryTextScrollView.contentInset.bottom
    }
    
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
            diaryTextScrollView.contentLayoutGuide.widthAnchor.constraint(
                equalTo: diaryTextScrollView.frameLayoutGuide.widthAnchor),
            
            diaryTextStackView.widthAnchor.constraint(
                equalTo: diaryTextScrollView.contentLayoutGuide.widthAnchor),
            diaryTextStackView.heightAnchor.constraint(
                equalTo: diaryTextScrollView.contentLayoutGuide.heightAnchor)
        ])
    }
    
    func configureTitle(_ title: String) {
        titleTextView.text = title
        titleTextView.textColor = .black
    }
    
    func configureBody(_ body: String) {
        bodyTextView.text = body
        bodyTextView.textColor = .black
    }
    
    func makeTitleTextViewFirstResponder() {
        titleTextView.becomeFirstResponder()
    }
    
    func resignTitleTextViewFirstResponder() {
        titleTextView.resignFirstResponder()
    }
    
    func addTextViewsDelegate(_ controller: UIViewController) {
        guard let controller = controller as? UITextViewDelegate else {
            return
        }
        
        titleTextView.delegate = controller
        bodyTextView.delegate = controller
    }
    
    func changeScrollViewBottomInset(_ inset: CGFloat ) {
        diaryTextScrollView.contentInset.bottom = inset
    }

    func removePlaceHolder() {
        if title != Constant.empty {
            titlePlaceHolder.removeFromSuperview()
        }
        
        if body != Constant.empty {
            bodyPlaceHolder.removeFromSuperview()
        }
    }
    
    func setupPlaceHolder() {
        if title == Constant.empty {
            titleTextView.addSubview(titlePlaceHolder)
            
            NSLayoutConstraint.activate([
                titlePlaceHolder.leadingAnchor.constraint(
                    equalTo: titleTextView.frameLayoutGuide.leadingAnchor, constant: 7),
                titlePlaceHolder.trailingAnchor.constraint(
                    equalTo: titleTextView.frameLayoutGuide.trailingAnchor),
                titlePlaceHolder.heightAnchor.constraint(
                    equalTo: titleTextView.frameLayoutGuide.heightAnchor)
            ])
        }
        
        if body == Constant.empty {
            bodyTextView.addSubview(bodyPlaceHolder)
            
            NSLayoutConstraint.activate([
                bodyPlaceHolder.leadingAnchor.constraint(
                    equalTo: bodyTextView.frameLayoutGuide.leadingAnchor, constant: 7),
                bodyPlaceHolder.trailingAnchor.constraint(
                    equalTo: bodyTextView.frameLayoutGuide.trailingAnchor),
                bodyPlaceHolder.heightAnchor.constraint(
                    equalTo: bodyTextView.frameLayoutGuide.heightAnchor)
            ])
        }
    }
}

extension DiaryDetailView {
    
    private enum Constant {
        static let titlePlaceHolder = "일기 제목"
        static let bodyPlaceHolder = "일기 내용"
        static let empty = ""
    }
}
