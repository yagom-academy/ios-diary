//
//  URLComponents+Extension.swift
//  Diary
//
//  Created by Finnn, 수꿍 on 2022/08/29.
//

import Foundation

extension URLComponents {
    mutating func addQuery(_ items: [String: String]) {
        var newQueryItems = [URLQueryItem]()
        
        for (key, value) in items.sorted(by: { $0.key < $1.key }) {
            newQueryItems.append(URLQueryItem(name: key,
                                              value: value))
        }
        
        guard queryItems != nil else {
            queryItems = newQueryItems
            return
        }
        
        queryItems?.append(contentsOf: newQueryItems)
    }
}
