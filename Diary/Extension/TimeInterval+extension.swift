//
//  TimeInterval+extension.swift
//  Diary
//
//  Created by Donnie, OneTool on 2022/06/15.
//

import Foundation

extension TimeInterval {
    var formattedDate: String {
        let dateFormatter = DateFormatter()
        let localID = Locale.preferredLanguages.first
        let deviceLocale = Locale(identifier: localID ?? "ko-kr").languageCode
        dateFormatter.dateStyle = .long
        dateFormatter.locale = Locale(identifier: deviceLocale ?? "ko-kr")
        dateFormatter.timeZone = TimeZone.current
        return dateFormatter.string(from: Date(timeIntervalSince1970: self))
    }
}
