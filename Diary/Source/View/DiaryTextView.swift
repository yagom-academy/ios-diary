//  Diary - DiaryTextView.swift
//  Created by Ayaan, zhilly on 2022/12/23

import UIKit.UITextView

final class DiaryTextView: UITextView {
    private let placeholder: String
    private let placeholderColor: UIColor = .systemGray3
    private let defaultTextColor: UIColor
    
    init(placeholder: String, defaultTextColor: UIColor) {
        self.placeholder = placeholder
        self.defaultTextColor = defaultTextColor
        super.init(frame: .zero, textContainer: nil)
        text = placeholder
        textColor = placeholderColor
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configurePlaceholder() {
        if hasText == false {
            text = placeholder
            textColor = placeholderColor
        }
    }
    
    override func becomeFirstResponder() -> Bool {
        if textColor == placeholderColor {
            text = .init()
            textColor = defaultTextColor
        }
        
        return super.becomeFirstResponder()
    }
}
