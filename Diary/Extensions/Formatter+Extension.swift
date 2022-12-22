//
//  Formatter+Extension.swift
//  Diary
//
//  Created by Kyo, Baem on 2022/12/19.
//

import Foundation

extension Formatter {
    static func changeCustomDate(_ date: Date) -> String {
        let locale = NSLocale.preferredLanguages.first
        let formatter = DateFormatter()
        formatter.dateStyle = .long
        formatter.locale = Locale(identifier: locale ?? Locale.current.identifier)
        formatter.timeZone = TimeZone(identifier: TimeZone.current.identifier)
        return formatter.string(from: date)
    }
}
