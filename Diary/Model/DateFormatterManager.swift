//
//  DateFormatterManager.swift
//  Diary
//
//  Created by 리지, Goat on 2023/04/24.
//

import Foundation

class DateFormatterManager {
    static let shared = DateFormatterManager()
    private init() { }
    
    private let dateFormatter: DateFormatter = {
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: Locale.current.identifier)
        dateFormatter.dateStyle = .long
        
        return dateFormatter
    }()
    
    func convertToFomattedDate(of date: Int) -> String? {
        let date = Date(timeIntervalSince1970: TimeInterval(date))
        
        return dateFormatter.string(from: date)
    }
}
