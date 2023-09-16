//
//  IdentifiableCell.swift
//  Diary
//
//  Created by idinaloq, yetti on 2023/09/01.
//

protocol CellIdentifiable {
    static var identifier: String { get }
}

extension CellIdentifiable {
    static var identifier: String {
        return String(describing: self)
    }
}
