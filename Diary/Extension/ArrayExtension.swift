//
//  ArrayExtension.swift
//  Diary
//
//  Created by Andrew, brody on 2023/04/28.
//

extension Array {
    subscript (safe index: Int) -> Element? {
        return indices ~= index ? self[index] : nil
    }
}
