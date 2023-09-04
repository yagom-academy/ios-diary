//
//  DateFormatter+.swift
//  Diary
//
//  Created by Mary & Whales on 9/4/23.
//

import Foundation

extension DateFormatter {
    func format(from date: Date, dateStyle: DateFormatter.Style, timeStyle: DateFormatter.Style) -> String {
        locale = .current
        timeZone = .current
        self.dateStyle = dateStyle
        self.timeStyle = timeStyle
        
        return string(from: date)
    }
}
