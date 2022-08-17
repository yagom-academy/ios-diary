//
//  Date+Extensions.swift
//  Diary
//
//  Created by Hugh, Derrick on 2022/08/17.
//

import Foundation

extension Date {
    var fetchCurrentDate: String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .long
        dateFormatter.timeStyle = .none
        
        return dateFormatter.string(from: self)
    }
}
