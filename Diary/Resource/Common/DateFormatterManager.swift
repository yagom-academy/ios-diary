//
//  DateFormatterManager.swift
//  Diary
//
//  Created by SummerCat and som on 2022/12/20.
//

import Foundation

struct DateFormatterManager {
    func formatDate(_ date: Date) -> String {
        return DateFormatter.localizedString(from: date, dateStyle: .long, timeStyle: .none)
    }
}
