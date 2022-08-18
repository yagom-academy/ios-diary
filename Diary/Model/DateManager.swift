//
//  DateManager.swift
//  Diary
//
//  Created by 백곰,주디 on 2022/08/17.
//

import Foundation

struct DateManager {
    func formatted(date: Date) -> String {
        let formatterDate = DateFormatter()
        formatterDate.dateStyle = .long
        formatterDate.timeStyle = .none
        formatterDate.locale = Locale.current
        
        return formatterDate.string(from: date)
    }
}
