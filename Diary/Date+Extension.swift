//
//  Date+Extension.swift
//  Diary
//
//  Created by bonf, bard on 2022/08/17.
//

import Foundation

extension Date {
    func convertToString() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "ko_kr")
        dateFormatter.timeZone = TimeZone(abbreviation: "KST")
        dateFormatter.dateFormat = "yyyy년 MM월 dd일"
        
        let stringDate = dateFormatter.string(from: self)
        
        return stringDate
    }
}
