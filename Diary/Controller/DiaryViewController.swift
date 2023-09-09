//
//  DiaryViewController.swift
//  Diary
//
//  Created by Erick on 2023/08/30.
//

import UIKit

final class DiaryViewController: UIViewController {
    
    // MARK: - Private Property
    private let diaryStore: DiaryStorageProtocol
    private var diaryEntry: DiaryEntry?
    
    private let textView: UITextView = {
        let textView = UITextView()
        textView.translatesAutoresizingMaskIntoConstraints = false
        textView.font = UIFont.preferredFont(forTextStyle: .body)
        textView.addObserveKeyboardNotification()
        
        return textView
    }()
    
    // MARK: - Life Cycle
    init(diaryStore: DiaryStorageProtocol, diaryEntry: DiaryEntry?) {
        self.diaryStore = diaryStore
        self.diaryEntry = diaryEntry
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupContentTextView()
        setupUIObject()
        configureUI()
        setupConstraints()
    }
}

// MARK: - Setup Data
extension DiaryViewController {
    private func setupContentTextView() {
        if let diaryEntry = diaryEntry {
            textView.text = String(format: NameSpace.diaryFormat, diaryEntry.title, diaryEntry.body)
        }
    }
}

// MARK: - Setup UI Object
extension DiaryViewController {
    private func setupUIObject() {
        setupView()
        setupNavigationItem()
        setupTextView()
    }
    
    private func setupView() {
        view.backgroundColor = .systemBackground
    }
    
    private func setupNavigationItem() {
        if diaryEntry == nil {
            let completButton = UIBarButtonItem(title: "완료", style: .plain, target: self, action: nil)
            navigationItem.title = DateFormatManager.dateString(localeDateFormatter: UserDateFormatter.shared)
            navigationItem.rightBarButtonItem = completButton
        } else {
            let moreButton = UIBarButtonItem(image: UIImage(systemName: "ellipsis"), style: .plain, target: self, action: #selector(presentMoreActionSheet))
            navigationItem.title = diaryEntry?.creationDate
            navigationItem.rightBarButtonItem = moreButton
        }
    }
    
    private func setupTextView() {
        textView.delegate = self
        
        if diaryEntry == nil {
            textView.becomeFirstResponder()
        }
    }
}

// MARK: - Push & Present Controller
extension DiaryViewController {
    @objc private func presentMoreActionSheet() {
        let shareAction = UIAlertAction(title: "Share...", style: .default)
        let deleteAction = UIAlertAction(title: "Delete", style: .destructive) { _ in
            self.presentDeleteAlert()
        }
        let cancelAction = UIAlertAction(title: "cancel", style: .cancel)
        let actionSheet = UIAlertController.customAlert(alertTile: nil, alertMessage: nil, preferredStyle: .actionSheet, alertActions: [shareAction, deleteAction, cancelAction])
        
        present(actionSheet, animated: true)
    }
    
    private func presentDeleteAlert() {
        guard let diaryEntry = self.diaryEntry else {
            return
        }
        
        let deleteAction = UIAlertAction(title: "삭제", style: .destructive) { _ in
            self.diaryStore.deleteDiary(diaryEntry)
            self.navigationController?.popViewController(animated: true)
        }
        let cancelAction = UIAlertAction(title: "취소", style: .cancel)
        let alert = UIAlertController.customAlert(alertTile: "진짜요?", alertMessage: "정말로 삭제하시겠어요?", preferredStyle: .alert, alertActions: [cancelAction, deleteAction])
        
        present(alert, animated: true)
    }
    
    private func presentFailedAlert() {
        let alert = UIAlertController.failedAlert(failMessage: "작업에 실패했습니다.")
        
        present(alert, animated: true)
    }
}

// MARK: - TextView Delegate
extension DiaryViewController: UITextViewDelegate {
    func textViewDidEndEditing(_ textView: UITextView) {
        let diaryContents = textView.text.split(separator: "\n")
        
        guard !diaryContents.isEmpty,
              let titleContent = diaryContents.first else {
            return
        }
        
        let title = String(titleContent)
        let body = diaryContents.dropFirst().joined(separator: "\n")
        
        if var diaryEntry {
            diaryEntry.title = title
            diaryEntry.body = body
            diaryStore.updateDiary(diaryEntry)
        } else {
            diaryStore.storeDiary(title: title, body: body)
        }
    }
}

// MARK: - Configure UI
extension DiaryViewController {
    private func configureUI() {
        configureView()
    }
    
    private func configureView() {
        view.addSubview(textView)
    }
}

// MARK: - Setup Constraint
extension DiaryViewController {
    private func setupConstraints() {
        setupTextViewConstraint()
    }
    
    private func setupTextViewConstraint() {
        let safeArea = view.safeAreaLayoutGuide
        
        NSLayoutConstraint.activate([
            textView.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor),
            textView.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor),
            textView.topAnchor.constraint(equalTo: safeArea.topAnchor),
            textView.bottomAnchor.constraint(equalTo: safeArea.bottomAnchor)
        ])
    }
}

// MARK: - Name Space
extension DiaryViewController {
    private enum NameSpace {
        static let diaryFormat = "%@\n%@"
    }
}
