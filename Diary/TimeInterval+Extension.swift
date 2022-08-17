//
//  TimeInterval+Extension.swift
//  Diary
//
//  Created by unchain, 웡빙 on 2022/08/17.
//

import Foundation

extension TimeInterval {
    func translateToDate() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .long
        dateFormatter.locale = Locale(identifier: "ko_kr")
        dateFormatter.timeZone = TimeZone.current
        let date = Date(timeIntervalSince1970: self)
        let dateString = dateFormatter.string(from: date)
        return dateString
    }
}
