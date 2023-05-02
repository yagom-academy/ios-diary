//
//  DiaryDetailViewController.swift
//  Diary
//
//  Created by kimseongjun on 2023/04/25.
//

import UIKit

final class DiaryDetailViewController: UIViewController {
    private let diary: Diary?
    
    init(_ diary: Diary?) {
        self.diary = diary
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private let bodyTextView: UITextView = {
        let textView = UITextView()
        textView.font = .preferredFont(forTextStyle: .body)
        textView.layer.borderWidth = 0.8
        textView.layer.cornerRadius = 4
        textView.textContainerInset = UIEdgeInsets(top: 8, left: 8, bottom: 8, right: 8)
        textView.translatesAutoresizingMaskIntoConstraints = false
        
        return textView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        configureLayout()
        configureNotification()
    }
    
    private func configureUI() {
        view.backgroundColor = .white
        
        if diary == nil {
            self.title = Date.nowDate
            bodyTextView.becomeFirstResponder()
        } else {
            self.title = diary?.timeIntervalSince1970.convertFormattedDate()
            bodyTextView.text = formatContent(diary)
            print("")
        }
    }
    
    private func configureLayout() {
        view.addSubview(bodyTextView)

        let safeArea = view.safeAreaLayoutGuide
        
        NSLayoutConstraint.activate([
            bodyTextView.topAnchor.constraint(equalTo: safeArea.topAnchor, constant: 8),
            bodyTextView.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor, constant: 8),
            bodyTextView.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor, constant: -8),
            bodyTextView.bottomAnchor.constraint(equalTo: safeArea.bottomAnchor, constant: -8)
        ])
    }
    
    private func formatContent(_ diary: Diary?) -> String? {
        guard let title = diary?.title,
              let body = diary?.body else { return nil}
        
        return title + "\n\n" + body
    }
    
    private func configureNotification() {
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(keyboardWillShow),
            name: UIResponder.keyboardWillShowNotification,
            object: nil
        )
        
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(keyboardWillHide),
            name: UIResponder.keyboardWillHideNotification,
            object: nil
        )
    }
    
    @objc private func keyboardWillShow(_ notification: Notification) {
        guard let userInfo = notification.userInfo as NSDictionary?,
              var keyboardFrame = (userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue else {
            return
        }
        keyboardFrame = view.convert(keyboardFrame, from: nil)
        
        bodyTextView.contentInset.bottom = keyboardFrame.size.height
        bodyTextView.scrollIndicatorInsets = bodyTextView.contentInset
    }
    
    @objc private func keyboardWillHide(_ notification: Notification) {
        bodyTextView.contentInset = UIEdgeInsets.zero
        bodyTextView.scrollIndicatorInsets = bodyTextView.contentInset
    }
}
