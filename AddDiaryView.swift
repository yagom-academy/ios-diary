//
//  AddDiaryView.swift
//  Diary
//
//  Created by 애종, 애쉬 on 2022/12/20.
//

import UIKit

class AddDiaryView: UIView {
    
    let scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        
        return scrollView
    }()
    
    let textView: UITextView = {
        let textView = UITextView()
        textView.isEditable = true
        textView.translatesAutoresizingMaskIntoConstraints = false
        
        return textView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
//        self.backgroundColor = .white
        configureView()
        configureAutoLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configureView() {
        self.scrollView.addSubview(textView)
        self.addSubview(scrollView)
    }
    
    private func configureAutoLayout() {
        NSLayoutConstraint.activate([
            self.scrollView.widthAnchor.constraint(equalTo: self.safeAreaLayoutGuide.widthAnchor),
            self.scrollView.topAnchor.constraint(equalTo: self.safeAreaLayoutGuide.topAnchor),
            self.scrollView.leadingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.leadingAnchor),
            self.scrollView.trailingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.trailingAnchor),
            self.scrollView.bottomAnchor.constraint(equalTo: self.safeAreaLayoutGuide.bottomAnchor),
            self.textView.widthAnchor.constraint(equalTo: self.scrollView.widthAnchor),
            self.textView.heightAnchor.constraint(equalTo: self.scrollView.heightAnchor),
            self.textView.topAnchor.constraint(equalTo: self.scrollView.topAnchor),
            self.textView.leadingAnchor.constraint(equalTo: self.scrollView.leadingAnchor),
            self.textView.trailingAnchor.constraint(equalTo: self.scrollView.trailingAnchor),
            self.textView.bottomAnchor.constraint(equalTo: self.scrollView.bottomAnchor)
        ])
    }
}
