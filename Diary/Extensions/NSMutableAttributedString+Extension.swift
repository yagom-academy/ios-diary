//
//  NSMutableAttributedString+Extension.swift
//  Diary
//
//  Created by Kyo, Baem on 2022/12/29.
//

import UIKit

extension NSMutableAttributedString {
    static func customAttributeTitle(text: String, range: NSRange) -> NSMutableAttributedString {
        let attributedTitle = NSMutableAttributedString(string: text)
        attributedTitle.addAttribute(.font,
                                     value: UIFont.preferredFont(forTextStyle: .title3),
                                     range: range)
        return attributedTitle
    }
}
