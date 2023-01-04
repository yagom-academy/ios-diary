//
//  Date+.swift
//  Diary
//
//  Created by JPush, Wonbi on 2022/12/26.
//

import Foundation

extension Date {
    private static let formatter: DateFormatter = DateFormatter()
    
    func localizedString(
        dateStyle: DateFormatter.Style = .long,
        timeStyle: DateFormatter.Style = .none
    ) -> String {
        let localeIdentifier = Locale.current.identifier
        
        Date.formatter.locale = Locale(identifier: localeIdentifier)
        Date.formatter.dateStyle = dateStyle
        Date.formatter.timeStyle = timeStyle
        
        let localizedDate = Date.formatter.string(from: self)

        return localizedDate
    }
}
