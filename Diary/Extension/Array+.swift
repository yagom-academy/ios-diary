//
//  Array+.swift
//  Diary
//
//  Created by hoon, karen on 2023/09/12.
//

extension Array {
    public subscript(safe index: Int) -> Element? {
        guard index >= 0, index < endIndex else {
            return nil
        }
        
        return self[index]
    }
}
