//
//  Collection+.swift
//  Diary
//
//  Created by Kiseok on 1/5/24.
//

extension Collection {
    subscript (safe index: Index) -> Element? {
        return indices.contains(index) ? self[index] : nil
    }
}
