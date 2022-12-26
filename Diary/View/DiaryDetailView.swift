//
//  DiaryDetailView.swift
//  Diary
//
//  Created by 써니쿠키, LJ on 2022/12/21.
//

import UIKit

final class DiaryDetailView: UIView {
    
    private var isTitlePlaceHolderState: Bool = true
    private var isBodyPlaceHolderState: Bool = true
    private let titleTextView = CustomTextView(font: .title1)
    private let bodyTextView = CustomTextView(font: .body)
    
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
        setupPlaceHolder()
        titleTextView.becomeFirstResponder()
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
        if titleTextView.isFirstResponder && isTitlePlaceHolderState == true {
            configureTitle("")
            titleTextView.textColor = .black
            isTitlePlaceHolderState = false
        } else if bodyTextView.isFirstResponder && isBodyPlaceHolderState == true {
            configureBody("")
            bodyTextView.textColor = .black
            isBodyPlaceHolderState = false
        }
    }
    
    func setupPlaceHolder() {
        if titleTextView.text == Constant.empty {
            configureTitle(Constant.titlePlaceHolder)
            titleTextView.textColor = .systemGray3
            isTitlePlaceHolderState = true
        }
        
        if bodyTextView.text == Constant.empty {
            configureBody(Constant.bodyPlaceHolder)
            bodyTextView.textColor = .systemGray3
            isBodyPlaceHolderState = true
        }
    }
}

private enum Constant {
    static let titlePlaceHolder = "일기 제목"
    static let bodyPlaceHolder = "일기 내용"
    static let empty = ""
}
