//
//  UIStackView.swift
//  Diary
//
//  Created by 김동욱 on 2022/06/13.
//

import UIKit

extension UIStackView {
    func addArrangedSubviews(_ view: UIView...) {
        view.forEach {
            self.addArrangedSubview($0)
        }
    }
}
