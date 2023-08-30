//
//  DateFormatter+.swift
//  Diary
//
//  Created by idinaloq, yetti on 2023/08/30.
//

import Foundation

extension DateFormatter {
    static var today: String {
        let dateFormatter: DateFormatter = DateFormatter()
        let date: Date = Date(timeIntervalSinceNow: 0)
        dateFormatter.locale = Locale(identifier: "ko_KR")
        dateFormatter.timeZone = TimeZone(abbreviation: "KST")
        dateFormatter.dateStyle = .long
        
        return dateFormatter.string(from: date)
    }
    
    func formatDate(_ data: DiaryEntity) -> String {
        let dateFormatter: DateFormatter = DateFormatter()
        let date: Date = Date(timeIntervalSince1970: TimeInterval(data.createdAt))
        dateFormatter.locale = Locale(identifier: "ko_KR")
        dateFormatter.timeZone = TimeZone(abbreviation: "KST")
        dateFormatter.dateStyle = .long
        
        return dateFormatter.string(from: date)
    }
}
