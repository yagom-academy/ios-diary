//
//  String+Extension.swift
//  Diary
//
//  Created by rilla, songjun on 2023/04/25.
//

import Foundation

extension Int {
    private enum LocalizationKey {
        static let dateFormat = "dateFormat"
    }
    
    func convertFormattedDate() -> String {
        
        let date = Date(timeIntervalSince1970: TimeInterval(self))
                
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = String.localized(key: LocalizationKey.dateFormat)
        
        let convertString = dateFormatter.string(from: date)
        
        return convertString
    }
}
