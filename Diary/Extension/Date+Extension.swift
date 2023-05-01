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
    
    private static func convertFormattedDate() -> String {
        let date = Date()
        let dateFormatter = DateFormatter()
        
        dateFormatter.dateFormat = String.localized(key: LocalizationKey.dateFormat)
        
        let convertString = dateFormatter.string(from: date)
        
        return convertString
    }
}
