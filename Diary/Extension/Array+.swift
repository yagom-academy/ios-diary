//
//  Array+.swift
//  Diary
//
//  Created by idinaloq, yetti on 2023/08/30.
//

extension Array {
    subscript(safe index: Int) -> Element? {
        return self.indices ~= index ? self[index] : nil
    }
}
