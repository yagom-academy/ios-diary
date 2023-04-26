//
//  DateFormatter+diaryForm.swift
//  Diary
//
//  Created by Rowan, Harry on 2023/04/25.
//

import Foundation

extension DateFormatter {
    static let diaryForm = {
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .long
        dateFormatter.locale = Locale(identifier: Locale.current.identifier)
        
        return dateFormatter
    }()
}
