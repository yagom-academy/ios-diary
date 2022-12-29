//
//  DetailViewController.swift
//  Diary
//
//  Copyright (c) 2022 woong, jeremy All rights reserved.
//

import UIKit


final class DetailViewController: UIViewController {
    @IBOutlet weak private var detailTextViewBottomConstraint: NSLayoutConstraint!
    @IBOutlet weak private var detailTextView: UITextView!
    // 타이틀,바디가 isEmpty면, textView에서 Placeholder를 표기(create).

    var diaryData: DiaryData?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureView()
        addNotificationObserver()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        removeNotificationObserver()
    }
    
    private func configureView() {
        guard let diaryData = diaryData,
              let title = diaryData.title,
              let body = diaryData.body else { return }
        navigationItem.title = diaryData.createdAt.convertDate()
        detailTextView.text = "\(title)\n\n\(body)"
    }
}

// MARK: - Notification: handled keyboard Method

extension DetailViewController {
    private func addNotificationObserver() {
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(keyboardWillShow(_ :)),
                                               name: UIResponder.keyboardWillShowNotification,
                                               object: nil)
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(keyboardWillHide(_ :)),
                                               name: UIResponder.keyboardWillHideNotification,
                                               object: nil)
    }
    
    private func removeNotificationObserver() {
        NotificationCenter.default.removeObserver(self,
                                                  name: UIResponder.keyboardWillShowNotification,
                                                  object: nil)
        NotificationCenter.default.removeObserver(self,
                                                  name: UIResponder.keyboardWillHideNotification,
                                                  object: nil)
    }
    
    @objc
    private func keyboardWillShow(_ notification: Notification) {
        handleScrollView(notification, isAppearing: true)
    }
    
    @objc
    private func keyboardWillHide(_ notification: Notification) {
        handleScrollView(notification, isAppearing: false)
    }
    
    private func handleScrollView(_ notification: Notification, isAppearing: Bool) {
        guard let userinfo = notification.userInfo,
              let keyboardFrame = userinfo[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue
        else {
            return
        }
        let keyboardHeight = keyboardFrame.cgRectValue.height
        detailTextViewBottomConstraint.constant = isAppearing ? keyboardHeight : .zero
    }
}

// MARK: - extnesion: seperate detailTextView Title & Body

fileprivate extension String {
    func seperateTitleAndBody(titleWordsLimit: Int) -> (title: String, body: String) {
        var components = components(separatedBy: "\n\n")
        if components.count > 1 {
            let title = components.removeFirst()
            let body = components.filter { $0 != ""}.joined(separator: "\n\n")
            return (title, body)
        }
        let limitIndex = index(startIndex, offsetBy: titleWordsLimit)
        let title = self[startIndex..<limitIndex]
        let body = self[limitIndex..<endIndex]
        
        return (title.description, body.description)
    }
}
