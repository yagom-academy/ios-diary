//
//  DateFormattable.swift
//  Diary
//
//  Created by 김민성 on 2023/09/07.
//

import Foundation

protocol DateFormattable {
    func format(date: Date, style: DateFormatter.Style) -> String
}
