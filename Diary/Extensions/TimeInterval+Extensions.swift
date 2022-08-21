//
//  TimeInterval+Extensions.swift
//  Diary
//
//  Created by Hugh, Derrick on 2022/08/16.
//

import Foundation

extension TimeInterval {
    var formattedDate: String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .long
        return dateFormatter.string(from: Date(timeIntervalSince1970: self))
    }
}
