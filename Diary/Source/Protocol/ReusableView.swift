//  Diary - ReusableView.swift
//  Created by Ayaan, zhilly on 2022/12/22

import UIKit.UIView

protocol ReusableView: UIView {
    static var reuseIdentifier: String { get }
}

extension ReusableView {
    static var reuseIdentifier: String {
        return String(describing: self)
    }
}
