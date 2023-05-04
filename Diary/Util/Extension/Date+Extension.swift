//
//  Date+Extension.swift
//  Diary
//
//  Created by rilla, songjun on 2023/04/25.
//

import Foundation

extension Date {
    private enum LocalizationKey {
        static let dateFormat = "dateFormat"
    }
    
    static let nowDate: String = {
        return convertFormattedDate()
    }()
    static let nowTimeIntervalSince1970: Int = {
        return convertDateInterval()
    }()
    
    private static func convertFormattedDate() -> String {
        let date = Date()
        let dateFormatter = DateFormatter()
        
        dateFormatter.dateFormat = String.localized(key: LocalizationKey.dateFormat)
        
        let convertString = dateFormatter.string(from: date)
        
        return convertString
    }
    
    private static func convertDateInterval() -> Int {
        let date = Date()
        let dateFormatter = DateFormatter()
        
        dateFormatter.timeZone = TimeZone.current
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        
        let localDateString = dateFormatter.string(from: date)
        let localDate = dateFormatter.date(from: localDateString) ?? Date()
        
        return Int(localDate.timeIntervalSince1970)
    }
}
