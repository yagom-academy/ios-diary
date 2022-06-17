//
//  RegisterViewController.swift
//  Diary
//
//  Created by 김태현 on 2022/06/14.
//

import UIKit

final class RegisterViewController: UIViewController {
    private let textView = UITextView()
    private var backButtonTitle: String?
    private let keyboard = Keyboard()
    
    init(backButtonTitle: String?) {
        super.init(nibName: nil, bundle: nil)
        self.backButtonTitle = backButtonTitle
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        view.backgroundColor = .systemBackground
        setUpNavigationController()
        setUpTextViewLayout()
        
        keyboard.setUpKeyboardNotification()
    }
    
    private func setUpNavigationController() {
        func setUpLeftItem() {
            let button = UIButton(title: backButtonTitle)
            let barButton = UIBarButtonItem(customView: button)
            
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
       
        keyboard.bottomContraint = textView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        
        NSLayoutConstraint.activate([
            textView.topAnchor.constraint(equalTo: view.topAnchor),
            textView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            textView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            keyboard.bottomContraint
        ].compactMap { $0 })
    }
}
