//
//  AddDiaryViewController.swift
//  Diary
//
//  Created by jin on 12/22/22.
//

import UIKit

class AddDiaryViewController: UIViewController {

    private let titleTextField: UITextField = {
        let textField = UITextField()
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.placeholder = "제목"
        textField.font = .preferredFont(forTextStyle: .body)
        return textField
    }()
    
    private let contentTextView: UITextView = {
        let textView = UITextView()
        textView.translatesAutoresizingMaskIntoConstraints = false
        textView.font = .preferredFont(forTextStyle: .body)
        return textView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
        configureNavigationItem()
        configureUI()
        configureTextView()
    }
    
    private func configureNavigationItem() {
        let currentDate = DateFormatter.conversionLocalDate(date: Date(), local: .current, dateStyle: .long)
        self.navigationItem.title = currentDate
    }
    
    private func configureUI() {
        self.view.addSubview(titleTextField)
        self.view.addSubview(contentTextView)
        
        NSLayoutConstraint.activate([
            titleTextField.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            titleTextField.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor,
                                                    constant: 10),
            titleTextField.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor,
                                                     constant: -10),
            
            contentTextView.topAnchor.constraint(equalTo: titleTextField.bottomAnchor, constant: 15),
            contentTextView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 5),
            contentTextView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor,
                                                     constant: -10),
            contentTextView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }
    
    private func configureTextView() {
        contentTextView.delegate = self
        contentTextView.text = "내용을 입력하세요."
        contentTextView.textColor = .lightGray
    }
}

extension AddDiaryViewController: UITextViewDelegate {
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.text == "내용을 입력하세요." {
            textView.text = nil
            textView.textColor = .black
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        // 비어있으면 다시 플레이스 홀더처럼 입력하기 위해서 조건 확인
        if textView.text.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
            textView.text = "내용을 입력하세요."
            textView.textColor = .lightGray
        }
    }
}
