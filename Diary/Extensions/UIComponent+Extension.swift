//
//  UIComponent+Extension.swift
//  Diary
//
//  Created by Kyo, Baem on 2022/12/22.
//

import UIKit

extension UILabel {
    convenience init(textStyle: UIFont.TextStyle, numberOfLine: Int = 1) {
        self.init()
        self.font = .preferredFont(forTextStyle: textStyle)
        self.numberOfLines = numberOfLine
        self.adjustsFontForContentSizeCategory = true
        self.translatesAutoresizingMaskIntoConstraints = false
    }
}

extension UIStackView {
    convenience init(subview: [UIView],
                     spacing: CGFloat,
                     axis: NSLayoutConstraint.Axis,
                     alignment: UIStackView.Alignment,
                     distribution: UIStackView.Distribution) {
        self.init(arrangedSubviews: subview)
        self.axis = axis
        self.spacing = spacing
        self.alignment = alignment
        self.distribution = distribution
        self.translatesAutoresizingMaskIntoConstraints = false
    }
}
