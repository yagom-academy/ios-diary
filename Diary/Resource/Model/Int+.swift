//
//  Int+.swift
//  Diary
//
//  Created by SummerCat and som on 2022/12/20.
//

import Foundation

extension Int {
    func formatDate() -> String {
        let formatter = DateFormatter()
        let timeInterval = TimeInterval(self)
        let date = Date(timeIntervalSince1970: timeInterval)
        formatter.dateFormat = "yyyy년 MM월 dd일"
        
        return formatter.string(from: date)
    }
}
