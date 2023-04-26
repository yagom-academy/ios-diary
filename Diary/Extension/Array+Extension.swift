//
//  Array+Extension.swift
//  Diary
//
//  Created by Seoyeon Hong on 2023/04/26.
//

import Foundation

extension Array {
    subscript(safe index: Int) -> Element? {
        return indices.contains(index) ? self[index] : nil
    }
}
