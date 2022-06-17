//
//  DiaryDetailViewController.swift
//  Diary
//
//  Created by dudu, papri on 2022/06/14.
//

import UIKit

final class DiaryDetailViewController: UIViewController {
    private let diaryTextView: UITextView = {
        let textView = UITextView()
        textView.translatesAutoresizingMaskIntoConstraints = false
        return textView
    }()
    
    private let diary: Diary
    
    init(diary: Diary) {
        self.diary = diary
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUp()
        attribute()
        addSubViews()
        layout()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        if diary.isEmpty {
            diaryTextView.becomeFirstResponder()
        }
    }
    
    private func setUp() {
        setUpNavigationBar()
        setUpTextView()
    }
    
    private func setUpNavigationBar() {
        title = diary.createdDate.formattedString
    }
    
    private func setUpTextView() {
        diaryTextView.contentOffset = .zero
        diaryTextView.delegate = self
        
        if diary.isEmpty == false {
            diaryTextView.text = diary.title + "\n\n" + diary.body
        }
    }
    
    private func attribute() {
        view.backgroundColor = .systemBackground
    }
    
    private func addSubViews() {
        view.addSubview(diaryTextView)
    }
    
    private func layout() {
        NSLayoutConstraint.activate([
            diaryTextView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            diaryTextView.bottomAnchor.constraint(equalTo: view.keyboardLayoutGuide.topAnchor),
            diaryTextView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            diaryTextView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor)
        ])
    }
}

extension DiaryDetailViewController: UITextViewDelegate {
    func textViewDidBeginEditing(_ textView: UITextView) {
        navigationItem.rightBarButtonItem = UIBarButtonItem(
            title: "완료",
            style: .plain,
            target: self,
            action: #selector(doneButtonDidTap)
        )
    }
    
    @objc
    private func doneButtonDidTap() {
        diaryTextView.resignFirstResponder()
        navigationItem.rightBarButtonItem = nil
    }
}
