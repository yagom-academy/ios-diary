//
//  CreateDiaryViewController.swift
//  Diary
//
//  Created by Maxhyunm, Hamg on 2023/08/29.
//

import UIKit

final class CreateDiaryViewController: UIViewController, AlertDisplayable, ShareDiary {
    private let textView: UITextView = {
        let textView = UITextView()
        textView.translatesAutoresizingMaskIntoConstraints = false
        textView.font = .preferredFont(forTextStyle: .body)
        
        return textView
    }()
    
    private let container = CoreDataManager.shared.persistentContainer
    private var diary: Diary
    private var isNew: Bool
    
    init() {
        self.diary = CoreDataManager.shared.createDiary()
        self.isNew = true
        super.init(nibName: nil, bundle: nil)
    }
    
    init(_ diary: Diary) {
        self.diary = diary
        self.isNew = false
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        setupBodyText()
        setupNavigationBarButton()
        setupNotification()
    }
    
    private func configureUI() {
        view.backgroundColor = .systemBackground
        self.title = DateFormatter().formatToString(from: Date(), with: "YYYY년 MM월 dd일")
        view.addSubview(textView)
        textView.delegate = self
        
        if isNew {
            textView.becomeFirstResponder()
        }
        
        NSLayoutConstraint.activate([
            textView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            textView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            textView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            textView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor)
        ])
    }
    
    private func setupBodyText() {
        guard let title = diary.title,
              let body = diary.body else {
            return
        }
        
        textView.text = "\(title)\n\(body)"
    }
    
    private func setupNavigationBarButton() {
        let moreButton = UIBarButtonItem(title: "더보기", style: .plain, target: self, action: #selector(showMoreOptions))
        navigationItem.rightBarButtonItem = moreButton
    }
    
    private func setupNotification() {
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(keyboardWillShow),
                                               name: UIResponder.keyboardWillShowNotification,
                                               object: nil
        )
        
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(keyboardWillHide),
                                               name: UIResponder.keyboardWillHideNotification,
                                               object: nil
        )
    }
    
    private func showDeleteAlert() {
        let cancelAction = UIAlertAction(title: "취소", style: .cancel)
        let deleteAction = UIAlertAction(title: "삭제", style: .destructive) { [weak self] _ in
            guard let self else { return }
            CoreDataManager.shared.deleteDiary(self.diary)
            self.navigationController?.popViewController(animated: true)
        }
        
        showAlert(title: "진짜요?", message: "정말로 삭제하시겠어요?", actions: [cancelAction, deleteAction])
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
}

extension CreateDiaryViewController {
    @objc private func keyboardWillShow(_ notification: Notification) {
        guard let keyboardFrame = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey]
                as? CGRect else { return }
        
        textView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: keyboardFrame.size.height, right: 0)
    }
    
    @objc private func showMoreOptions() {
        let alertController = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        
        let deleteAction = UIAlertAction(title: "Delete", style: .destructive) { [weak self] _ in
            guard let self else { return }
            self.showDeleteAlert()
        }
        
        let shareAction = UIAlertAction(title: "Share...", style: .default) { [weak self] _ in
            guard let self else { return }
            self.shareDiary(self.diary)
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)
        
        alertController.addAction(shareAction)
        alertController.addAction(deleteAction)
        alertController.addAction(cancelAction)
        
        present(alertController, animated: true)
    }
    
    @objc private func keyboardWillHide(_ notification: Notification) {
        textView.contentInset = .zero
    }
}

extension CreateDiaryViewController: UITextViewDelegate {
    func textViewDidEndEditing(_ textView: UITextView) {
        let contents = textView.text.split(separator: "\n")
        guard !contents.isEmpty else { return }
        
        CoreDataManager.shared.saveContext()
    }
    
    func textViewDidChange(_ textView: UITextView) {
        let contents = textView.text.split(separator: "\n")
        guard !contents.isEmpty,
              let title = contents.first else { return }
        
        let body = contents.dropFirst().joined(separator: "\n")
        
        diary.title = "\(title)"
        diary.body = body
    }
}
