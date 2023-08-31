//
//  DiaryDateFormatter.swift
//  Diary
//
//  Created by Mary & Whales on 2023/08/30.
//

import Foundation

struct DiaryDateFormatter {
    private let dateFormatter = DateFormatter()
    
    func format(from date: Date) -> String {
        dateFormatter.locale = Locale.current
        dateFormatter.dateStyle = .long
        dateFormatter.timeStyle = .none
        dateFormatter.timeZone = .current
        
        return dateFormatter.string(from: date)
    }
}
