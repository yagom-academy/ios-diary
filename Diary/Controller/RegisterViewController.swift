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
    
    override func viewDidLoad() {
        view.backgroundColor = .systemBackground
        setUpNavigationController()
    }
    
    private func setUpNavigationController() {
        func setUpLeftItem() {
            
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
        
        NSLayoutConstraint.activate([
            textView.topAnchor.constraint(equalTo: view.topAnchor),
            textView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            textView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            textView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
    }
}
