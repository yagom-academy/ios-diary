//
//  RegisterViewController.swift
//  Diary
//
//  Created by SummerCat and som on 2022/12/20.
//

import UIKit

class RegisterViewController: UIViewController {
    let stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.spacing = 8
        return stackView
    }()
    
    let titleTextView: UITextView = {
        let textView = UITextView()
        textView.isScrollEnabled = false
        textView.setContentCompressionResistancePriority(.required, for: .vertical)
        textView.textColor = .systemGray3
        textView.font = UIFont.preferredFont(forTextStyle: .title2)
        textView.text = Placeholder.title
        return textView
    }()
    
    let bodyTextView: UITextView = {
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
        self.view.addSubview(stackView)
        stackView.addArrangedSubview(titleTextView)
        stackView.addArrangedSubview(bodyTextView)
        
        titleTextView.delegate = self
        bodyTextView.delegate = self
        
        NSLayoutConstraint.activate([
            stackView.leadingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leadingAnchor, constant: 8),
            stackView.trailingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.trailingAnchor, constant: -8),
            stackView.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor),
            view.keyboardLayoutGuide.topAnchor.constraint(equalTo: stackView.bottomAnchor)
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

extension RegisterViewController {
    private enum Placeholder {
        static let title = "제목을 입력해주세요."
        static let body = "본문을 입력해주세요."
    }
}
