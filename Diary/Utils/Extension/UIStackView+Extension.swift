//
//  UIStackView+.swift
//  Diary
//
//  Created by Taeangel, Quokka on 2022/06/16.
//

import UIKit

extension UIStackView {
  func addArrangedSubviews(_ views: UIView...) {
    views.forEach { view in
      addArrangedSubview(view)
    }
  }
}
