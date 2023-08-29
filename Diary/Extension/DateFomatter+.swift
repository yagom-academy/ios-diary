//
//  DateFomatter+.swift
//  Diary
//
//  Created by kyungmin on 2023/08/29.
//

import Foundation

extension DateFormatter {
    func dateString(from date: Date, at locale: String, with template: String) -> String {
        self.locale = Locale(identifier: locale)
        self.setLocalizedDateFormatFromTemplate(template)
        
        return self.string(from: date)
    }
}

extension DateFormatter {
    enum FormatTemplate {
        static let attached = "MMMMddyyyy"
    }
    
    enum Location {
        static let korea = "ko_KR"
    }
}

