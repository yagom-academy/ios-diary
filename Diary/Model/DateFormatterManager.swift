//
//  DateFormatterManager.swift
//  Diary
//
//  Created by 리지, Goat on 2023/04/24.
//

import Foundation

enum DateFormatterManager {
    static func convertToFomattedDate(of date: Int) -> String? {
        let dateFormatter = DateFormatter()
        let date = Date(timeIntervalSince1970: TimeInterval(date))
        
        dateFormatter.locale = Locale(identifier: "ko-KR")
        dateFormatter.dateFormat = "yyyy년 MM월 dd일"
        
        return dateFormatter.string(from: date)
    }
}
