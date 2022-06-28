//
//  UITableView+.swift
//  Diary
//
//  Created by 김태현 on 2022/06/16.
//

import UIKit

extension UITableView {
    func register<T: UITableViewCell>(_ type: T.Type) {
        register(type, forCellReuseIdentifier: type.identifier)
    }
}
