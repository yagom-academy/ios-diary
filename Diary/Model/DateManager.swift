//
//  DateManager.swift
//  Diary
//
//  Created by Christy, vetto on 2023/04/25.
//

import Foundation

struct DateManger {
    static let shared = DateManger()
    
    private init() {}
    
    let dateFormatter: DateFormatter = {
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "ko_kr")
        dateFormatter.dateFormat = "yyyy년 MM월 dd일"
        
        return dateFormatter
    }()
    
    func generateTodayDate() -> String {
        let date = Date()
        
        return dateFormatter.string(from: date)
    }
    
    func convertToDate(fromInt: Int) -> String {
        let date: Date = Date(timeIntervalSince1970: TimeInterval(fromInt))
        
        return dateFormatter.string(from: date)
    }
}
