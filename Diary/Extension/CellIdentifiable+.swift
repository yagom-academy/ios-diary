//
//  CellIdentifiable.swift
//  Diary
//
//  Created by JPush, Wonbi on 2022/12/27.
//

import Foundation

protocol CellIdentifiable {}

extension CellIdentifiable {
    static var identifier: String {
        return String(describing: Self.self)
    }
}
