//
//  UIEdgeInsets+Extension.swift
//  Diary
//
//  Created by Minseong, Lingo on 2022/06/18.
//

import UIKit

extension UIEdgeInsets {
  init(bottom: CGFloat) {
    self.init(top: .zero, left: .zero, bottom: bottom, right: .zero)
  }
}
