//
//  DiaryRegistrationViewController.swift
//  Diary
//
//  Created by Mangdi, junho on 2022/12/22.
//

import UIKit

final class DiaryRegistrationViewController: UIViewController {
    private let titleTextView: UITextView = {
        let textView = UITextView()
        textView.translatesAutoresizingMaskIntoConstraints = false
        textView.font = UIFont.preferredFont(forTextStyle: .title3)
        textView.adjustsFontForContentSizeCategory = true
        textView.isScrollEnabled = false
        textView.text = "title"
        return textView
    }()

    private let bodyTextView: UITextView = {
        let textView = UITextView()
        textView.translatesAutoresizingMaskIntoConstraints = false
        textView.font = UIFont.preferredFont(forTextStyle: .body)
        textView.adjustsFontForContentSizeCategory = true
        textView.text = "body"
        return textView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .systemBackground
        configureNavigationItem()
        configureSubViews()
    }

    private func configureNavigationItem() {
        let timeInterval = Date().timeIntervalSince1970
        navigationItem.title = DateFormatter.convertToCurrentLocalizedText(timeIntervalSince1970: timeInterval)
    }

    private func configureSubViews() {
        view.addSubview(titleTextView)
        view.addSubview(bodyTextView)

        NSLayoutConstraint.activate([
            titleTextView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            titleTextView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            titleTextView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            bodyTextView.topAnchor.constraint(equalTo: titleTextView.bottomAnchor),
            bodyTextView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            bodyTextView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            bodyTextView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }
}
