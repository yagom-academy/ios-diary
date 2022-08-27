//
//  Date+Extensions.swift
//  Diary
//
//  Created by Hugh, Derrick on 2022/08/17.
//

import Foundation

extension Date {
    static var currentFormattedDate: String? {
        let date = Date()
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .long
        dateFormatter.timeStyle = .none
        
        guard let language = Locale.preferredLanguages.first else {
            return nil
        }
        dateFormatter.locale = Locale(identifier: language)
        
        return dateFormatter.string(from: date)
    }
}
