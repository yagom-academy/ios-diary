//
//  ReusableCell.swift
//  Diary
//
//  Created by Aaron, Gundy, Rhovin on 2022/12/23.
//

import Foundation

protocol ReusableCell {
    static var reuseIdentifier: String { get }
}

extension ReusableCell {
    static var reuseIdentifier: String {
        return String(describing: self)
    }
}
