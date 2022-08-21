//
//  Array+Extension.swift
//  Diary
//
//  Created by bonf, bard on 2022/08/21.
//

extension Array {
    func get(index: Int) -> Element? {
        if 0 <= index && index < count {
            return self[index]
        } else {
            return nil
        }
    }
}
