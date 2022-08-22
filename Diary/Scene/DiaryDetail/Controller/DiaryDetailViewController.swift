//
//  DiaryDetailViewController.swift
//  Diary
//
//  Created by 재재, 그루트 on 2022/08/18.
//

import UIKit

class DiaryDetailViewController: UIViewController {
    // MARK: - properties
    
    private let diaryDetailView = DiaryDetailView()
    private var diaryDetailData: DiaryTestData?
    
    // MARK: - view life cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        
        configureView()
        configureViewLayout()
        configureDetailViewItem()
        configureKeyboardNotification()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        removeRegisterForKeyboardNotification()
    }
    
    // MARK: - methods
    
    private func configureView() {
        view.addSubview(diaryDetailView)
        navigationItem.title = diaryDetailData?.createdAt.convertDate()
    }
    
    private func configureViewLayout() {
        NSLayoutConstraint.activate([
            diaryDetailView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            diaryDetailView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            diaryDetailView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 8),
            diaryDetailView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -8)
        ])
    }
    
    private func configureDetailViewItem() {
        guard let title = diaryDetailData?.title,
              let body = diaryDetailData?.body else { return }
        
        diaryDetailView.configureDetailTextView(ofText: "\(title)\n\n\(body)")
    }
    
    private func configureKeyboardNotification() {
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(keyBoardShowAction),
                                               name: UIResponder.keyboardWillShowNotification,
                                               object: nil)
        
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(keyboardDownAction),
                                               name: UIResponder.keyboardWillHideNotification,
                                               object: nil)
    }
    
    private func removeRegisterForKeyboardNotification() {
        NotificationCenter.default.removeObserver(self,
                                                  name: UIResponder.keyboardWillShowNotification,
                                                  object: nil)
        
        NotificationCenter.default.removeObserver(self,
                                                  name: UIResponder.keyboardWillHideNotification,
                                                  object: nil)
    }
    
    @objc private func keyBoardShowAction(notification: NSNotification) {
        guard let userInfo: NSDictionary = notification.userInfo as? NSDictionary,
              let keyboardFrame = userInfo.value(forKey: UIResponder.keyboardFrameEndUserInfoKey) as? NSValue
        else { return }
        
        let keyboardRectangle = keyboardFrame.cgRectValue
        let keyboardHeight = keyboardRectangle.height
        
        diaryDetailView.configureDetailTextViewInset(inset: keyboardHeight)
    }
    
    @objc private func keyboardDownAction() {
        view.endEditing(true)
        
        diaryDetailView.configureDetailTextViewInset(inset: 0)
    }
}

// MARK: - extension

extension DiaryDetailViewController: DataSendable {
    func dataTask<T>(data: T) {
        diaryDetailData = data as? DiaryTestData
    }
}
