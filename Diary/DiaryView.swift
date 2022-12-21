//  Diary - DiaryCell.swift
//  Created by Ayaan, zhilly on 2022/12/21

import UIKit

class DiaryView: UIView {
    private let titleTextField: UITextField = {
        let textField = UITextField()
        textField.font = .preferredFont(forTextStyle: .title3)
        textField.textColor = .black
        textField.textAlignment = .left
        textField.placeholder = "제목"
        return textField
    }()
    
    private let bodyTextView: UITextView = {
        let textView = UITextView()
        textView.font = .preferredFont(forTextStyle: .body)
        textView.textColor = .black
        textView.textAlignment = .left
        textView.textContainer.lineFragmentPadding = 0
        return textView
    }()
    
    private let stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 8
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    var titleText: String? { return titleTextField.text }
    var bodyText: String? { return bodyTextView.text }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    private func setupViews() {
        backgroundColor = .systemBackground
        stackView.addArrangedSubview(titleTextField)
        stackView.addArrangedSubview(bodyTextView)
        addSubview(stackView)
        
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: 8),
            stackView.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor, constant: -8),
            stackView.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor, constant: 8),
            stackView.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor, constant: -8)
        ])
    }
    
    func setupData(of diary: Diary) {
        titleTextField.text = diary.title
        bodyTextView.text = diary.body
    }
}
