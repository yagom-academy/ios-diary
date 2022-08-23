//
//  DiaryRegistrationViewController.swift
//  Diary
//
//  Created by bonf, bard on 2022/08/18.
//

import UIKit

final class DiaryRegistrationViewController: UIViewController {
    // MARK: - properties
    
    private let textView = DiaryRegistrationView()
    private lazy var keyboardManager = KeyboardManager(textView)
    private let diaryData = MockDiaryManager()
    
    // MARK: - life cycles
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        keyboardManager.addNotificationObserver()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        keyboardManager.removeNotificationObserver()
        updateDiary()
    }
    
    // MARK: - functions
        
    func updateDiary() {
        let newDiary = Diary(title: "Asdf", body: "sibal", createdAt: 0.0)

        diaryData.update(with: newDiary)
    }
    
    private func popTitle() -> String {
        if textView.text == "" { return "" }
        
        let textSeparater = String(textView.text.split(separator: "\n")[0])
        for _ in 0...textSeparater.count {
            textView.text.removeFirst()
        }
        
        return textSeparater
    }
    
    private func setupView() {
        view.backgroundColor = .systemBackground
        view.addSubview(textView)
        
        textView.setupConstraints(with: view)
        textView.backgroundColor = .systemBackground
    }
    
    private func setupNavigationController() {
        let date = Date()
        
        navigationItem.title = date.convertToCurrentTime()
    }
}
