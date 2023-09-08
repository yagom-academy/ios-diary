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
    private let container: PersistentContainer
    private var diary: DiaryEntity?
    private let indexPath: IndexPath?
    private let contentTextView: UITextView = {
        let textView = UITextView()
        textView.translatesAutoresizingMaskIntoConstraints = false
        return textView
    }()
    
    // MARK: - Initializer
    init(diary: DiaryEntity? = nil, container: PersistentContainer, indexPath: IndexPath? = nil) {
        self.diary = diary
        self.container = container
        self.indexPath = indexPath
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
        if contentTextView.text == "" {
            deleteDiary()
        } else {
            saveDiary()
        }
    }
    
    // MARK: - Configure view
    private func configureBackgroundColor() {
        view.backgroundColor = .systemBackground
    }
    
    private func configureTitle() {
        var date = Date()
        
        if let diary {
            date = diary.date
        }
        
        let dateFormatter = DateFormatter()
        
        dateFormatter.configureDiaryDateFormat()
        navigationItem.title = dateFormatter.string(from: date)
    }
    
    private func configureNavigationItem() {
        let action = UIAction {_ in
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
        guard let diary else {
            return
        }
        
        contentTextView.text = diary.title + "\n" + (diary.body ?? "")
    }
    
    private func writeDiary() {
        if diary == nil {
            diary = DiaryEntity(context: container.viewContext)
            diary?.id = UUID()
            diary?.date = Date()
        }
        
        diary?.title = contentTextView.text.components(separatedBy: "\n")[0]
        
        if let range = contentTextView.text.range(of: "\n") {
            let body = contentTextView.text[range.upperBound...]
            diary?.body = String(body)
        }
    }
    
    private func deleteDiary() {
        guard let diary else { return }
        
        self.container.viewContext.delete(diary)
        navigationController?.popViewController(animated: true)
    }
    
    private func shareDiary() {
        guard let diary else {
            return
        }
        
        let textToShare: [Any] = [MyActivityItemSource(diary: diary)]
        let activityViewController = UIActivityViewController(
            activityItems: textToShare,
            applicationActivities: nil
        )
        
        activityViewController.popoverPresentationController?.sourceView = self.view
        self.present(activityViewController, animated: true, completion: nil)
    }
    
    private func deleteDiary() {
        guard let diary else {
            return
        }
        
        self.container.viewContext.delete(diary)
        navigationController?.popViewController(animated: true)
    }
    
    private func saveDiary() {
        container.saveContext()
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
}

// MARK: - UITextViewDelegate
extension DiaryViewController: UITextViewDelegate {
    func textViewDidChange(_ textView: UITextView) {
        writeDiary()
    }
}

extension DiaryViewController: DiaryShareable, DiaryAlertPresentable {
    private func showActionSheet() {
        let sheet = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        let shareAction = UIAlertAction(title: "Share...", style: .default) { _ in
            self.shareDiary(data: self.diary, in: self)
        }
        let deleteAction = UIAlertAction(title: "Delete", style: .destructive) { _ in
            self.showDeleteConfirmAlert(in: self, by: { self.deleteDiary()})
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)
        
        sheet.addAction(shareAction)
        sheet.addAction(deleteAction)
        sheet.addAction(cancelAction)
        
        present(sheet, animated: true)
    }
}
