//
//  CellIdentifiable+.swift
//  Diary
//
//  Created by idinaloq, yetti on 2023/09/01.
//

extension CellIdentifiable {
    static var identifier: String {
        return String(describing: self)
    }
}
