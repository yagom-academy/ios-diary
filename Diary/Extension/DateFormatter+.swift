//
//  DateFormatter+.swift
//  Diary
//
//  Created by idinaloq, yetti on 2023/08/30.
//

import Foundation

extension DateFormatter {
    static let dateFormatter: DateFormatter = DateFormatter()
    static var today: String {
        let date: Date = Date(timeIntervalSinceNow: 0)
        dateFormatter.locale = Locale(identifier: LocaleIdentifier.KOR.description)
        dateFormatter.timeZone = TimeZone(identifier: TimeZone.current.identifier)
        dateFormatter.dateStyle = .long
        
        return dateFormatter.string(from: date)
    }
}
