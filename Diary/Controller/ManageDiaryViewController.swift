//
//  AddDiaryViewController.swift
//  Diary
//
//  Created by 백곰, 주디 on 2022/08/17.
//

import UIKit

enum ViewMode {
    case edit
    case add
}

final class ManageDiaryViewController: UIViewController {
    private let manageDiaryView = ManageDiaryView()
    private var viewMode: ViewMode = .add
    
    override func loadView() {
        super.loadView()
        view = manageDiaryView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        addNotificationObserver()
        configureAddViewMode()
    }
    
    private func configureAddViewMode() {
        if viewMode == .add {
            self.navigationItem.title = DateManager().formatted(date: Date())
            manageDiaryView.focusBodyTextView()
            let optionButton = UIBarButtonItem(image: UIImage(systemName: "ellipsis"), style: .plain, target: self, action: #selector(optionButtonDidTapped))
            navigationItem.rightBarButtonItem = optionButton
        }
    }
    
    func getDiaryData(data: Diary) {
        let content = data.title + "\n\n" + data.body
        manageDiaryView.fetchBodyTextView(content)
        viewMode = .edit
        self.navigationItem.title = DateManager().formatted(date: Date(timeIntervalSince1970: data.createdAt))
    }
    
    private func addNotificationObserver() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
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
    }
    
}
