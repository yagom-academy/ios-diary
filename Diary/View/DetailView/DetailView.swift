//
//  DetailView.swift
//  Diary
//
//  Created by 우롱차, RED on 2022/06/14.
//

import UIKit

final class DetailView: UIView {
    
    private lazy var textViewBottomConstraint = textView.bottomAnchor.constraint(
        equalTo: safeAreaLayoutGuide.bottomAnchor
    )
    
    private lazy var textView: UITextView = {
        let textView = UITextView()
        textView.translatesAutoresizingMaskIntoConstraints = false
        textView.font = UIFont.preferredFont(forTextStyle: .body)
        return textView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .white
        addSubview(textView)
        setConstraint()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        print("디테일뷰 초기화 안됨")
    }
    
    private func setConstraint() {
        if #available(iOS 15.0, *) {
            NSLayoutConstraint.activate([
                textView.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor),
                textView.leftAnchor.constraint(equalTo: safeAreaLayoutGuide.leftAnchor),
                textView.rightAnchor.constraint(equalTo: safeAreaLayoutGuide.rightAnchor),
                textView.bottomAnchor.constraint(equalTo: keyboardLayoutGuide.topAnchor)
            ])
        } else {
            NSLayoutConstraint.activate([
                textView.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor),
                textView.leftAnchor.constraint(equalTo: safeAreaLayoutGuide.leftAnchor),
                textView.rightAnchor.constraint(equalTo: safeAreaLayoutGuide.rightAnchor),
                textViewBottomConstraint
            ])
        }
    }
    
    func setData(with diary: DiaryData) {
        textView.text = diary.body
    }
    
    func changeTextViewHeight(_ height: CGFloat = 0) {
        textViewBottomConstraint.isActive = false
        textViewBottomConstraint = textView.bottomAnchor.constraint(
            equalTo: safeAreaLayoutGuide.bottomAnchor,
            constant: -height
        )
        textViewBottomConstraint.isActive = true
    }
}
