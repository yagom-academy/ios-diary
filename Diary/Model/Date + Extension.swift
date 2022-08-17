//
//  Date + Extension.swift
//  Diary
//
//  Created by Kiwon Song on 2022/08/17.
//

import Foundation

extension Date {
    func formatted(_ format: String) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = format
        formatter.locale = Locale(identifier: "ko_KR")
        formatter.timeZone = TimeZone(abbreviation: "KST")
        
        return formatter.string(from: self)
    }
}
