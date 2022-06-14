//
//  DateConverter.swift
//  Diary
//
//  Created by 두기, marisol on 2022/06/14.
//

import Foundation

struct DateConverter {
    static let dateFormatter = DateFormatter()
    static func changeDateFormat(_ doubleDate: Double) -> String {
        let date = Date(timeIntervalSince1970: doubleDate)
        
        dateFormatter.locale = .autoupdatingCurrent
        dateFormatter.timeZone = .autoupdatingCurrent
        dateFormatter.dateFormat = "yyyy년 MM월 dd일"
        
        let stringDate = dateFormatter.string(from: date)
        
        return stringDate
    }
}
