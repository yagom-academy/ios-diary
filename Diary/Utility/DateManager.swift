//
//  DateManager.swift
//  Diary
//
//  Created by Christy, vetto on 2023/04/25.
//

import Foundation

struct DateManger {
    static let shared = DateManger()
    
    private init() {}
    
    let dateFormatter: DateFormatter = {
        let dateFormatter = DateFormatter()
        
        dateFormatter.locale = Locale(identifier: Locale.preferredLanguages.first ?? Locale.current.identifier)
        dateFormatter.dateStyle = .long
        
        return dateFormatter
    }()
    
    func generateTodayDate() -> String {
        let date = Date()
        
        return dateFormatter.string(from: date)
    }
    
    func convertToDate(fromDouble: Double) -> String {
        let date: Date = Date(timeIntervalSince1970: fromDouble)
        
        return dateFormatter.string(from: date)
    }
}
