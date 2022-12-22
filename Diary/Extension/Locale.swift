//
//  Locale.swift
//  Diary
//
//  Created by Mangdi, junho lee on 2022/12/23.
//

import Foundation

extension Locale {
    static var currentLocale: Locale {
        if let preferredLanguage = Locale.preferredLanguages.first {
            return Locale(identifier: preferredLanguage)
        } else {
            return Locale.current
        }
    }
}
