//
//  RegisterViewController.swift
//  Diary
//
//  Created by SummerCat and som on 2022/12/20.
//

import UIKit

final class RegisterViewController: DiaryItemViewController {
    private var diaryData: DiaryModel?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureTextView()
        addObserver()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        titleTextView.becomeFirstResponder()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        save()
    }
    
    private func addObserver() {
        let notificationName = Notification.Name("sceneDidEnterBackground")
        
        NotificationCenter.default.addObserver(self, selector: #selector(save),
                                               name: notificationName,
                                               object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(save),
                                               name: UIResponder.keyboardWillHideNotification,
                                               object: nil)
    }

    private func makeDiaryModel() -> DiaryModel {
        let data = DiaryModel(id: UUID(),
                        title: titleTextView.text,
                        body: bodyTextView.text,
                        createdAt: Date())
        
        return data
    }
    
    private func updateDiaryModel() {
        diaryData?.title = titleTextView.text
        diaryData?.body = bodyTextView.text
        diaryData?.createdAt = Date()
    }
    
    private func configureTextView() {
        titleTextView.delegate = self
        bodyTextView.delegate = self
    }
    
    @objc private func save() {
        updateDiaryModel()
        
        guard let diary = diaryData else {
            let data = makeDiaryModel()
            diaryData = data
            CoreDataStack.shared.insertDiary(data)
            return
        }
        
        CoreDataStack.shared.updateDiary(diary)
    }
}

extension RegisterViewController {
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.textColor == UIColor.systemGray3 {
            textView.text = nil
            textView.textColor = .black
        }
    }
}

extension RegisterViewController: UITextViewDelegate {
    func textViewDidChange(_ textView: UITextView) {
        guard textView == titleTextView else { return }
        
        guard !hasTitle,
              let _ = titleTextView.text.firstIndex(of: "\n") else { return }

        hasTitle = true
        titleTextView.text = titleTextView.text.trimmingCharacters(in: .whitespacesAndNewlines)
        titleTextView.resignFirstResponder()
        bodyTextView.becomeFirstResponder()
    }
}
