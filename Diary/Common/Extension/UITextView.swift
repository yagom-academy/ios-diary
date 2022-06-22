//
//  UITextView.swift
//  Diary
//
//  Created by mmim, grumpy, mino on 2022/06/21.
//

import UIKit

extension UITextView {
    func highlightFirstLineInTextView() {
        let textAsNSString = self.text as NSString
        let lineBreakRange = textAsNSString.range(of: "\n")
        let newAttributedText = NSMutableAttributedString(attributedString: self.attributedText)
        let boldRange: NSRange
        if lineBreakRange.location < textAsNSString.length {
            boldRange = NSRange(location: 0, length: lineBreakRange.location)
        } else {
            boldRange = NSRange(location: 0, length: textAsNSString.length)
        }
        
        newAttributedText.addAttribute(
            NSAttributedString.Key.font,
            value: UIFont.preferredFont(forTextStyle: UIFont.TextStyle.title2),
            range: boldRange
        )
        self.attributedText = newAttributedText
    }
}
