//
//  Date+.swift
//  Diary
//
//  Created by Aaron, Gundy, Rhovin on 2022/12/21.
//

import Foundation

extension Date {
    var localeFormattedText: String {
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: Locale.preferredLanguages[0])
        dateFormatter.dateStyle = .long

        return dateFormatter.string(from: self)
    }
}
