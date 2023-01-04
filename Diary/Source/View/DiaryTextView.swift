//  Diary - DiaryTextView.swift
//  Created by Ayaan, zhilly on 2022/12/23

import UIKit.UITextView

final class DiaryTextView: UITextView {
    init(font: UIFont, textAlignment: NSTextAlignment, textColor: UIColor) {
        super.init(frame: .zero, textContainer: nil)
        self.font = font
        self.textAlignment = textAlignment
        self.textColor = textColor
        self.alwaysBounceVertical = true
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
