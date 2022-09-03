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
    private let diaryCoreManager = DiaryCoreDataManager(with: .shared)
    private var diary: Diary?
    
    // MARK: - life cycles
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        keyboardManager.addNotificationObserver()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        keyboardManager.removeNotificationObserver()
        updateDiary()
    }
    
    // MARK: - functions
        
    private func updateDiary() {
        modifyDiary()
        
        guard let diary = diary else { return }

        diaryCoreManager.create(diary)
    }
    
    func setupDiary(icon: String?) {
        diary = Diary(uuid: UUID(),
                             title: "",
                             body: "",
                             createdAt: Date().timeIntervalSince1970,
                             icon: icon ?? "")
    }
    
    private func modifyDiary() {
        let diaryInfomation = textView.text.split(separator: "\n", maxSplits: 1)
        
        if diaryInfomation.isEmpty {
            return
        }
        
        let title = String(diaryInfomation[0])
        let body = getBody(title: title)
        
        diary?.modify(title: title)
        diary?.modify(body: body)
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
