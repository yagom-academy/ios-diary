//
//  DiaryDetailViewController.swift
//  Diary
//
//  Created by 민쏜, 보리사랑 on 2022/08/16.
//

import UIKit

final class DiaryCreateViewController: DiaryEditableViewController {
    
    // MARK: - Properties
    
    private var newDiaryItem = DiaryItem(
        title: "",
        body: "",
        createdDate: Date().timeIntervalSince1970,
        uuid: UUID()
    )

    // MARK: - Life Cycles
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureRootViewUI()
        addUIComponents()
        configureLayout()
        DiaryCoreDataManager.shared.saveDiary(diaryItem: newDiaryItem)
        setupKeyboard()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        removeKeyboardWillShowNoification()
        
        updateNewDiaryEntity()
    }
}

private extension DiaryCreateViewController {
    
    // MARK: - Private Methods
    
    // MARK: - Configuring DiaryItem for Core Data
    
    func convertTextToDiaryItem() {
        let data = splitTitleAndBody(from: contentTextView.text)
        
        newDiaryItem.title = data.title
        newDiaryItem.body = data.body
    }
    
    func updateNewDiaryEntity() {
        convertTextToDiaryItem()
        DiaryCoreDataManager.shared.update(diaryItem: newDiaryItem)
    }
    
    // MARK: Configuring UI
    
    func configureRootViewUI() {
        self.view.backgroundColor = .systemBackground
        
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(didEnterBackground(_:)),
            name: UIApplication.didEnterBackgroundNotification,
            object: nil
        )
        
        navigationItem.title = newDiaryItem.createdDate.localizedFormat()
    }
    
    @objc func didEnterBackground(_ sender: Notification) {
        updateNewDiaryEntity()
    }
    
    // MARK: Setting Keyboard
    
    func setupKeyboard() {
        contentTextView.becomeFirstResponder()
        setupKeyboardWillShowNoification()
    }
    
    @objc func keyboardWillHide(_ sender: Notification) {
        updateNewDiaryEntity()
    }
}
