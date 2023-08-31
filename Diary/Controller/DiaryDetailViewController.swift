//
//  DiaryDetailViewController.swift
//  Diary
//
//  Created by hoon, karen on 2023/08/30.
//

import UIKit

class DiaryDetailViewController: UIViewController {
    private let titleTextView = {
        let textView = UITextView()
        textView.isEditable = true
        textView.backgroundColor = .red

        return textView
    }()
    
    private let bodyTextView = {
        let textView = UITextView()
        textView.isEditable = true
        textView.backgroundColor = .blue
        
        return textView
    }()
    
    private let contentStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 8
        stackView.distribution = .fillEqually
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.backgroundColor = .black
        
        return stackView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configure()
    }
}

private extension DiaryDetailViewController {
    func configure() {
        configureRootView()
        configureNavigation()
        configureSubviews()
        configureContentStackView()
        configureConstraints()
    }
    
    func configureRootView() {
        view.backgroundColor = .systemBackground
    }
    
    func configureNavigation() {
        let date = DateFormatter.diaryFormatter.string(from: Date())
        navigationItem.title = date
    }
    
    func configureSubviews() {
        view.addSubview(contentStackView)
    }
    
    func configureContentStackView() {
        contentStackView.addArrangedSubview(titleTextView)
        contentStackView.addArrangedSubview(bodyTextView)
    }
    
    func configureConstraints() {
        NSLayoutConstraint.activate([
            contentStackView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            contentStackView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            contentStackView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            contentStackView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }
}
