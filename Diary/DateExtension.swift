//
//  DateExtension.swift
//  Diary
//
//  Created by Andrew, brody on 2023/04/25.
//

import UIKit

extension Date {
    static let dateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy년 MM월 dd일"
        formatter.locale = Locale.current
        return formatter
    }()
}
