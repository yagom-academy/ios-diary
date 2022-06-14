//
//  DateFormatter+extension.swift
//  Diary
//
//  Created by safari, Eddy on 2022/06/14.
//

import Foundation

extension DateFormatter {
    func changeDateFormat(time: Int) -> String {
        self.dateStyle = .long
        self.timeStyle = .none
        self.locale = Locale.current
        let time = Date(timeIntervalSince1970: TimeInterval(time))
        
        return self.string(from: time)
    }
}

