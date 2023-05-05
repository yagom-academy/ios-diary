//
//  DiaryDetailViewController.swift
//  Diary
//
//  Created by kaki, 레옹아범 on 2023/04/25.
//

import UIKit

final class DiaryDetailViewController: UIViewController {
    private let diaryTextView: UITextView = {
        let textView = UITextView()
        textView.font = UIFont.preferredFont(forTextStyle: .body)
        textView.translatesAutoresizingMaskIntoConstraints = false
        
        return textView
    }()
    private var diaryItem: Diary?
    private var state: DiaryState
    private let manager = PersistenceManager.shared
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureUI()
        configureInitailView()
        setupNotification()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        if state == .create {
            diaryTextView.becomeFirstResponder()
        }
    }
    
    init(diaryItem: Diary? = nil, state: DiaryState) {
        self.diaryItem = diaryItem
        self.state = state
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configureInitailView() {
        guard let diaryItem = diaryItem else {
            self.navigationItem.title = Date.convertToDate(by: Date().timeIntervalSince1970)
            
            return
        }
        
        self.navigationItem.title = Date.convertToDate(by: diaryItem.date)
        self.diaryTextView.text = diaryItem.content
    }
    
    private func setupNotification() {
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(endEditingDiary),
                                               name: UIScene.didEnterBackgroundNotification,
                                               object: nil)
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(endEditingDiary),
                                               name: UIResponder.keyboardWillHideNotification,
                                               object: nil)
    }
    
    @objc private func endEditingDiary() {
        if diaryTextView.text.isEmpty { return }
        
        let content = diaryTextView.text
        
        switch state {
        case .create:
            do {
                let date = Date().timeIntervalSince1970
                diaryItem = try manager.createContent(content, date)
                state = .edit
            } catch {
                showFailAlert(error: error)
            }
        case .edit:
            guard let diary = diaryItem else { return }
            
            do {
                try manager.updateContent(at: diary, content)
            } catch {
                showFailAlert(error: error)
            }
        case .delete:
            return
        }
    }
    
    @objc private func doneButtonTapped(sender: Any) {
        self.view.endEditing(true)
    }
}

// MARK: UI
extension DiaryDetailViewController {
    private func configureUI() {
        view.backgroundColor = .systemBackground
        
        configureTextView()
        configureNavigationController()
    }
    
    private func configureNavigationController() {
        let image = UIImage(systemName: "ellipsis.circle")
        let rightItem = UIBarButtonItem(image: image,
                                        style: .plain,
                                        target: self,
                                        action: #selector(showActionSheet))
        
        navigationItem.rightBarButtonItem = rightItem
    }
    
    private func configureTextView() {
        self.view.addSubview(diaryTextView)
        diaryTextView.addDoneButton(title: "Done",
                                    target: self,
                                    selector: #selector(doneButtonTapped))
        
        NSLayoutConstraint.activate([
            diaryTextView.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor),
            diaryTextView.leadingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leadingAnchor),
            diaryTextView.trailingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.trailingAnchor),
            diaryTextView.bottomAnchor.constraint(equalTo: self.view.keyboardLayoutGuide.topAnchor)
        ])
    }
    
    func showDeleteAlert() {
        let alert = UIAlertController(title: "진짜요?",
                                      message: "정말로 삭제하시겠어요?",
                                      preferredStyle: .alert)
        let cancelAction = UIAlertAction(title: "취소", style: .default)
        let deleteAction = UIAlertAction(title: "삭제", style: .destructive) { [weak self] _ in
            guard let diaryItem = self?.diaryItem else { return }
            
            do {
                try self?.manager.deleteContent(at: diaryItem)
                self?.state = .delete
                self?.navigationController?.popViewController(animated: true)
            } catch {
                self?.showFailAlert(error: error)
            }
        }
        
        alert.addAction(cancelAction)
        alert.addAction(deleteAction)
        present(alert, animated: true)
    }
    
    @objc private func showActionSheet() {
        self.view.endEditing(true)
        
        let alertController = UIAlertController(title: nil,
                                                message: nil,
                                                preferredStyle: .actionSheet)
        let shareAction = UIAlertAction(title: "Share...", style: .default) { [weak self] _ in
            guard let text = self?.diaryItem?.content else { return }
            
            self?.showActivityView(text)
        }
        let deleteAction = UIAlertAction(title: "Delete", style: .destructive) { [weak self] _ in
            self?.showDeleteAlert()
        }
        let cancelAction = UIAlertAction(title: "Cancle", style: .cancel)
        
        alertController.addAction(shareAction)
        alertController.addAction(deleteAction)
        alertController.addAction(cancelAction)
        present(alertController, animated: true)
    }
}

fileprivate extension UITextView {
    func addDoneButton(title: String, target: Any, selector: Selector) {
        let toolBar = UIToolbar(frame: CGRect(x: 0.0,
                                              y: 0.0,
                                              width: UIScreen.main.bounds.size.width,
                                              height: 44.0))
        let flexible = UIBarButtonItem(barButtonSystemItem: .flexibleSpace,
                                       target: nil,
                                       action: nil)
        let barButton = UIBarButtonItem(title: title,
                                        style: .plain,
                                        target: target,
                                        action: selector)
        
        toolBar.setItems([flexible, barButton], animated: false)
        
        self.inputAccessoryView = toolBar
    }
}
