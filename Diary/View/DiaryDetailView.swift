//
//  DiaryDetailView.swift
//  Diary
//
//  Created by 써니쿠키, LJ on 2022/12/21.
//

import UIKit

final class DiaryDetailView: UIView {
    
    var isTitlePlaceHolderState: Bool = false
    var isBodyPlaceHolderState: Bool = false
    private let titleTextView = CustomTextView(font: .title1)
    private let bodyTextView = CustomTextView(font: .body)
    var title: String {
        return titleTextView.text
    }
    var body: String {
        return bodyTextView.text
    }
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
    
    func configureTitle(_ title: String) {
        titleTextView.text = title
        titleTextView.textColor = .black
    }
    
    func configureBody(_ body: String) {
        bodyTextView.text = body
        bodyTextView.textColor = .black
    }
    
    func changeScrollViewBottomInset(_ inset: CGFloat ) {
        diaryTextScrollView.contentInset.bottom += inset
    }
    
    func addTextViewsDelegate(_ controller: UIViewController) {
        guard let controller = controller as? UITextViewDelegate else {
            return
        }
        
        titleTextView.delegate = controller
        bodyTextView.delegate = controller
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
    
    func makeTitleTextViewFirstResponder() {
        titleTextView.becomeFirstResponder()
    }
}

private enum Constant {
    static let titlePlaceHolder = "일기 제목"
    static let bodyPlaceHolder = "일기 내용"
    static let empty = ""
}
