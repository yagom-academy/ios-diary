//  Diary - Locale+Extension.swift
//  Created by Ayaan, zhilly on 2022/12/21

import Foundation

extension Locale {
    static var preference: Locale {
        guard let preferredLocaleIdentifier = Locale.preferredLanguages.first else { return current }
        return Locale(identifier: preferredLocaleIdentifier)
    }
}
