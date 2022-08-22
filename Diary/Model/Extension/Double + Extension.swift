//
//  Double + Extension.swift
//  Diary
//
//  Created by Kiwi, Brad. on 2022/08/17.
//

import Foundation

extension Double {
    func dateFormatted() -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy년 MM월 dd일"
        formatter.locale = Locale(identifier: "ko_KR")
        formatter.timeZone = TimeZone(abbreviation: "KST")
        
        return formatter.string(from: Date(timeIntervalSince1970: TimeInterval(self)))
    }
}
