//
//  DiaryViewController.swift
//  Diary
//
//  Created by MINT, BMO on 2023/08/30.
//

import UIKit
import LinkPresentation

final class DiaryViewController: UIViewController {
    // MARK: - Property
    private let diaryService: DiaryService
    private var diary: DiaryEntity
    private let contentTextView: UITextView = {
        let textView = UITextView()
        textView.translatesAutoresizingMaskIntoConstraints = false
        
        return textView
    }()
    
    // MARK: - Initializer
    init (diaryService: DiaryService, diary: DiaryEntity) {
        self.diaryService = diaryService
        self.diary = diary
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    // MARK: - Life cycle method
    override func viewDidLoad() {
        super.viewDidLoad()
        contentTextView.delegate = self
        configureBackgroundColor()
        configureTitle()
        configureNavigationItem()
        configureTextView()
        configureTextViewConstraint()
        fillTextView()
        registerKeyboardListener()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(true)
        writeDiary()
        checkTextStateForSave()
    }
    
    // MARK: - Configure view
    private func configureBackgroundColor() {
        view.backgroundColor = .systemBackground
    }
    
    private func configureTitle() {
        let dateFormatter = DateFormatter()
        
        dateFormatter.configureDiaryDateFormat()
        
        navigationItem.title = dateFormatter.string(from: diary.date)
    }
    
    private func configureNavigationItem() {
        let action = UIAction { [weak self] _ in
            guard let self else {
                return
            }
            
            self.showActionSheet()
        }
        let barButtonItem = UIBarButtonItem.init(
            image: UIImage.init(systemName: "ellipsis.circle"),
            primaryAction: action
        )
        
        navigationItem.rightBarButtonItem = barButtonItem
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
    
    // MARK: - Method
    private func fillTextView() {
        contentTextView.text = diary.title
        
        if let body = diary.body {
            contentTextView.text.append("\n\(body)")
        }
    }
    
    private func writeDiary() {        
        diaryService.write(content: contentTextView.text, to: diary)
    }
    
    private func deleteDiary() {
        diaryService.delete(diary)
        navigationController?.popViewController(animated: true)
    }
    
    private func saveDiary() {
        do {
            try diaryService.saveDiary()
        } catch {
            self.presentDiarySaveFailureAlert()
        }
    }
    
    private func registerKeyboardListener() {
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(keyboardWillHide(_:)),
            name: UIResponder.keyboardWillHideNotification,
            object: nil
        )
    }
    
    @objc private func keyboardWillHide(_ notification: Notification) {
        writeDiary()
        saveDiary()
    }
    
    private func checkTextStateForSave() {
        if contentTextView.text == "" {
            deleteDiary()
        } else {
            saveDiary()
        }
    }
}

// MARK: - UITextViewDelegate
extension DiaryViewController: UITextViewDelegate {
    func textViewDidChange(_ textView: UITextView) {
        writeDiary()
    }
}

// MARK: - DiaryShareable, DiaryAlertPresentable
extension DiaryViewController: DiaryShareable, DiaryAlertPresentable {
    private func showActionSheet() {
        let sheet = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        let shareAction = UIAlertAction(title: String(localized: "Share"), style: .default) { [weak self] _ in
            guard let self else {
                return
            }
            
            self.shareDiary(data: self.diary)
        }
        let deleteAction = UIAlertAction(title: String(localized: "Delete"), style: .destructive) { [weak self] _ in
            guard let self else {
                return
            }
            
            self.presentDeleteConfirmAlert(by: { self.deleteDiary()})
        }
        let cancelAction = UIAlertAction(title: String(localized: "Cancel"), style: .cancel)
        
        sheet.addAction(shareAction)
        sheet.addAction(deleteAction)
        sheet.addAction(cancelAction)
        
        present(sheet, animated: true)
    }
}
