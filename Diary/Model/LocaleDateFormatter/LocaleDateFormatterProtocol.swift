//
//  LocaleDateFormatterProtocol.swift
//  Diary
//
//  Created by Erick on 2023/08/29.
//

import Foundation

protocol LocaleDateFormatterProtocol {
    var dateFormatter: DateFormatter { get }
    func string(from date: Date) -> String
}

extension LocaleDateFormatterProtocol {
    func string(from date: Date) -> String {
        return dateFormatter.string(from: date)
    }
}
