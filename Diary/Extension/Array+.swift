//
//  Array+.swift
//  Diary
//
//  Created by Kobe, Moon on 2023/09/06.
//

extension Array {
    subscript(safe index: Int) -> Element? {
        return indices ~= index ? self[index] : nil
    }
}
