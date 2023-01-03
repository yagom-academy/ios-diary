//
//  TextViewManager.swift
//  Diary
//
//  Created by SummerCat and som on 2023/01/03.
//

import UIKit

class TextViewManager {
    private var hasTitle: Bool = false
    
    func isOversized(height: CGFloat, maxHeight: CGFloat) -> Bool {
        if height > maxHeight {
            return true
        } else {
            return false
        }
    }
    
    func enter(from title: UITextView, to body: UITextView) {
        if !hasTitle,
           title.text.firstIndex(of: "\n") != nil {
            hasTitle = true
            title.text = title.text.trimmingCharacters(in: .whitespacesAndNewlines)
            title.resignFirstResponder()
            body.becomeFirstResponder()
        }
    }
    
    func setPlaceholder(textView: UITextView, text: String) {
        if textView.text.isEmpty {
            textView.textColor = .systemGray3
            textView.text = text
        } else {
            textView.resignFirstResponder()
        }
    }
}
