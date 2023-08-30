//
//  DateFormatterManager.swift
//  Diary
//
//  Created by 박종화 on 2023/08/30.
//

import Foundation

struct CustomDateFormatter {
    static let customDateFormatter: DateFormatter = {
        let todayDateFormatter = DateFormatter()
        todayDateFormatter.locale = Locale(identifier: "koKR")
        todayDateFormatter.dateFormat = "yyyy년 MM월 dd일"

        return todayDateFormatter
    }()

    static func formatTodayDate() -> String {
        let today = Date()
        let formattedTodayDate = customDateFormatter.string(from: today)

        return formattedTodayDate
    }

    static func formatSampleDate( sampleDate: Int) -> String {
        let timeInterval = TimeInterval(sampleDate)
        let inputDate = Date(timeIntervalSince1970: timeInterval)
        let formattedDate = customDateFormatter.string(from: inputDate)

        return formattedDate
    }
}
