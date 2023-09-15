//
//  Collection+.swift
//  Diary
//
//  Created by Dasan, kyungmin on 2023/09/13.
//

extension Collection {
    subscript (safe index: Index) -> Element? {
        return indices.contains(index) ? self[index] : nil
    }
}
