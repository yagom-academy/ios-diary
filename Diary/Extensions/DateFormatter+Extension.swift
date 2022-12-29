//
//  DateFormatter+Extension.swift
//  Diary
//
//  Created by 애종, 애쉬 on 2022/12/20.
//

import Foundation

extension DateFormatter {
    var longDate: String {
        self.dateStyle = .long
        self.timeStyle = .none
        
        let localeLanguage = Locale.preferredLanguages.first
        self.locale = Locale(identifier: localeLanguage ?? "ko-kr")
        
        return self.string(from: Date())
    }
    
    func convertDateToDouble() -> Double {
        let timeInterval = Date().timeIntervalSince1970
        return timeInterval
    }
}
