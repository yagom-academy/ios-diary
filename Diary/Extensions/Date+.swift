//
//  Date+.swift
//  Diary
//
//  Created by Toy, Morgan on 1/5/24.
//

import Foundation

extension Date {
    static func generateTodayDate() -> String {
        let dateFormatter = DateFormatter()
        let date = Date()
        
        dateFormatter.dateFormat = "yyyy년 MM월 dd일"
        
        return dateFormatter.string(from: date)
    }
}
