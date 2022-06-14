//
//  UITableViewCell+.swift
//  Diary
//
//  Created by 김동욱 on 2022/06/14.
//

import UIKit

extension UITableViewCell {
    static var identifier: String {
        return String(describing: Self.self)
    }
}
