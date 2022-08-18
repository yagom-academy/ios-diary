//
//  Date+Extension.swift
//  Diary
//
//  Created by bonf, bard on 2022/08/17.
//

import Foundation

extension Date {
    func convertToCurrentTime() -> String {
        let dateFormatter = DateFormatter()
        guard let locale = Locale.preferredLanguages.first else { return "" }
        
        dateFormatter.locale = Locale.current
        dateFormatter.timeZone = .current
        dateFormatter.dateStyle = .long
        dateFormatter.locale = .init(identifier: locale)
        
        let stringDate = dateFormatter.string(from: self)
        
        return stringDate
    }
}
