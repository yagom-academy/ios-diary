//
//  DateFormatter+.swift
//  Diary
//
//  Created by Maxhyunm, Hamg on 2023/08/29.
//

import Foundation

extension DateFormatter {
    func formatToString(from date: Date, with format: String) -> String {
        self.dateFormat = format
        
        return self.string(from: date)
    }
}
