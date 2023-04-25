//
//  DiaryDetailViewController.swift
//  Diary
//
// Created by SeHong on 2023/04/24.
//

import UIKit

final class DiaryDetailViewController: UIViewController {
    
    private let diaryItem: Diary
    
    private let diaryDetailStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 10
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        return stackView
    }()
    
    private let titleTextField: UITextField = {
        let textField = UITextField()
        textField.font = .preferredFont(forTextStyle: .subheadline)
        textField.translatesAutoresizingMaskIntoConstraints = false
        
        return textField
    }()
    
    private let bodyTextView: UITextView = {
        let textView = UITextView()
        textView.font = .preferredFont(forTextStyle: .subheadline)
        textView.translatesAutoresizingMaskIntoConstraints = false
        
        return textView
    }()
    
    init(diaryItem: Diary) {
        self.diaryItem = diaryItem
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavigationBar()
        configureCellData()
        setupLayout()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
          self.view.endEditing(true)
      }
    
    private func setupNavigationBar() {
        title = Formatter.changeToString(from: diaryItem.createdAt)
    }
    
    private func configureCellData() {
        titleTextField.text = diaryItem.title
        bodyTextView.text = diaryItem.body
    }
    
    private func setupLayout() {
        view.backgroundColor = .systemBackground
        view.addSubview(diaryDetailStackView)
        
        diaryDetailStackView.addArrangedSubview(titleTextField)
        diaryDetailStackView.addArrangedSubview(bodyTextView)
        NSLayoutConstraint.activate([
            diaryDetailStackView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 8.0),
            diaryDetailStackView.bottomAnchor.constraint(equalTo: view.keyboardLayoutGuide.topAnchor),
            diaryDetailStackView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 8.0),
            diaryDetailStackView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -8.0)
        ])
    }
    
}
