//
//  DiaryRegisterViewController.swift
//  Diary
//
//  Created by 재재, 그루트 on 2022/08/18.
//

import UIKit

final class DiaryRegisterViewController: UIViewController {
    // MARK: - properties
    
    private let diaryRegisterView = DiaryRegisterView()
    
    // MARK: - view life cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        
        configureView()
        configureViewLayout()
        configureKeyboardNotification()
        diaryRegisterView.showKeyBoard()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        saveDiaryData()
        removeRegisterForKeyboardNotification()
    }

    // MARK: - methods
    
    private func configureView() {
        view.addSubview(diaryRegisterView)
        navigationItem.title = Double(Date().timeIntervalSince1970).convertDate()
    }
    
    private func configureViewLayout() {
        NSLayoutConstraint.activate([
            diaryRegisterView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            diaryRegisterView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            diaryRegisterView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 8),
            diaryRegisterView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -8)
        ])
    }
    
    private func configureKeyboardNotification() {
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(keyBoardShowAction),
                                               name: UIResponder.keyboardWillShowNotification,
                                               object: nil)
        
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(keyboardDownAction),
                                               name: UIResponder.keyboardWillHideNotification,
                                               object: nil)
    }
    
    private func removeRegisterForKeyboardNotification() {
        NotificationCenter.default.removeObserver(self,
                                                  name: UIResponder.keyboardWillShowNotification,
                                                  object: nil)
        
        NotificationCenter.default.removeObserver(self,
                                                  name: UIResponder.keyboardWillHideNotification,
                                                  object: nil)
    }
    
    @objc private func keyBoardShowAction(notification: NSNotification) {
        guard let userInfo: NSDictionary = notification.userInfo as? NSDictionary,
              let keyboardFrame = userInfo.value(forKey: UIResponder.keyboardFrameEndUserInfoKey) as? NSValue
        else { return }
        
        let keyboardRectangle = keyboardFrame.cgRectValue
        let keyboardHeight = keyboardRectangle.height
        
        diaryRegisterView.configureDetailTextViewInset(inset: keyboardHeight)
    }
    
    @objc private func keyboardDownAction() {
        view.endEditing(true)
        
        diaryRegisterView.configureDetailTextViewInset(inset: 0)
    }
    
    @objc func saveDiaryData() {
        let inputText = diaryRegisterView.seperateText()
        
        guard inputText.title != "" || inputText.body != "" else { return }
        
        let diaryModel = DiaryModel(title: inputText.title,
                                    body: inputText.body,
                                    createdAt: Double(Date().timeIntervalSince1970))
        
        CoreDataManager.shared.create(newDiary: diaryModel)
    }
}

