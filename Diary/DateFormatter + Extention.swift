//
//  DateFormatter + Extention.swift
//  Diary
//
//  Created by yeton, hyeon2  on 2022/08/18.
//

import Foundation

extension DateFormatter {
    // diaryDateLabel.text = format(data: item.createdAt)
    func format(data: Date) -> String {
        self.dateStyle = .long
        self.timeStyle = .none
        self.locale = Locale.current

        return self.string(from: data)
    }
}
