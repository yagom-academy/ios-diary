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
    
    subscript (safe index: PartialRangeFrom<Int>) -> Array<Element>.SubSequence? {
        return indices ~= index.lowerBound ? self[index] : nil
    }
}
