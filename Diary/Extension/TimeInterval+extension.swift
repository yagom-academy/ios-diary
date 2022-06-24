//
//  TimeInterval+extension.swift
//  Diary
//
//  Created by Donnie, OneTool on 2022/06/15.
//

import Foundation

extension Date {
    var formattedDate: String {
        let dateFormatter = DateFormatter()
        let localID = Locale.preferredLanguages.first
        let deviceLocale = Locale(identifier: localID ?? "ko-kr")
        dateFormatter.dateStyle = .long
        dateFormatter.locale = deviceLocale
        dateFormatter.timeZone = TimeZone.current
        return dateFormatter.string(from: self)
    }
}
