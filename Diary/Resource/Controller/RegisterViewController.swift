//
//  RegisterViewController.swift
//  Diary
//
//  Created by SummerCat and som on 2022/12/20.
//

import UIKit

final class RegisterViewController: DiaryItemViewController { }

extension RegisterViewController {
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.textColor == UIColor.systemGray3 {
            textView.text = nil
            textView.textColor = .black
        }
    }
}

extension RegisterViewController {
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
