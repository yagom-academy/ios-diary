//
//  LocalDate.swift
//  Diary
//
//  Created by leewonseok on 2022/12/21.
//

import Foundation

struct LocalDate {
    let formatter = DateFormatter()
    
    func conversionLocalDate(date: Date, local: Locale, dateStyle: DateFormatter.Style) -> String {
        formatter.locale = local
        formatter.dateStyle = dateStyle
        return formatter.string(from: date)
    }
}
