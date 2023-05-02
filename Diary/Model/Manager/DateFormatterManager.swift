//
//  DateFormatterManager.swift
//  Diary
//
//  Created by 리지, Goat on 2023/04/24.
//

import Foundation

final class DateFormatterManager {
    static let shared = DateFormatterManager()
    private init() { }
    
    private let dateFormatter: DateFormatter = {
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: Locale.current.identifier)
        dateFormatter.dateStyle = .long
        
        return dateFormatter
    }()
    
    func convertToFomattedDate(of date: Double) -> String? {
        let date = Date(timeIntervalSince1970: date)
        
        return dateFormatter.string(from: date)
    }
}
