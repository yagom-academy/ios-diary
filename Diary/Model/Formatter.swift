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
    
    static func setUpDate(from timeInterval: Int) -> String {
        dateFormatter.dateStyle = .long
        dateFormatter.locale = .autoupdatingCurrent
        
        let date = Date(timeIntervalSinceReferenceDate: Double(timeInterval))
        let result = dateFormatter.string(from: date)
        return result
    }
    
    static func getCurrentDate() -> String {
        setUpDate(from: Int(Date().timeIntervalSinceReferenceDate))
    }
}
