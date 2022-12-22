//
//  Ext + String.swift
//  Diary
//
//  Copyright (c) 2022 woong, jeremy All rights reserved.
    

import Foundation

extension String {
    func parseData(titleWordsLimit: Int) -> (title: String, body: String) {
        var components = components(separatedBy: "\n\n")
        if components.count > 1 {
            let title = components.removeFirst()
            let body = components.filter { $0 != ""}.joined(separator: "\n\n")
            return (title, body)
        }
        let limitIndex = index(startIndex, offsetBy: titleWordsLimit)
        let title = self[startIndex..<limitIndex]
        let body = self[limitIndex..<endIndex]
        return (title.description, body.description)
    }
}
