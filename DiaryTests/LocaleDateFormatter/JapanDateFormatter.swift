//
//  JapanDateFormatter.swift
//  DateFormatManagerTests
//
//  Created by Erick on 2023/08/30.
//

import Foundation
@testable import Diary

final class JapanDateFormatter: LocaleDateFormatterProtocol {
    var dateFormatter: DateFormatter = {
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "ja_JP")
        dateFormatter.setLocalizedDateFormatFromTemplate("dd MMM yyyy")
        dateFormatter.timeZone = TimeZone(identifier: "Asia/Tokyo")

        return dateFormatter
    }()
}
