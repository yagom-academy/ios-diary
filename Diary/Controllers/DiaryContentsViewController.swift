//
//  DiaryContentsViewController.swift
//  Diary
//
//  Created by Toy, Morgan on 1/3/24.
//

import UIKit

final class DiaryContentsViewController: UIViewController {
    
    private let textTitle = {
        let textView = UITextView()
        textView.translatesAutoresizingMaskIntoConstraints = false
        textView.textContainerInset = UIEdgeInsets(top: 5, left: 10, bottom: 5, right: 10)
        textView.isScrollEnabled = false
        textView.font = .boldSystemFont(ofSize: 15)
        return textView
    }()
    
    private let textBody = {
        let textView = UITextView()
        textView.translatesAutoresizingMaskIntoConstraints = false
        textView.textContainerInset = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        textView.isScrollEnabled = true
        textView.font = UIFont.systemFont(ofSize: 15)
        return textView
    }()
    
    private let textStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.alignment = .fill
        stackView.distribution = .fill
        stackView.spacing = 0
        return stackView
    }()
    
    var dateTitle: String?
    var diaryTitle: String?
    var body: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupData()
        setupStackView()
        setStackViewConstraints()
        view.backgroundColor = .white
    }
    
    private func setupData() {
        textTitle.text = diaryTitle
        textBody.text = body
        navigationItem.title = dateTitle
    }
    
    private func setupStackView() {
        textStackView.addArrangedSubview(textTitle)
        textStackView.addArrangedSubview(textBody)
        view.addSubview(textStackView)
    }
    
    private func setStackViewConstraints() {
        NSLayoutConstraint.activate([
            textStackView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            textStackView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            textStackView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            textStackView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
}
