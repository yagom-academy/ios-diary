//
//  TextView+Extension.swift
//  Diary
//
//  Created by rilla, songjun on 2023/04/25.
//

import UIKit

extension UITextField {
    func addLeftPadding() {
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: self.frame.height + 30))
        self.leftView = paddingView
        self.leftViewMode = ViewMode.always
      }
}
