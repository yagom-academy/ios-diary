//
//  RegisterViewController.swift
//  Diary
//
//  Created by SummerCat and som on 2022/12/20.
//

import UIKit

final class RegisterViewController: DiaryItemViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        configureTextView()
    }
    
    private func makeDiaryModel() -> DiaryModel {
        let diaryData = DiaryModel(id: UUID(),
                        title: titleTextView.text,
                        body: bodyTextView.text,
                        createdAt: Date())
        
        return diaryData
    }
    
    private func configureTextView() {
        titleTextView.delegate = self
        bodyTextView.delegate = self
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
    
    func textViewDidEndEditing(_ textView: UITextView) {
        CoreDataStack.shared.insertDiary(makeDiaryModel())
    }
}
