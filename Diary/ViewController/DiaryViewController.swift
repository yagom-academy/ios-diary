//
//  DiaryViewController.swift
//  Diary
//
//  Created by MINT, BMO on 2023/08/30.
//

import UIKit

final class DiaryViewController: UIViewController {
    private let contentTextView: UITextView = {
        let textView = UITextView()
        textView.translatesAutoresizingMaskIntoConstraints = false
        return textView
    }()
    override func viewDidLoad() {
        super.viewDidLoad()
        configureBackgroundColor()
        configureTextView()
    }
    private func configureBackgroundColor() {
        view.backgroundColor = .systemBackground
    }
    private func configureTextView() {
        view.addSubview(contentTextView)
        configureTextViewConstraint()
    }
    private func configureTextViewConstraint() {
        NSLayoutConstraint.activate([
            contentTextView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            contentTextView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            contentTextView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            contentTextView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }
}
