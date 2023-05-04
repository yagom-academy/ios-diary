//
//  String+Extension.swift
//  Diary
//
//  Created by rilla, songjun on 2023/04/27.
//

import Foundation

extension String {
    static func localized(key: String) -> String {
        return String(format: NSLocalizedString(key, comment: ""))
    }
    
    func convertToTimeInterval() -> Int {
        let dateFormatter = DateFormatter()
        
        dateFormatter.dateFormat = String.localized(key: "dateFormat")
        
        let localDate = dateFormatter.date(from: self) ?? Date()
        
        return Int(localDate.timeIntervalSince1970)
    }
}
