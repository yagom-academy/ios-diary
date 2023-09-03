//
//  DiaryViewController.swift
//  Diary
//
//  Created by Redmango, Minsup on 2023/08/30.
//

import UIKit

final class DiaryViewController: UIViewController {
    
    // MARK: - Private Property
    
    private var textView = UITextView()
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureNavigation()
        configureTextView()
        registerNotification()
    }
    
    private func configureNavigation() {
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .long
        dateFormatter.locale = .current
        
        self.navigationItem.title = dateFormatter.string(from: Date())        
    }
    
    // MARK: - Private Method(TextView)
    
    private func configureTextView() {
        setupTextView()
        constraintTextView()
    }
    
    private func setupTextView() {
        view.addSubview(textView)
        textView.font = UIFont.preferredFont(forTextStyle: .body)
    }
    
    private func constraintTextView() {
        textView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            textView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            textView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            textView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            textView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
    }
    
    // MARK: - Private Method(Keyboard Notification)
    
    private func registerNotification() {
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
}
