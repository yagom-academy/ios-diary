//
//  DiaryItemViewController.swift
//  Diary
//
//  Created by 정선아 on 2022/12/26.
//

import UIKit

class DiaryItemViewController: UIViewController {
    var diaryTitle: String? = ""
    var diaryBody: String? = ""
    var titleRange: NSRange?
    var firstReturnIndex: String.Index?
    var hasTitle: Bool = false {
        didSet {
            mainTextView.attributedText = mainTextView.attributedText.formatTitle(between: titleRange)
        }
    }
    
    let mainTextView: UITextView = {
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
        view.addSubview(mainTextView)
        
        NSLayoutConstraint.activate([
            mainTextView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            mainTextView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            mainTextView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            mainTextView.bottomAnchor.constraint(equalTo: view.keyboardLayoutGuide.topAnchor, constant: -4)
        ])
    }
}

enum Placeholder {
    static let editText = "일기를 입력해주세요."
}
