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
        if viewMode == .add {
            self.navigationItem.title = DateManager().formatted(date: Date())
            manageDiaryView.focusBodyTextView()
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
    
    @objc private func keyboardWillShow(_ notification: Notification) {
        guard let userInfo = notification.userInfo,
              let keyboardFrame = userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect else { return }
        
        manageDiaryView.adjustContentInset(height: keyboardFrame.size.height)
    }
    
    @objc private func keyboardWillHide() {
        manageDiaryView.adjustContentInset(height: 0)
    }
    
}
