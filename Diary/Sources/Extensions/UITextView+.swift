//
//  UITextView+.swift
//  Diary
//
//  Created by 이태영 on 2023/01/05.
//

import UIKit

extension UITextView {
    convenience init(
        font: UIFont,
        lineFragmentPadding: CGFloat,
        textContainerInset: UIEdgeInsets
    ) {
        self.init()
        
        self.font = font
        self.adjustsFontForContentSizeCategory = true
        self.textContainer.lineFragmentPadding = lineFragmentPadding
        self.textContainerInset = textContainerInset
        self.showsVerticalScrollIndicator = false
        self.keyboardDismissMode = .onDrag
        self.alwaysBounceVertical = true
    }
    
    var filteredText: String {
        return self.text ?? ""
    }
}
