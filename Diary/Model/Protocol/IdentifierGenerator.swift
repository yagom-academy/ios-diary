//
//  IdentifierGenerator.swift
//  Diary
//
//  Created by Kobe, Moon on 2023/08/29.
//

import UIKit

protocol IdentifierGenerator {}

extension IdentifierGenerator where Self: UITableViewCell {
    static var identifier: String {
        return String(describing: self)
    }
}
