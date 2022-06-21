//
//  DiaryDateFormatter.swift
//  Diary
//
//  Created by 우롱차, RED on 2022/06/14.
//

import Foundation

final class DiaryDateFormatter {
    private enum Constant {
        static let dateFormatString: String = "yyyy년 MM월 dd일"
    }
    
    private var dateFormatter: DateFormatter
    static let shared = DiaryDateFormatter()
    
    private init() {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: Locale.current.identifier)
        formatter.timeZone = TimeZone(identifier: TimeZone.current.identifier)
        formatter.dateFormat = Constant.dateFormatString
        dateFormatter = formatter
    }

    func string(from data: Date) -> String {
        return dateFormatter.string(from: data)
    }
}
