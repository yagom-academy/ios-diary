//
//  ArrayExtension.swift
//  Diary
//
//  Created by kaki, 레옹아범 on 2023/04/25.
//

extension Array {
    subscript (safe index: Int) -> Element? {
        return indices ~= index ? self[index] : nil
    }
}
