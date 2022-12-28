//
//  Array+Extension.swift
//  Diary
//
//  Created by leewonseok on 2022/12/28.
//

extension Array {
    subscript (safe index: Int) -> Element? {
        return indices ~= index ? self[index] : nil
    }
}
