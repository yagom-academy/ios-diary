//
//  Date+Extension.swift
//  Diary
//
//  Created by 우롱차, RED on 2022/06/14.
//

import Foundation

extension Date {
    var toString: String {
            return DiaryDateFormatter.shared.string(from: self)
    }
}
