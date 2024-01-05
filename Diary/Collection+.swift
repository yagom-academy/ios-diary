//
//  Collection+.swift
//  Diary
//
//  Created by Kiseok on 1/5/24.
//

import Foundation

extension Collection {
    subscript (safe index: Index) -> Element? {
        return indices.contains(index) ? self[index] : nil
    }
}
