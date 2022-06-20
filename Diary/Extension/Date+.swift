//
//  Date+.swift
//  Diary
//
//  Created by 두기, marisol on 2022/06/17.
//

import Foundation

extension Date {
    var dateToKoreanString: String {
        let dateFormatter = DateFormatter()
        
        dateFormatter.locale = .autoupdatingCurrent
        dateFormatter.timeZone = .autoupdatingCurrent
        dateFormatter.dateFormat = "yyyy년 MM월 dd일"
        
        let stringDate = dateFormatter.string(from: self)
        
        return stringDate
    }
}
