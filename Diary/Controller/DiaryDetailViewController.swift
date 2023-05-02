//
//  DiaryDetailViewController.swift
//  Diary
//
//  Created by KokkilE, Hyemory on 2023/04/25.
//

import UIKit

final class DiaryDetailViewController: UIViewController {
    private var contents: Contents?
    
    private let textView: UITextView = {
        let textView = UITextView()
        textView.font = .preferredFont(forTextStyle: .body)
        
        return textView
    }()
    
    init(contents: Contents?) {
        self.contents = contents
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureUIOption()
        configureTextView()
        configureLayout()
        addObserver()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        saveContents()
    }
    
    private func configureUIOption() {
        view.backgroundColor = .systemBackground
        navigationItem.title = contents?.localizedDate ?? Date().translateLocalizedFormat()
        
        let deleteAction = UIAction { [weak self] _ in
            guard let contents = self?.contents,
                  let identifier = contents.identifier else { return }
            
            CoreDataManager.shared.delete(id: identifier)
            self?.navigationController?.popToRootViewController(animated: true)
        }
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .edit,
                                                            target: self,
                                                            action: #selector(showActionSheet))
    }
    
    @objc private func showActionSheet() {
        let alert = UIAlertController()
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)
        
        let shareAction = UIAlertAction(title: "Share...", style: .default) {_ in
            print("작업중...")
        }
        
        let deleteAction = UIAlertAction(title: "Delete", style: .destructive) { [weak self] _ in
            self?.showDeleteAlert()
        }
        
        alert.addAction(shareAction)
        alert.addAction(deleteAction)
        alert.addAction(cancelAction)
        
        self.present(alert, animated: true)
    }
    
    private func showDeleteAlert() {
        let alert = UIAlertController(title: "진짜요?", message: "정말로 삭제하시겠어요?", preferredStyle: .alert)
        let cancelAction = UIAlertAction(title: "취소", style: .cancel)
        
        let deleteAction = UIAlertAction(title: "삭제", style: .destructive) { [weak self] _ in
            guard let contents = self?.contents,
                  let identifier = contents.identifier else { return }
            
            CoreDataManager.shared.delete(id: identifier)
            self?.navigationController?.popToRootViewController(animated: true)
        }
        
        alert.addAction(deleteAction)
        alert.addAction(cancelAction)
        
        self.present(alert, animated: true)
    }
    
    private func configureTextView() {
        textView.delegate = self
        
        if let contents {
            textView.text = """
            \(contents.title)
            
            \(contents.body)
            """
        } else {
            textView.text = nil
            textView.becomeFirstResponder()
        }
    }
    
    private func configureLayout() {
        view.addSubview(textView)
        textView.contentOffset = .zero
        textView.translatesAutoresizingMaskIntoConstraints = false
        
        view.keyboardLayoutGuide.followsUndockedKeyboard = true
        
        NSLayoutConstraint.activate([
            view.keyboardLayoutGuide.topAnchor.constraint(equalTo: textView.bottomAnchor),
            
            textView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            textView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            textView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            textView.bottomAnchor.constraint(equalTo: view.keyboardLayoutGuide.topAnchor)
        ])
    }
    
    private func addObserver() {
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(saveContents),
            name: UIScene.didEnterBackgroundNotification,
            object: nil)
    }
}

// MARK: - Data CRUD
extension DiaryDetailViewController {
    @objc private func saveContents() {
        guard contents != nil else {
            createContents()
            return
        }
        
        updateContents()
    }
    
    private func updateContents() {
        let splitedContents = splitContents()
        
        contents?.title = splitedContents.title
        contents?.body = splitedContents.body
        
        guard let contents else { return }
        
        CoreDataManager.shared.update(contents: contents)
    }
    
    private func createContents() {
        let date = Date().timeIntervalSince1970
        let splitedContents = splitContents()
        
        guard splitedContents.title.isEmpty == false else { return }
        
        contents = Contents(title: splitedContents.title,
                            body: splitedContents.body,
                            date: date,
                            identifier: nil)
        
        guard let contents else { return }
        
        CoreDataManager.shared.create(contents: contents)
    }
    
    private func splitContents() -> (title: String, body: String) {
        let splitedText = textView.text.split(separator: "\n", maxSplits: 1)
        var title = ""
        var body = ""
        
        switch splitedText.count {
        case 0:
            break
        case 1:
            title = splitedText[0].description
        default:
            title = splitedText[0].description
            body = splitedText[1].description
        }
        
        return (title, body)
    }
}

// MARK: - Text view delegate
extension DiaryDetailViewController: UITextViewDelegate {
    func textViewDidEndEditing(_ textView: UITextView) {
        saveContents()
    }
}
