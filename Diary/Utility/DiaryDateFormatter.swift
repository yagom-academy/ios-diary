//
//  DiaryDateFormatter.swift
//  Diary
//
//  Created by Mary & Whales on 2023/08/30.
//

import Foundation

struct DiaryDateFormatter {
    private let dateFormatter = DateFormatter()
    
    func format(from date: Date, by form: String) -> String {
        dateFormatter.locale = Locale(identifier: Locale.current.identifier)
        dateFormatter.setLocalizedDateFormatFromTemplate(form)
        
        return dateFormatter.string(from: date)
    }
}
