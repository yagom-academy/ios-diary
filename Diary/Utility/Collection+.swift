//
//  Collection+.swift
//  Diary
//
//  Created by Whales on 9/4/23.
//

extension Collection {
    subscript (safe index: Index) -> Element? {
        return indices.contains(index) ? self[index] : nil
    }
}
