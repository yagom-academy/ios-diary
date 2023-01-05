//
//  TimeInterval.swift
//  Diary
//
//  Created by Mangdi, junho on 2022/12/22.
//

import Foundation

extension TimeInterval {
    func currentLocalizedText() -> String {
        let date = Date(timeIntervalSince1970: self)
        let formatter = DateFormatter()
        formatter.dateStyle = .long
        formatter.timeStyle = .none
        formatter.locale = Locale.currentLocale
        return formatter.string(from: date)
    }
}
