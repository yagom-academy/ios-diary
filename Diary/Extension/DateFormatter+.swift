//
//  DateFormatter+.swift
//  Diary
//
//  Created by idinaloq, yetti on 2023/08/30.
//

import Foundation

extension DateFormatter {
    static var today: String {
        let dateFormatter: DateFormatter = DateFormatter()
        let date: Date = Date(timeIntervalSinceNow: 0)
        dateFormatter.locale = Locale(identifier: LocaleIdentifier.KOR.description)
        dateFormatter.timeZone = TimeZone(identifier: TimeZone.current.identifier)
        dateFormatter.dateStyle = .long
        
        return dateFormatter.string(from: date)
    }
    
    static func formatDate(_ data: DiaryEntity, locale: LocaleIdentifier, formatter: DateFormatter) -> String {
        let date: Date = Date(timeIntervalSince1970: TimeInterval(data.createdAt))
        formatter.locale = Locale(identifier: locale.description)
        formatter.timeZone = TimeZone(identifier: TimeZone.current.identifier)
        formatter.dateStyle = .long
        
        return formatter.string(from: date)
    }
}
