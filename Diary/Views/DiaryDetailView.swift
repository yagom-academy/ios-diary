//
//  DiaryDetailView.swift
//  Diary
//
//  Created by Kyo, Baem on 2022/12/20.
//

import UIKit

class DiaryDetailView: UIView {
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = .white
        setupUI()
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    let titleTextField: UITextField = {
        let textfield = UITextField()
        textfield.placeholder = "Title"
        textfield.font = .preferredFont(forTextStyle: .title1)
        return textfield
    }()
    
    let contentsTextView: UITextView = {
        let textView = UITextView()
        textView.font = .preferredFont(forTextStyle: .body)
        return textView
    }()
}

// MARK: - UIConstraints
extension DiaryDetailView {
    private func setupUI() {
        [titleTextField, contentsTextView].forEach { component in
            self.addSubview(component)
            component.translatesAutoresizingMaskIntoConstraints = false
        }
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            titleTextField.topAnchor.constraint(equalTo: self.safeAreaLayoutGuide.topAnchor),
            titleTextField.leadingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.leadingAnchor),
            titleTextField.trailingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.trailingAnchor),
            
            contentsTextView.topAnchor.constraint(equalTo: titleTextField.bottomAnchor),
            contentsTextView.bottomAnchor.constraint(equalTo: self.safeAreaLayoutGuide.bottomAnchor),
            contentsTextView.leadingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.leadingAnchor),
            contentsTextView.trailingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.trailingAnchor)
        ])
    }
}
