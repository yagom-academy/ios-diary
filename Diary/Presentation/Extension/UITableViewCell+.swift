//
//  UITableViewCell+.swift
//  Diary
//
//  Created by dudu, papri on 2022/06/14.
//

import UIKit

extension UITableViewCell {
    static var reuseIdentifier: String {
        return String(describing: self)
    }
}
