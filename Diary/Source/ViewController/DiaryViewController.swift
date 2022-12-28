//  Diary - DiaryViewController.swift
//  Created by Ayaan, zhilly on 2022/12/21

import UIKit

final class DiaryViewController: UIViewController {
    private let contentTextView = DiaryTextView(font: .preferredFont(forTextStyle: .body),
                                                textAlignment: .left,
                                                textColor: .black)
    private var diary: Diary

    init(diary: Diary) {
        self.diary = diary
        super.init(nibName: nil, bundle: nil)
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configure()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if contentTextView.hasText {
            contentTextView.contentOffset = .zero
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if contentTextView.hasText == false {
            contentTextView.becomeFirstResponder()
        }
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        if contentTextView.hasText == false {
            let diaryDataManager = DiaryDataManager()
            
            diaryDataManager.remove(diary)
        }
    }
    
    private func configure() {
        title = DateFormatter.converted(date: diary.createdAt,
                                        locale: Locale.preference,
                                        dateStyle: .long)
        contentTextView.delegate = self
        contentTextView.keyboardDismissMode = .interactive
        
        setupView()
        setupBarButtonItem()
        setupData()
        setupNotification()
    }
    
    private func setupView() {
        view.backgroundColor = .systemBackground
        view.addSubview(contentTextView)
        contentTextView.translatesAutoresizingMaskIntoConstraints = false

        let safeArea = view.safeAreaLayoutGuide
        
        NSLayoutConstraint.activate([
            contentTextView.topAnchor.constraint(equalTo: safeArea.topAnchor, constant: 8),
            contentTextView.bottomAnchor.constraint(equalTo: view.keyboardLayoutGuide.topAnchor,
                                                    constant: -8),
            contentTextView.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor, constant: 8),
            contentTextView.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor, constant: -8)
        ])
    }
    
    private func setupBarButtonItem() {
        let rightBarButton = UIBarButtonItem(image: UIImage(systemName: "ellipsis"),
                                             style: .plain,
                                             target: self,
                                             action: #selector(tappedDetailButton))
        
        navigationItem.setRightBarButton(rightBarButton, animated: true)
    }
    
    private func setupData() {
        contentTextView.text = diary.content
    }
    
    private func setupNotification() {
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(saveDiary),
                                               name: .didEnterBackground,
                                               object: nil)
    }
    
    private func showDeleteAlert() {
        let alert = UIAlertController(title: "진짜요?",
                                      message: "정말로 삭제 하시겠어요?",
                                      preferredStyle: .alert)
        let deleteAction = UIAlertAction(title: "삭제", style: .destructive) { [weak self] _ in
            self?.deleteDiary()
        }
        let cancelAction = UIAlertAction(title: "취소", style: .cancel)
        
        [cancelAction, deleteAction].forEach { action in
            alert.addAction(action)
        }
        
        present(alert, animated: true)
    }
    
    private func deleteDiary() {
        let diaryDataManager = DiaryDataManager()
        
        diaryDataManager.remove(diary)
        navigationController?.popViewController(animated: true)
    }
    
    private func showShareView() {
        diary.content = contentTextView.text
        let activityViewController = UIActivityViewController(activityItems: [diary.content],
                                                              applicationActivities: nil)
        
        present(activityViewController, animated: true)
    }
    
    @objc
    private func tappedDetailButton() {
        let actionSheet = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        let shareAction = UIAlertAction(title: "Share...", style: .default) { [weak self] _ in
            self?.showShareView()
        }
        let deleteAction = UIAlertAction(title: "Delete", style: .destructive) { [weak self] _ in
            self?.showDeleteAlert()
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)
        
        [shareAction, deleteAction, cancelAction].forEach { action in
            actionSheet.addAction(action)
        }
        
        present(actionSheet, animated: true)
    }
    
    @objc
    private func saveDiary() {
        let diaryDataManager = DiaryDataManager()
        
        diary.content = contentTextView.text
        diaryDataManager.update(diary)
    }
}

extension DiaryViewController: UITextViewDelegate {
    func textViewDidEndEditing(_ textView: UITextView) {
        saveDiary()
    }
}
