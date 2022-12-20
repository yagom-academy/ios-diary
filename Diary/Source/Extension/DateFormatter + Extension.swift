//
//  DateFormatter + Extension.swift
//  Diary
//  Created by inho, dragon on 2022/12/20.
//

import Foundation

extension DateFormatter {
    static let koreanDateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "ko_KR")
        formatter.dateFormat = "yyyy년 MM월 dd일"
        return formatter
    }()
}
