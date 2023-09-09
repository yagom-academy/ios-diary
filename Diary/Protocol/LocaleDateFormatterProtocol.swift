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
    func date(from string: String) -> Date?
}

extension LocaleDateFormatterProtocol {
    func string(from date: Date) -> String {
        return dateFormatter.string(from: date)
    }
    
    func date(from string: String) -> Date? {
        return dateFormatter.date(from: string)
    }
}
