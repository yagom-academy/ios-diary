//
//  Date+Extension.swift
//  Diary
//
//  Created by 써니쿠키, LJ on 2022/12/21.
//

import Foundation

extension Date {
    
    var timeZoneDateFormat: String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy년 MM월 dd일"
        dateFormatter.timeZone = .autoupdatingCurrent
        
        return dateFormatter.string(from: self)
    }
}
