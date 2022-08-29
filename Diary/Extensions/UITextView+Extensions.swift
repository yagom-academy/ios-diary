//
//  UITextView+Extensions.swift
//  Diary
//
//  Created by Hugh, Derrick on 2022/08/17.
//

import UIKit

extension UITextView {
    func focusTop() {
        let contentHeight = self.contentSize.height
        let offSet = self.contentOffset.y
        let contentOffset = contentHeight - offSet
        self.contentOffset = CGPoint(x: 0, y: -contentOffset)
    }
}
