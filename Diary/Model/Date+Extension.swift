//
//  Date+Extension.swift
//  Diary
//
//  Created by 써니쿠키, LJ on 2022/12/21.
//

import Foundation

extension Date {
    
    var localizedDateFormat: String {
        return DateFormatter.localizedString(from: self, dateStyle: .long, timeStyle: .none)
    }
}
