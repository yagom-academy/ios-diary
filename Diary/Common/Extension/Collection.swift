//
//  Collection.swift
//  Diary
//
//  Created by mmim, grumpy, mino on 2022/06/14.
//

import Foundation

extension Collection {
    subscript(safe index: Index) -> Element? {
        return indices.contains(index) ? self[index] : nil
    }
}
