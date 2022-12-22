//
//  dateFormatter+extension.swift
//  Diary
//
//  Created by leewonseok on 2022/12/22.
//

import Foundation

extension DateFormatter {
    
    static func conversionLocalDate(date: Date, local: Locale, dateStyle: DateFormatter.Style) -> String {
        let formatter = DateFormatter()
        formatter.locale = local
        formatter.dateStyle = dateStyle
        return formatter.string(from: date)
    }
}
