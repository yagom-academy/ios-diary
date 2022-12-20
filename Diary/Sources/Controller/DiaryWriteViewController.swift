//
//  DiaryWriteViewController.swift
//  Diary
//
//  Copyright (c) 2022 Minii All rights reserved.
        
import UIKit

final class DiaryWriteViewController: UIViewController {
    let titleTextField: UITextField = {
        let titleTextField = UITextField()
        titleTextField.placeholder = "제목을 입력해주세요."
        titleTextField.font = .preferredFont(forTextStyle: .title2)
        titleTextField.adjustsFontForContentSizeCategory = true
        return titleTextField
    }()
    
    let contentTextView: UITextView = {
        let textView = UITextView()
        textView.font = .preferredFont(forTextStyle: .body)
        textView.adjustsFontForContentSizeCategory = true
        
        return textView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setNavigationBar()
        configureLayout()
    }
}

extension DiaryWriteViewController {
    private func addElementViews() {
        [titleTextField, contentTextView].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            view.addSubview($0)
        }
    }
    
    private func configureLayout() {
        addElementViews()
        
        let safeArea = view.safeAreaLayoutGuide
        
        NSLayoutConstraint.activate([
            titleTextField.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor, constant: 16),
            titleTextField.topAnchor.constraint(equalTo: safeArea.topAnchor, constant: 8),
            titleTextField
                .trailingAnchor
                .constraint(equalTo: safeArea.trailingAnchor, constant: -16),
            
            contentTextView.leadingAnchor.constraint(equalTo: titleTextField.leadingAnchor),
            contentTextView
                .topAnchor
                .constraint(equalTo: titleTextField.bottomAnchor, constant: 8),
            contentTextView.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor),
            contentTextView.bottomAnchor.constraint(equalTo: safeArea.bottomAnchor)
        ])
    }
    
    private func setNavigationBar() {
        navigationItem.setNavigationTitle(title: Date().description)
    }
}
