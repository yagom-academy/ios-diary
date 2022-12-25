//
//  Date +.swift
//  Diary
//
//  Copyright (c) 2022 Minii All rights reserved.

import Foundation

extension Date {
    static let dateFormatter = DateFormatter()
    
    func convertString() -> String {
        let formatter = Self.dateFormatter
        formatter.timeZone = TimeZone.current
        formatter.locale = Locale.current
        formatter.dateStyle = .long
        
        return formatter.string(from: self)
    }
}
