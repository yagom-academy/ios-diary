//
//  View + Extension.swift
//  Diary
//
//  Created by 백곰, 주디 on 2022/08/18.
//

import UIKit

extension UITableView {
    func register<T: UITableViewCell>(cellWithClass name: T.Type) {
        register(T.self, forCellReuseIdentifier: String(describing: name))
    }
}
