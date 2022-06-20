//
//  UIStackView+.swift
//  Diary
//
//  Created by 두기, marisol on 2022/06/14.
//

import UIKit

extension UIStackView {
    func addArrangedSubview(_ views: [UIView]) {
        for view in views {
            self.addArrangedSubview(view)
        }
    }
}
