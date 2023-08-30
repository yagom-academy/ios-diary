//
//  NewDiaryViewController.swift
//  Diary
//
//  Created by idinaloq, yetti on 2023/08/30.
//

import UIKit

final class NewDiaryViewController: UIViewController {
    private let textView: UITextView = {
        let view: UITextView = UITextView()
        view.translatesAutoresizingMaskIntoConstraints = false
        
        return view
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureNavigation()
        configureUI()
        configureLayout()
        setUpKeyboardEvent()
    }

    private func configureNavigation() {
        navigationItem.title = DateFormatter.today
    }
    
    private func configureUI() {
        view.addSubview(textView)
        view.backgroundColor = .systemBackground
    }
    
    private func configureLayout() {
        let safeArea = view.safeAreaLayoutGuide
        NSLayoutConstraint.activate([
            textView.topAnchor.constraint(equalTo: safeArea.topAnchor),
            textView.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor),
            textView.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor),
            textView.bottomAnchor.constraint(equalTo: safeArea.bottomAnchor)
        ])
    }
    
    private func setUpKeyboardEvent() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    @objc private func keyboardWillShow(_ notification: Notification) {
        guard let userInfo = notification.userInfo as NSDictionary?,
              var keyboardFrame = (userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue else {
            return
        }
        
        var contentInset = textView.contentInset
        keyboardFrame = view.convert(keyboardFrame, from: nil)
        contentInset.bottom = keyboardFrame.size.height
        textView.contentInset = contentInset
        textView.verticalScrollIndicatorInsets = textView.contentInset
    }
    
    @objc private func keyboardWillHide() {
        textView.contentInset = UIEdgeInsets.zero
        textView.verticalScrollIndicatorInsets = textView.contentInset
    }
}
