//
//  AddDiaryViewController.swift
//  Diary
//
//  Created by 백곰, 주디 on 2022/08/17.
//

import UIKit

final class AddDiaryViewController: UIViewController {
    private let addDiaryView = AddDiaryView()
    
    override func loadView() {
        super.loadView()
        view = addDiaryView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        addNotificationObserver()
        self.navigationItem.title = DateManager().formatted(date: Date())
    }
    
    private func addNotificationObserver() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    @objc private func keyboardWillShow(_ notification: Notification) {
        guard let userInfo = notification.userInfo,
              let keyboardFrame = userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect else { return }
        
        addDiaryView.adjustContentInset(height: keyboardFrame.size.height)
    }
    
    @objc private func keyboardWillHide() {
        addDiaryView.adjustContentInset(height: 0)
    }
}
