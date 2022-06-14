//
//  RegisterViewController.swift
//  Diary
//
//  Created by 김태현 on 2022/06/14.
//

import UIKit

final class RegisterViewController: UIViewController {
    enum Constant {
        static let backButton = "일기장"
    }
    
    private let textView = UITextView()
    private var bottonContraint: NSLayoutConstraint?
    
    override func viewDidLoad() {
        view.backgroundColor = .systemBackground
        setUpNavigationController()
        setUpTextViewLayout()
        setUpKeyboardNotification()
    }
    
    private func setUpNavigationController() {
        func setUpLeftItem() {
            let button = UIButton()
            let barButton = UIBarButtonItem(customView: button)
            
            button.setImage(UIImage(systemName: "chevron.left"), for: .normal)
            button.setTitle("일기장", for: .normal)
            button.titleLabel?.font = UIFont.systemFont(ofSize: 15, weight: .semibold)
            button.setTitleColor(.systemBlue, for: .normal)
            button.addTarget(self, action: #selector(registerDiary), for: .touchUpInside)
            
            navigationItem.leftBarButtonItem = barButton
        }
        
        navigationItem.title = Formatter.getCurrentDate()
        setUpLeftItem()
    }
    
    @objc private func registerDiary() {
        dismiss(animated: true)
    }
    
    private func setUpTextViewLayout() {
        view.addSubview(textView)
        
        textView.translatesAutoresizingMaskIntoConstraints = false
        
        bottonContraint = textView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        
        NSLayoutConstraint.activate([
            textView.topAnchor.constraint(equalTo: view.topAnchor),
            textView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            textView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            bottonContraint
        ].compactMap { $0 })
    }
    
    private func setUpKeyboardNotification() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillAppear), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    @objc private func keyboardWillAppear(_ notification: Notification) {
        guard let keyboardBounds = notification.userInfo?["UIKeyboardBoundsUserInfoKey"] as? NSValue else { return }

        bottonContraint?.constant = -keyboardBounds.cgRectValue.height
    }
    
    @objc private func keyboardWillHide() {
        bottonContraint?.constant = .zero
    }
}
