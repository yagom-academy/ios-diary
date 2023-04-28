//
//  DateFormatterExtension.swift
//  Diary
//
//  Created by Andrew, brody on 2023/04/25.
//

import UIKit

extension DateFormatter {
    convenience init(languageIdentifier: String, style: DateFormatter.Style = .long) {
        self.init()
        locale = Locale(identifier: languageIdentifier)
        dateStyle = style
    }
}
