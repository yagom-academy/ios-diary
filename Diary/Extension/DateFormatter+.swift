//
//  DateFormatter+.swift
//  Diary
//
//  Created by MINT, BMO on 2023/08/29.
//

import Foundation

extension DateFormatter {
    func transformDiaryDate(using unixTime: Int) -> String {
        congifureDiaryDateFormat()
        let date = Date(timeIntervalSince1970: TimeInterval(unixTime))
        return string(from: date)
    }
    func congifureDiaryDateFormat() {
        dateStyle = .long
        timeStyle = .none
        locale = Locale(identifier: "ko_KR")
        dateFormat = "yyyy년 MM월 dd일"
    }
}
