//
//  TimeInterval.swift
//  Diary
//
//  Created by 조민호 on 2022/06/14.
//

import Foundation

extension TimeInterval {
    var formattedString: String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .long
        dateFormatter.locale = Locale(identifier: Locale.preferredLanguages.first ?? "ko_KR")
        return dateFormatter.string(from: Date(timeIntervalSince1970: self))
    }
}
