//
//  DateFormatter+.swift
//  Diary
//
//  Created by MINT, BMO on 2023/08/29.
//

import Foundation

extension DateFormatter {
    func transformDiaryDate(using unixTime: Int) -> String {
        configureDiaryDateFormat()
        let date = Date(timeIntervalSince1970: TimeInterval(unixTime))
        return string(from: date)
    }
    func configureDiaryDateFormat() {
        dateStyle = .long
        timeStyle = .none
        locale = Locale(identifier: Locale.current.identifier)
    }
}
