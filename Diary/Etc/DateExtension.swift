//
//  DateExtension.swift
//  Diary
//
//  Created by kaki, 레옹아범 on 2023/04/25.
//

import Foundation

extension Date {
    static private let formatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy년 MM월 dd일"
        
        return formatter
    }()
    
    func convertToDate() -> String {
        let dateText = Date.formatter.string(from: self)
        
        return dateText
    }
}
