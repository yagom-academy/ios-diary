//
//  Int+Extension.swift
//  Diary
//
//  Created by Finnn, 수꿍 on 2022/08/16.
//

import Foundation

extension Int {
    var localizedString: String? {
        guard let localeID = Locale.preferredLanguages.first,
              let deviceLocale = Locale(identifier: localeID).languageCode else {
            return nil
        }
        
        let timeInterval = TimeInterval(self)
        let convertedDate = Date(timeIntervalSince1970: timeInterval)
        let dateFormatter = DateFormatter()
        
        dateFormatter.dateStyle = .long
        dateFormatter.timeStyle = .none
        dateFormatter.locale = Locale(identifier: deviceLocale)
        dateFormatter.timeZone = TimeZone.current
        
        return dateFormatter.string(from: convertedDate)
    }
}
