//
//  AddDiaryView.swift
//  Diary
//
//  Created by 백곰,주디 on 2022/08/17.
//

import UIKit

final class AddDiaryView: UIView {
    private let verticalStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.alignment = .fill
        stackView.distribution = .fill
        stackView.spacing = 5
        return stackView
    }()
    
    private let titleTextField: TextField = {
        let textField = TextField()
        textField.adjustsFontForContentSizeCategory = true
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.font = UIFont.preferredFont(forTextStyle: .body)
        textField.keyboardType = .default
        return textField
    }()
    
    private let bodyTextView: UITextView = {
        let textView = UITextView()
        textView.adjustsFontForContentSizeCategory = true
        textView.translatesAutoresizingMaskIntoConstraints = false
        textView.font = UIFont.preferredFont(forTextStyle: .body)
        textView.keyboardType = .default
        textView.textContainerInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        return textView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubView()
        setConstraint()
    }
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension AddDiaryView {
    private func addSubView() {
        self.addSubview(verticalStackView)
        verticalStackView.addArrangedSubview(titleTextField)
        verticalStackView.addArrangedSubview(bodyTextView)
    }
    
    private func setConstraint() {
        self.backgroundColor = .white
        NSLayoutConstraint.activate([
            verticalStackView.leadingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.leadingAnchor),
            verticalStackView.topAnchor.constraint(equalTo: self.safeAreaLayoutGuide.topAnchor, constant: 10),
            verticalStackView.trailingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.trailingAnchor),
            verticalStackView.bottomAnchor.constraint(equalTo: self.bottomAnchor)
        ])
    }
    
    func adjustContentInset(height: CGFloat) {
        self.bodyTextView.contentInset.bottom = height
    }
}

class TextField: UITextField {

    let padding = UIEdgeInsets(top: 0, left: 5, bottom: 0, right: 0)

    override open func textRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: padding)
    }

    override open func placeholderRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: padding)
    }

    override open func editingRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: padding)
    }
}
