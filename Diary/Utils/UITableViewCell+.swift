//
//  UITableViewCell+.swift
//  Diary
//
//  Created by 김태현 on 2022/06/16.
//

import UIKit

extension UITableViewCell {
    static var identifier: String {
        return String(describing: Self.self)
    }
}
