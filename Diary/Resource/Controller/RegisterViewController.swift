//
//  RegisterViewController.swift
//  Diary
//
//  Created by SummerCat and som on 2022/12/20.
//

import UIKit

final class RegisterViewController: UIViewController {
    private var diaryTitle: String? = ""
    private var diaryBody: String? = ""
    private var titleRange: NSRange?
    private var firstReturnIndex: String.Index?
    private var hasTitle: Bool = false {
        didSet {
            mainTextView.attributedText = mainTextView.attributedText.formatTitle(between: titleRange)
        }
    }
    
    private let mainTextView: UITextView = {
        let textView = UITextView()
        textView.translatesAutoresizingMaskIntoConstraints = false
        textView.textColor = .systemGray3
        textView.font = UIFont.preferredFont(forTextStyle: .body)
        textView.text = Placeholder.editText
        textView.textContainerInset = UIEdgeInsets(top: .zero, left: .zero, bottom: .zero, right: .zero)
        return textView
    }()

    override func loadView() {
        view = UIView(frame: .zero)
        view.backgroundColor = .systemBackground
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        configureNavigationBar()
        configureTextView()
    }

    private func configureNavigationBar() {
        navigationController?.navigationBar.scrollEdgeAppearance = navigationController?.navigationBar.standardAppearance
        
        let date = Date()
        title = DateFormatterManager().formatDate(date)
    }

    private func configureTextView() {
        mainTextView.delegate = self
        view.addSubview(mainTextView)
        
        NSLayoutConstraint.activate([
            mainTextView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            mainTextView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            mainTextView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            mainTextView.bottomAnchor.constraint(equalTo: view.keyboardLayoutGuide.topAnchor, constant: -4)
        ])
    }
}

extension RegisterViewController: UITextViewDelegate {
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.textColor == UIColor.systemGray3 {
            textView.text = nil
            textView.textColor = .black
        }
    }
    
    func textViewDidChange(_ textView: UITextView) {
        guard !hasTitle else { return }
        
        guard let firstReturnIndex = mainTextView.text.firstIndex(of: "\n") else { return }

        let distance = mainTextView.text.distance(from: mainTextView.text.startIndex, to: firstReturnIndex)
        diaryTitle = String(mainTextView.text[..<firstReturnIndex])
        titleRange = NSRange(location: 0, length: distance)
        hasTitle = true
    }
    
    // TODO: didEndEditing에서 body 할당
//    diaryBody = String(mainTextView.text[returnIdx...]).trimmingCharacters(in: .whitespaces)
}

fileprivate enum Placeholder {
    static let editText = "일기를 입력해주세요."
}
