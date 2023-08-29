//
//  UserDateFormatter.swift
//  Diary
//
//  Created by Erick on 2023/08/29.
//

import Foundation

final class UserDateFormatter: LocaleDateFormatterProtocol {
    var dateFormatter: DateFormatter = {
        let userLocale = Locale.current
        let userTimeZone = TimeZone.current
        
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: userLocale.identifier)
        dateFormatter.setLocalizedDateFormatFromTemplate("dd MMM yyyy")
        dateFormatter.timeZone = TimeZone(identifier: userTimeZone.identifier)

        return dateFormatter
    }()
}
