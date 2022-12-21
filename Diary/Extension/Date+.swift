//
//  Date+.swift
//  Diary
//
//  Created by Aaron, Gundy, Rhovin on 2022/12/21.
//

import Foundation

extension Date {
    var koreanFormattedText: String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy년 MM월 dd일"
        dateFormatter.timeZone = .autoupdatingCurrent
        dateFormatter.locale = .autoupdatingCurrent
        
        return dateFormatter.string(from: self)
    }
}
