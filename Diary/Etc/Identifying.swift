//
//  Identifying.swift
//  Diary
//
//  Created by kaki, 레옹아범 on 2023/04/25.
//

import UIKit

protocol Identifying {
    static var identifier: String { get }
}

extension Identifying {
    static var identifier: String {
        return String(describing: self)
    }
}

extension UITableViewCell: Identifying { }
