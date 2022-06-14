//
//  Date+.swift
//  Diary
//
//  Created by dudu, papri on 2022/06/14.
//

import Foundation

extension Date {
    var formattedString: String {
        let dateFormatter = DateFormatter()
        dateFormatter.locale = .current
        dateFormatter.dateStyle = .long
        return dateFormatter.string(from: self)
    }
}
