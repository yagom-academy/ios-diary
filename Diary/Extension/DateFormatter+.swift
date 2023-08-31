//
//  DateFormatter+.swift
//  Diary
//
//  Created by hoon, karen on 2023/08/30.
//

import Foundation

extension DateFormatter {
    static let diaryFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .long
        formatter.locale = Locale.current
        
        return formatter
    }()
}
