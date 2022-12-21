//
//  DateFormatter+.swift
//  Diary
//
//  Created by JPush, Wonbi on 2022/12/21.
//

import Foundation

struct DateLocalizer {
    private static let formatter: DateFormatter = DateFormatter()
    
    static func localizedString(
        from dateNumber: Double,
        dateStyle: DateFormatter.Style,
        timeStyle: DateFormatter.Style
    ) -> String {
        let date = Date(timeIntervalSince1970: dateNumber)
        let localeIdentifier = Locale.preferredLanguages.first ?? Locale.current.identifier
        
        self.formatter.locale = Locale(identifier: localeIdentifier)
        self.formatter.dateStyle = dateStyle
        self.formatter.timeStyle = timeStyle
        
        let localizedDate = self.formatter.string(from: date)

        return localizedDate
    }
}
