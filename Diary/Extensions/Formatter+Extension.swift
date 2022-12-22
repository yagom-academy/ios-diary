//
//  Formatter+Extension.swift
//  Diary
//
//  Created by Kyo, Baem on 2022/12/19.
//

import Foundation

extension Formatter {
    static func changeCustomDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.timeZone = TimeZone(identifier: TimeZone.current.identifier)
        formatter.dateFormat = "yyyy년 MM월 dd일"
        return formatter.string(from: date)
    }
}
