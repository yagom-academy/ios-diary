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
    }
    
    // 백그라운드로 보낼때는 동작 안함
    // 이전화면으로 갈때는 동작 O
    override func viewWillDisappear(_ animated: Bool) {
        save()
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
    
    // 키보드를 내렸을때
    // 백그라운드로 갈때
    // 전화면으로 갈때
    private func save() {
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
