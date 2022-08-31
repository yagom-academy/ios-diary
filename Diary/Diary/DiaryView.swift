//
//  DiaryView.swift
//  Diary
//
//  Created by unchain, 웡빙 on 2022/08/17.
//

import UIKit

final class DiaryView: UIView {
    // MARK: - NameSpace

    private enum DiaryNameSpace {
        static let close = "닫기"
    }

    // MARK: - Properties
    
    private var isTwiceLineChange: Bool = false
    private var realTimeTypingValue: String = NameSpace.whiteSpace {
        didSet {
            if oldValue == NameSpace.lineChange && realTimeTypingValue == NameSpace.lineChange {
                isTwiceLineChange = true
            }
        }
    }
    private let placeHolder = NameSpace.placeHolder
    
    // MARK: - UIComponents
    
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
        button.setTitle(DiaryNameSpace.close, for: .normal)
        button.setTitleColor(UIColor.black, for: .normal)
        button.backgroundColor = .systemGray6
        return button
    }()
    
    // MARK: - Initializer
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        adaptDelegate()
        setupSubviews()
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    // MARK: - Methods
    
    private func adaptDelegate() {
        diaryTextView.delegate = self
    }
    
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
    
    private func setAttributedString(with diaryTitle: String, and diaryBody: String) -> NSMutableAttributedString {
        let attributedString = NSMutableAttributedString(string: diaryTitle + NameSpace.twiceLineChange,
                                                         attributes: [NSAttributedString.Key.font: UIFont.preferredFont(forTextStyle: .title1)])
        attributedString.append(NSMutableAttributedString(string: diaryBody,
                                                          attributes: [NSAttributedString.Key.font: UIFont.preferredFont(forTextStyle: .body)]))
        return attributedString
    }

    func setupData(with model: Diary?) {
        guard let diaryTitle = model?.title,
              let diaryBody = model?.body else { return }
        if diaryBody != NameSpace.whiteSpace {
            let attributedString = setAttributedString(with: diaryTitle, and: diaryBody)
            diaryTextView.attributedText = attributedString
        } else {
            diaryTextView.textColor = nil
            diaryTextView.text = diaryTitle
        }
    }
}

// MARK: - UITextViewDelegate

extension DiaryView: UITextViewDelegate {
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        realTimeTypingValue = text
        if isTwiceLineChange {
            textView.typingAttributes = [NSAttributedString.Key.font: UIFont.preferredFont(forTextStyle: .body)]
            isTwiceLineChange = false
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
