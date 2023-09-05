//
//  CreateDiaryViewController.swift
//  Diary
//
//  Created by Maxhyunm, Hamg on 2023/08/29.
//

import UIKit

final class CreateDiaryViewController: UIViewController {
    private let textView: UITextView = {
        let textView = UITextView()
        textView.translatesAutoresizingMaskIntoConstraints = false
        textView.font = .preferredFont(forTextStyle: .body)
        
        return textView
    }()
    
    weak var delegate: DiaryListDelegate?
    private let container = CoreDataManager.shared.persistentContainer
    var diary: Diary?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        setupNavigationBarButton()
        setupDiaryData()
        setupNotification()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        saveDiary()
        delegate?.readCoreData()
    }
    
    private func configureUI() {
        view.backgroundColor = .systemBackground
        self.title = DateFormatter().formatToString(from: Date(), with: "YYYY년 MM월 dd일")
        
        view.addSubview(textView)
        
        NSLayoutConstraint.activate([
            textView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            textView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            textView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            textView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor)
        ])
    }
    
    private func setupNavigationBarButton() {
        let moreButton = UIBarButtonItem(title: "더보기", style: .plain, target: self, action: #selector(showMoreOptions))
        navigationItem.rightBarButtonItem = moreButton
    }
    
    private func setupDiaryData() {
        if let diaryEdit = diary {
            textView.text = "\(diaryEdit.title ?? "")\n\(diaryEdit.body ?? "")"
        } else {
            diary = CoreDataManager.shared.createDiary()
        }
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
        let alertController = UIAlertController(title: "진짜요?", message: "정말로 삭제하시겠어요?", preferredStyle: .alert)
        
        let cancelAction = UIAlertAction(title: "취소", style: .cancel)
        let deleteAction = UIAlertAction(title: "삭제", style: .destructive) { [weak self] _ in
            guard let self else { return }
            CoreDataManager.shared.deleteDiary(self.diary)
            self.delegate?.readCoreData()
            self.navigationController?.popViewController(animated: true)
        }
        
        alertController.addAction(cancelAction)
        alertController.addAction(deleteAction)
        
        present(alertController, animated: true)
    }
    
    private func saveDiary() {
        let contents = textView.text.split(separator: "\n")
        guard !contents.isEmpty,
              let title = contents.first else { return }
        
        let body = contents.dropFirst().joined(separator: "\n")
        
        CoreDataManager.shared.saveDiary(title: "\(title)", body: body, diary: diary)
    }
    
    private func deleteDiary(_ diary: Diary?) {
        CoreDataManager.shared.deleteDiary(diary)
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
            self.delegate?.shareDiary(self.diary)
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)
        
        alertController.addAction(shareAction)
        alertController.addAction(deleteAction)
        alertController.addAction(cancelAction)
        
        present(alertController, animated: true)
    }
    
    @objc private func keyboardWillHide(_ notification: Notification) {
        textView.contentInset = .zero
        saveDiary()
    }
}
