//
//  DiaryViewController.swift
//  Diary
//
//  Created by unchain, 웡빙 on 2022/08/17.
//

import UIKit

class DiaryViewController: UIViewController {
    private var diaryView: DiaryView?

    override func viewDidLoad() {
        super.viewDidLoad()
        setupInitialView()
        setupNavigationTitle()
        setupKeyboard()
        diaryView?.diaryTextView.delegate = self
    }
    
    private func setupInitialView() {
        self.view.backgroundColor = .systemBackground
        diaryView = DiaryView(self)
    }
    
    private func setupNavigationTitle() {
        let now = Date()
        self.navigationItem.title = now.timeIntervalSince1970.translateToDate()
    }
    
    private func setupKeyboard() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillAppear), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillDisAppear), name: UIResponder.keyboardWillHideNotification, object: nil)
        diaryView?.closeButton.addTarget(self, action: #selector(hideKeyboard), for: .touchUpInside)
    }
    
    @objc func keyboardWillAppear(_ sender: Notification) {
        guard let userInfo = sender.userInfo, let keyboardFrame = userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect else { return }
        let contentInset = UIEdgeInsets(top: 0.0, left: 0.0, bottom: keyboardFrame.size.height, right: 0.0)
        diaryView?.diaryTextView.contentInset = contentInset
        diaryView?.diaryTextView.scrollIndicatorInsets = contentInset
    }
    
    @objc func keyboardWillDisAppear(_ sender: Notification) {
        let contentInset = UIEdgeInsets.zero
        diaryView?.diaryTextView.contentInset = contentInset
        diaryView?.diaryTextView.scrollIndicatorInsets = contentInset
    }
    
    @objc func hideKeyboard(_ sender: Any) {
        view.endEditing(true)
    }
}

extension DiaryViewController: UITextViewDelegate {
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if text == "\n" {
            textView.typingAttributes = [NSAttributedString.Key.font: UIFont.preferredFont(forTextStyle: .body)]
        }
        return true
    }
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.text == diaryView?.placeHolder {
            textView.text = nil
            textView.textColor = .black
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
            textView.text = diaryView?.placeHolder
            textView.textColor = .lightGray
        }
    }
    
}
