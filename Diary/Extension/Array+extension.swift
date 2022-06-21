//
//  Array+extension.swift
//  Diary
//
//  Created by Donnie, OneTool on 2022/06/21.
//

extension Array {
    subscript (safe index: Int) -> Element? {
        return indices ~= index ? self[index] : nil
    }
}
