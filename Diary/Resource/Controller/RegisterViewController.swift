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
    }
}

extension RegisterViewController {
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.textColor == UIColor.systemGray3 {
            textView.text = nil
            textView.textColor = .black
        }
    }
    
    func textViewDidChange(_ textView: UITextView) {
        guard !hasTitle else { return }
        
        guard let firstReturnIndex = mainTextView.text.firstIndex(of: "\n") else { return }

        let distance = mainTextView.text.distance(from: mainTextView.text.startIndex, to: firstReturnIndex)
        diaryTitle = String(mainTextView.text[..<firstReturnIndex])
        titleRange = NSRange(location: 0, length: distance)
        hasTitle = true
    }
    
    // TODO: didEndEditing에서 body 할당
//    diaryBody = String(mainTextView.text[returnIdx...]).trimmingCharacters(in: .whitespaces)
}
