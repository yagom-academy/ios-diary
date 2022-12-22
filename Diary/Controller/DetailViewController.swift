//
//  DetailViewController.swift
//  Diary
//
//  Copyright (c) 2022 woong, jeremy All rights reserved.
//

import UIKit

protocol DetailViewControllerDelegate: AnyObject {
    func sendData(title: String, body: String, indexPath: IndexPath)
}

final class DetailViewController: UIViewController {
    
    @IBOutlet weak private var detailTextViewBottomConstraint: NSLayoutConstraint!
    @IBOutlet weak private var detailTextView: UITextView!
    var diaryData: SampleData?
    var indexPath: IndexPath?
    weak var delegate: DetailViewControllerDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureView()
        addNotificationObserver()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        removeNotificationObserver()
        shareChangedData()
    }
    
    private func shareChangedData() {
        guard let indexPath = indexPath else { return }
        let data = detailTextView.text.parseData(titleWordsLimit: 20)
        delegate?.sendData(title: data.title,
                           body: data.body,
                           indexPath: indexPath)
    }
    
    private func configureView() {
        guard let data = diaryData else { return }
        self.navigationItem.title = data.createdAt.convertDate()
        self.detailTextView.text = "\(data.title)\n\n\(data.body)"
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
