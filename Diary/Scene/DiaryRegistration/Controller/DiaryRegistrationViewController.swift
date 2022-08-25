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
    private let diaryData = CoreDataManager()
    
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
        
    private func updateDiary() {
        let diaryInfomation = textView.text.split(separator: "\n", maxSplits: 1)
        
        if diaryInfomation.isEmpty {
            return
        }
        
        let title = String(diaryInfomation[0])
        let body = getBody(title: title)
        let newDiary = Diary(uuid: UUID(),
                             title: title,
                             body: body,
                             createdAt: Date().timeIntervalSince1970)
        
        diaryData.create(model: newDiary)
    }
    
    private func getBody(title: String) -> String {
        guard var text = textView.text else { return "" }
        
        for _ in 0..<title.count {
            text.removeFirst()
        }
        
        return text
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
