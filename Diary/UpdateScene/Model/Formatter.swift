//
//  Formatter.swift
//  Diary
//
//  Created by 김태현 on 2022/06/14.
//

import Foundation

struct Formatter {
    static private let dateFormatter = DateFormatter()
    
    private init() { }
    
    static func setUpDate(from timeInterval: Double) -> String {
        dateFormatter.dateStyle = .long
        dateFormatter.locale = .autoupdatingCurrent
        
        let date = Date(timeIntervalSinceReferenceDate: timeInterval)
        let result = dateFormatter.string(from: date)
        
        return result
    }
    
    static func getDate(from dateString: String) -> Date? {
        dateFormatter.date(from: dateString)
    }
    
    static func getCurrentDate() -> String {
        setUpDate(from: Date().timeIntervalSinceReferenceDate)
    }
}
