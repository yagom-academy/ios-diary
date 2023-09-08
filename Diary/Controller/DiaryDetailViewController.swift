//
//  DiaryDetailViewController.swift
//  Diary
//
//  Created by hoon, karen on 2023/08/30.
//

import UIKit
import CoreData

final class DiaryDetailViewController: UIViewController {
    private let diary: Diary
    private let isUpdate: Bool
    
    private let contentTextView = {
        let textView = UITextView()
        textView.isEditable = true
        textView.adjustsFontForContentSizeCategory = true
        textView.font = .preferredFont(forTextStyle: .body)
        textView.translatesAutoresizingMaskIntoConstraints = false
        textView.addDoneButtonOnKeyboard()

        return textView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configure()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        saveDiary()
    }
    
    init(diary: Diary, isUpdate: Bool = true) {
        self.diary = diary
        self.isUpdate = isUpdate
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension DiaryDetailViewController: UITextViewDelegate {
    func textViewDidEndEditing(_ textView: UITextView) {
        saveDiary()
    }
    
    func textViewDidChange(_ textView: UITextView) {
        saveDiary()
    }
}

private extension DiaryDetailViewController {
    func saveDiary() {
        guard !contentTextView.text.isEmpty else {
            CoreDataManager.shared.deleteDiary(item: diary)
            return
        }
        
        let contents = contentTextView.text.split(separator: "\n")
        let title = String(contents[0])
        let body = contents.dropFirst().joined(separator: "\n")

        if contents.isEmpty {
            saveContents(title: "", body: "")
        } else {
            saveContents(title: title, body: body)
        }
    }
    
    func saveContents(title: String, body: String) {
        diary.setValue(title, forKeyPath: "title")
        diary.setValue(body, forKeyPath: "body")
        CoreDataManager.shared.updateDiary()
    }
}

private extension DiaryDetailViewController {
    func configure() {
        configureRootView()
        configureTextView()
        configureNavigation()
        configureSubviews()
        configureContents()
        configureKeyboard()
        configureConstraints()
    }
    
    func configureRootView() {
        view.backgroundColor = .systemBackground
    }
    
    func configureTextView() {
        contentTextView.delegate = self
    }
    
    func configureNavigation() {
        navigationItem.title = DateFormatter.diaryFormatter.string(from: diary.date ?? Date())
    }
    
    func configureSubviews() {
        view.addSubview(contentTextView)
    }
    
    func configureContents() {
        guard isUpdate else {
            return
        }
        
        let title = diary.title ?? ""
        let body = diary.body ?? ""
        contentTextView.text = title + "\n" + body
    }
    
    func configureKeyboard() {
        if !isUpdate {
            contentTextView.becomeFirstResponder()
        }
    }
    
    func configureConstraints() {
        NSLayoutConstraint.activate([
            contentTextView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            contentTextView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            contentTextView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            contentTextView.bottomAnchor.constraint(equalTo: view.keyboardLayoutGuide.topAnchor)
        ])
    }
}
