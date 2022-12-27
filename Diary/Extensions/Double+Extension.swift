//
//  Double+Extension.swift
//  Diary
//
//  Created by 애종, 애쉬 on 2022/12/27.
//

import Foundation

extension Double {
    func convertDate() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .long
        dateFormatter.timeStyle = .none
        
        let localeLanguage = Locale.preferredLanguages.first
        dateFormatter.locale = Locale(identifier: localeLanguage ?? "ko-kr")
        
        return dateFormatter.string(from: Date(timeIntervalSince1970: self))
    }
}
