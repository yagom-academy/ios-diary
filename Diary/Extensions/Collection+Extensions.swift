//
//  Collection+Extensions.swift
//  Diary
//
//  Created by Derrick kim on 9/2/22.
//

public extension Collection {
  subscript (safe index: Index) -> Element? {
    return indices.contains(index) ? self[index] : nil
  }
}
