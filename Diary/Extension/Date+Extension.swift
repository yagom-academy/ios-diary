//
//  Date+Extension.swift
//  Diary
//
//  Created by rilla, songjun on 2023/04/25.
//

import Foundation

extension Date {
    static let nowDate: String = {
        return convertFormattedDate()
    }()
    
    private static func convertFormattedDate() -> String {
        let date = Date()
                
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy년 MM월 dd일"
        
        let convertString = dateFormatter.string(from: date)
        
        return convertString
    }
}
