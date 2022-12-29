//
//  NSAttributedString+.swift
//  Diary
//
//  Created by SummerCat and som on 2022/12/26.
//

import UIKit

extension NSAttributedString {
    func formatTitle(between range: NSRange?) -> NSAttributedString {
        guard let range = range else { return self }
        let attributeString = NSMutableAttributedString(attributedString: self)
        
        attributeString.addAttributes([
            NSAttributedString.Key.font: UIFont.preferredFont(forTextStyle: .title1)
        ], range: range)
        
        return attributeString
    }
}
