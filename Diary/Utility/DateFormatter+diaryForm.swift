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
        
        return dateFormatter
    }()
    
    func localizeDateString(from date: Date) -> String {
        return self.string(from: date)
    }
}
