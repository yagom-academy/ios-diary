//
//  UIView+.swift
//  Diary
//
//  Created by dudu, papri on 2022/06/14.
//

import UIKit

extension UIView {
    func addSubviews(_ views: UIView...) {
        views.forEach { view in
            addSubview(view)
        }
    }
}
