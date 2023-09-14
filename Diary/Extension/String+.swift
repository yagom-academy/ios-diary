//
//  String+.swift
//  Diary
//
//  Created by Mary & Whales on 2023/09/15.
//

extension String {
    var localized: String {
        return String(localized: LocalizationValue(self))
    }
}
