//
//  DateFormatter.swift
//  Diary
//
//  Created by SummerCat and som on 2022/12/20.
//

import Foundation

struct DateFormatterManager {
    let formatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy년 MM월 dd일"
        return formatter
    }()
    
    func numberToDate(_ number: Int?) -> String? {
        guard let number = number else { return nil }
        let timeInterval = TimeInterval(number)
        let date = Date(timeIntervalSince1970: timeInterval)
        
        return formatter.string(from: date)
    }
    
    func formatDate(_ date: Date) -> String {
        return formatter.string(from: date)
    }
}
