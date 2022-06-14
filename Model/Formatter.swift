//
//  Formatter.swift
//  Diary
//
//  Created by 김태현 on 2022/06/14.
//

import Foundation

struct Formatter {
    static private let shared = DateFormatter()
    
    private init() { }
    
    static func setUpDate(from timeInterval: Int) -> String {
        switch Locale.current.regionCode {
        case "KR":
            shared.dateFormat = "yyyy년 MM월 dd일"
        case "US":
            shared.dateFormat = "MMM/dd/yyyy"
        default:
            shared.dateFormat = "MM.dd.yyyy"
        }
        
        let date = Date(timeIntervalSinceReferenceDate: Double(timeInterval))
        let result = shared.string(from: date)
        return result
    }
}
