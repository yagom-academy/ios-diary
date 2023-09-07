//
//  CurrentDateFormatter.swift
//  Diary
//
//  Created by 김민성 on 2023/09/07.
//

import Foundation

final class CurrentDateFormatter: DateFormattable {
    private let dateFormatter: DateFormatter = {
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .long
        dateFormatter.locale = .current
        
        return dateFormatter
    }()
    
    func format(date: Date) -> String {
        dateFormatter.string(from: date)
    }
}
