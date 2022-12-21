//
//  DateFormatterManager.swift
//  Diary
//
//  Created by SummerCat and som on 2022/12/20.
//

import Foundation

struct DateFormatterManager {
    func convertToDate(from number: Int?) -> String? {
        guard let number = number else { return nil }
        
        let timeInterval = TimeInterval(number)
        let date = Date(timeIntervalSince1970: timeInterval)
        
        return DateFormatter.localizedString(from: date, dateStyle: .long, timeStyle: .none)
    }
    
    func formatDate(_ date: Date) -> String {
        return DateFormatter.localizedString(from: date, dateStyle: .long, timeStyle: .none)
    }
}
