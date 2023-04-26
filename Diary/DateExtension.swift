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
        formatter.locale = Locale(identifier: Locale.preferredLanguages.first ?? Locale.current.identifier)
        formatter.dateStyle = .long
        return formatter
    }()
}
