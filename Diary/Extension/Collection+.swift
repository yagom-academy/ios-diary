//
//  Collection+.swift
//  Diary
//
//  Created by JPush, Wonbi on 2022/12/30.
//

extension Collection {
    subscript(valid index: Index) -> Element? {
        return indices.contains(index) ? self[index] : nil
    }
}
