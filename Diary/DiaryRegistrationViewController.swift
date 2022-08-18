//
//  DiaryRegistrationViewController.swift
//  Diary
//
//  Created by bonf, bard on 2022/08/18.
//

import UIKit

class DiaryRegistrationViewController: UIViewController {
    // MARK: - properties
    
    private let textView = DiaryRegistrationView()
    private lazy var keyboardManager = KeyboardManager(textView)
    
    // MARK: - life cycles
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
    }
    
    // MARK: - functions
    
    private func setupView() {
        view.backgroundColor = .systemBackground
        view.addSubview(textView)
        textView.setupConstraints(with: view)
        textView.backgroundColor = .systemBackground
        keyboardManager.addNotificationObserver()
    }
    
    private func setupNavigationController() {
        let date = Date()
        
        navigationItem.title = date.convertToCurrentTime()
    }
}
