//
//  Date+Extension.swift
//  Diary
//
//  Created by Finnn, 수꿍 on 2022/08/16.
//

import Foundation

extension Date {
    func formatToStringDate() -> String? {
        let dateFormatter = DateFormatter()
        
        guard let localeID = Locale.preferredLanguages.first,
              let deviceLocale = Locale(identifier: localeID).languageCode else { return nil }
        
        dateFormatter.dateStyle = .long
        dateFormatter.timeStyle = .none
        
        dateFormatter.locale = Locale(identifier: deviceLocale)
        dateFormatter.timeZone = TimeZone.current
        
        return dateFormatter.string(from: self)
    }
}
