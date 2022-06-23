//
//  UIStackView+.swift
//  Diary
//
//  Created by dudu, papri on 2022/06/14.
//

import UIKit

extension UIStackView {
    func addArrangedSubviews(_ views: UIView...) {
        views.forEach { view in
            addArrangedSubview(view)
        }
    }
}
