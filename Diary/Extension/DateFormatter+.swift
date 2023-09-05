//
//  DateFormatter+.swift
//  Diary
//
//  Created by MINT, BMO on 2023/08/29.
//

import Foundation

extension DateFormatter {
    func configureDiaryDateFormat() {
        dateStyle = .long
        timeStyle = .none
        locale = Locale(identifier: Locale.current.identifier)
    }
}
