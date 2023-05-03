//
//  Diary - Date+.swift
//  Created by Rhode, 무리.
//  Copyright © yagom. All rights reserved.
//

import Foundation

extension Date {
    func convertDate() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy년 MM월 dd일"
        
        let convertedDate = dateFormatter.string(from: self)
        
        return convertedDate
    }
}
