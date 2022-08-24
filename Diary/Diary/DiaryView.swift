//
//  DiaryView.swift
//  Diary
//
//  Created by unchain, 웡빙 on 2022/08/17.
//

import UIKit

final class DiaryView: UIView {
    // MARK: - Properties
    
    let placeHolder = NameSpace.placeHolder
    lazy var diaryTextView: UITextView = {
        let textview = UITextView()
        textview.translatesAutoresizingMaskIntoConstraints = false
        textview.text = placeHolder
        textview.font = UIFont.preferredFont(forTextStyle: .title1)
        textview.textColor = .lightGray
        textview.inputAccessoryView = accessoryView
        return textview
    }()
    
    private let accessoryView: UIView = {
        return UIView(frame: CGRect(x: 0.0, y: 0.0, width: UIScreen.main.bounds.width, height: 50))
    }()
    
    let closeButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle(NameSpace.close, for: .normal)
        button.setTitleColor(UIColor.black, for: .normal)
        button.backgroundColor = .systemGray6
        return button
    }()
    
    // MARK: - Initializer

    override init(frame: CGRect) {
        super.init(frame: frame)
        diaryTextView.delegate = self
        setupSubviews()
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    // MARK: - Methods

    private func setupSubviews() {
        addSubview(diaryTextView)
        accessoryView.addSubview(closeButton)
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            closeButton.leadingAnchor.constraint(equalTo: accessoryView.leadingAnchor, constant: 350),
            closeButton.trailingAnchor.constraint(equalTo: accessoryView.trailingAnchor),
            closeButton.bottomAnchor.constraint(equalTo: accessoryView.bottomAnchor),
            closeButton.heightAnchor.constraint(equalToConstant: 30)
        ])
        
        NSLayoutConstraint.activate([
            diaryTextView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            diaryTextView.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            diaryTextView.bottomAnchor.constraint(equalTo: self.bottomAnchor),
            diaryTextView.topAnchor.constraint(equalTo: self.topAnchor)
        ])
    }
}

// MARK: - UITextViewDelegate

extension DiaryView: UITextViewDelegate {
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if text == "\n" {
            textView.typingAttributes = [NSAttributedString.Key.font: UIFont.preferredFont(forTextStyle: .body)]
        }
        return true
    }
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.text == placeHolder {
            textView.text = nil
            textView.textColor = .black
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
            textView.text = placeHolder
            textView.textColor = .lightGray
        }
    }
}
