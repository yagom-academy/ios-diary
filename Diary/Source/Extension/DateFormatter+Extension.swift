//  Diary - DateFormatter+Extension.swift
//  Created by Ayaan, zhilly on 2022/12/21

import Foundation

extension DateFormatter {
    static func converted(date: Date, locale: Locale, dateStyle: DateFormatter.Style) -> String {
        let dateFormatter = DateFormatter()
        
        dateFormatter.locale = locale
        dateFormatter.dateStyle = dateStyle
        
        return dateFormatter.string(from: date)
    }
}
