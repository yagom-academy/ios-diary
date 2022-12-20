//
//  Date +.swift
//  Diary
//
//  Copyright (c) 2022 Minii All rights reserved.

import Foundation

extension Date {
    static let dateFormatter = DateFormatter()
    
    enum Constant {
        static let defaultFormat = "yyyy년 MM월 dd일"
    }
    
    func convertString(format: String = Constant.defaultFormat) -> String {
        let formatter = Self.dateFormatter
        formatter.timeZone = TimeZone.current
        formatter.dateFormat = format
        
        return formatter.string(from: self)
    }
}
