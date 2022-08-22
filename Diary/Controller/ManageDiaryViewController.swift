//
//  AddDiaryViewController.swift
//  Diary
//
//  Created by 백곰, 주디 on 2022/08/17.
//

import UIKit

enum ViewMode {
    case add
    case edit
}

final class ManageDiaryViewController: UIViewController {
    private let manageDiaryView = ManageDiaryView()
    private var viewMode: ViewMode = .add
    private var id = UUID()
    
    override func loadView() {
        super.loadView()
        view = manageDiaryView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        addNotificationObserver()
        checkViewMode()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        if viewMode == .add {
            saveDiary()
        }
    }
    
    func getDiaryData(data: DiaryItem) {
        let content = data.title + data.body
        manageDiaryView.fetchBodyTextView(content)
        id = data.id
        viewMode = .edit
        self.navigationItem.title = DateManager().formatted(date: Date(timeIntervalSince1970: data.createdAt))
    }
    
    private func checkViewMode() {
        switch viewMode {
        case .add:
            self.navigationItem.title = DateManager().formatted(date: Date())
            manageDiaryView.focusBodyTextView()
        case .edit:
            let optionButton = UIBarButtonItem(image: UIImage(systemName: "ellipsis"), style: .plain, target: self, action: #selector(optionButtonDidTapped))
            navigationItem.rightBarButtonItem = optionButton
        }
    }
    
    @objc func saveDiary() {
        guard let diary = manageDiaryView.convertDiaryItem(with: id) else { return }
        CoreDataManager.shared.saveDiary(item: diary)
    }
    
    private func addNotificationObserver() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(saveDiary), name: UIApplication.willResignActiveNotification, object: nil)
    }
    
    @objc private func optionButtonDidTapped() {
        let optionAlert = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        let shareAction = UIAlertAction(title: "Share...", style: .default) { _ in
            
        }
        let deleteAction = UIAlertAction(title: "Delete", style: .destructive) { _ in
            
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)
        
        [shareAction, deleteAction, cancelAction].forEach {
            optionAlert.addAction($0)
        }
        
        self.present(optionAlert, animated: true)
    }
    
    @objc private func keyboardWillShow(_ notification: Notification) {
        guard let userInfo = notification.userInfo,
              let keyboardFrame = userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect else { return }
        
        manageDiaryView.adjustContentInset(height: keyboardFrame.size.height)
    }
    
    @objc private func keyboardWillHide() {
        manageDiaryView.adjustContentInset(height: 0)
        saveDiary()
    }
}
