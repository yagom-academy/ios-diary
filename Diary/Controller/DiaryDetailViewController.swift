//
//  DiaryDetailViewController.swift
//  Diary
//
//  Created by KokkilE, Hyemory on 2023/04/25.
//

import UIKit

final class DiaryDetailViewController: UIViewController {
    private let contents: Contents?
        
    private let textView: UITextView = {
        let textView = UITextView()
        textView.font = .preferredFont(forTextStyle: .body)

        return textView
    }()
    
    init(contents: Contents?) {
        self.contents = contents
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureUIOption()
        configureLayout()
        addKeyboardObserver()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        removeKeyboardObserver()
    }
    
    private func addKeyboardObserver() {
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(keyboardWillShow(notification: )),
            name: UIResponder.keyboardWillShowNotification, object: nil
        )
        
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(keyboardWillHide),
            name: UIResponder.keyboardDidHideNotification, object: nil
        )
    }
    
    private func removeKeyboardObserver() {
        NotificationCenter.default.removeObserver(
            self,
            name: UIResponder.keyboardWillShowNotification,
            object: nil
        )
        
        NotificationCenter.default.removeObserver(
            self,
            name: UIResponder.keyboardDidHideNotification,
            object: nil
        )
    }
    
    @objc private func keyboardWillShow(notification: Notification) {
        guard let userInfo = notification.userInfo,
              let keyboardFrameValue = userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue else {
            return
        }
        let keyboardHeight = keyboardFrameValue.cgRectValue.height
        
        textView.contentInset.bottom = keyboardHeight
        textView.verticalScrollIndicatorInsets.bottom = keyboardHeight
    }
    
    @objc private func keyboardWillHide() {
        textView.contentInset.bottom = .zero
        textView.verticalScrollIndicatorInsets.bottom = .zero
    }
    
    private func configureLayout() {
        view.addSubview(textView)
        textView.contentOffset = .zero
        textView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            textView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            textView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            textView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            textView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }
    
    private func configureUIOption() {
        view.backgroundColor = .systemBackground
        
        navigationItem.title = contents?.localizedDate ?? Date().translateLocalizedFormat()
        
        if let contents {
            textView.text = """
            \(contents.title)
            
            \(contents.description)
            """
        } else {
            textView.text = .none
        }
    }
}
