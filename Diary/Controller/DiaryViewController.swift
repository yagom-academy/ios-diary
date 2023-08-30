//
//  DiaryViewController.swift
//  Diary
//
//  Created by redmango1446 on 2023/08/30.
//

import UIKit

class DiaryViewController: UIViewController {
    
    var textView = UITextView()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = "TEST"
        configureTextField()
        NotificationCenter.default.addObserver(self, selector: #selector(keybordWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keybordWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    @objc func keybordWillShow(_ notification: Notification) {
        if let keyboardFrame = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect {
            let keyboardHeight = keyboardFrame.size.height
            textView.contentInset.bottom = keyboardHeight
        }
    }
    
    @objc func keybordWillHide() {
        textView.contentInset = .zero
    }
    
    func configureTextField() {
        view.addSubview(textView)
        textView.translatesAutoresizingMaskIntoConstraints = false
        textView.font = UIFont.preferredFont(forTextStyle: .body)
        NSLayoutConstraint.activate([
            textView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            textView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            textView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            textView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
    }
    
}
