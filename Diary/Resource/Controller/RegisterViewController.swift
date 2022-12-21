//
//  RegisterViewController.swift
//  Diary
//
//  Created by SummerCat and som on 2022/12/20.
//

import UIKit

final class RegisterViewController: UIViewController {
    private let mainStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.spacing = 4
        return stackView
    }()
    
    private let titleTextView: UITextView = {
        let textView = UITextView()
        textView.isScrollEnabled = false
        textView.setContentCompressionResistancePriority(.required, for: .vertical)
        textView.textColor = .systemGray3
        textView.font = UIFont.preferredFont(forTextStyle: .title2)
        textView.text = Placeholder.title
        return textView
    }()
    
    private let bodyTextView: UITextView = {
        let textView = UITextView()
        textView.textColor = .systemGray3
        textView.font = UIFont.preferredFont(forTextStyle: .body)
        textView.text = Placeholder.body
        return textView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = .systemBackground
        configureNavigationBar()
        configureLayout()
    }
    
    private func configureLayout() {
        self.view.addSubview(mainStackView)
        mainStackView.addArrangedSubview(titleTextView)
        mainStackView.addArrangedSubview(bodyTextView)
        
        titleTextView.delegate = self
        bodyTextView.delegate = self
        
        mainStackView.directionalLayoutMargins = NSDirectionalEdgeInsets(top: 0, leading: 8, bottom: 8, trailing: 8)
        mainStackView.isLayoutMarginsRelativeArrangement = true
        
        NSLayoutConstraint.activate([
            mainStackView.leadingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leadingAnchor),
            mainStackView.trailingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.trailingAnchor),
            mainStackView.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor),
            view.keyboardLayoutGuide.topAnchor.constraint(equalTo: mainStackView.bottomAnchor)
        ])
    }
    
    private func configureNavigationBar() {
        self.navigationController?.navigationBar.scrollEdgeAppearance = navigationController?.navigationBar.standardAppearance
        
        let date = Date()
        self.title = DateFormatterManager().formatDate(date)
    }
}

extension RegisterViewController: UITextViewDelegate {
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.textColor == UIColor.systemGray3 {
            textView.text = nil
            textView.textColor = .black
        }
    }
}

fileprivate enum Placeholder {
    static let title = "제목을 입력해주세요."
    static let body = "본문을 입력해주세요."
}

