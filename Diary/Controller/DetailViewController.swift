//
//  DetailViewController.swift
//  Diary
//
//  Copyright (c) 2022 woong, jeremy All rights reserved.
    

import UIKit

final class DetailViewController: UIViewController {

    @IBOutlet weak private var detailTextViewBottomConstraint: NSLayoutConstraint!
    @IBOutlet weak private var detailTextView: UITextView!
    var diaryData: SampleData?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureView()
        addNotificationObserver()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        removeNotificationObserver()
    }
    
    private func configureView() {
        guard let data = diaryData else { return }
        self.navigationItem.title = data.createdAt.convertDate()
        self.detailTextView.text = "\(data.title)\n\n\(data.body)"
    }
    
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
        guard let userinfo = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue else { return }
        let keyboardHeight = userinfo.cgRectValue.height
        detailTextViewBottomConstraint.constant = isAppearing ? keyboardHeight : .zero
    }
}
