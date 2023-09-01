//
//  DiaryViewController.swift
//  Diary
//
//  Created by MINT, BMO on 2023/08/30.
//

import UIKit

final class DiaryViewController: UIViewController {
    private let diary: Diary?
    var titleLine: Bool = false
    private let contentTextView: UITextView = {
        let textView = UITextView()
        textView.translatesAutoresizingMaskIntoConstraints = false
        return textView
    }()
    init(diary: Diary? = nil) {
        self.diary = diary
        super.init(nibName: nil, bundle: nil)
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        contentTextView.delegate = self
        configureBackgroundColor()
        configureTextView()
        fillTextView()
        configureTextViewConstraint()
    }
    private func configureBackgroundColor() {
        view.backgroundColor = .systemBackground
    }
    private func fillTextView() {
        guard let diary else {
            let dateFormatter = DateFormatter()
            dateFormatter.configureDiaryDateFormat()
            navigationItem.title = dateFormatter.string(from: Date())
            return
        }
        contentTextView.text = diary.title + "\n\n" + diary.body
        navigationItem.title = diary.date
    }
    private func configureTextView() {
        view.addSubview(contentTextView)
    }
    private func configureTextViewConstraint() {
        NSLayoutConstraint.activate([
            contentTextView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            contentTextView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            contentTextView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            contentTextView.bottomAnchor.constraint(equalTo: view.keyboardLayoutGuide.topAnchor)
        ])
    }
}
extension DiaryViewController: UITextViewDelegate {
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if titleLine == false && text == "\n" {
            contentTextView.text += "\n"
            titleLine = true
        }
        return true
    }
}
