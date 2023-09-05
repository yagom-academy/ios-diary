//
//  DateManager.swift
//  Diary
//
//  Created by Dasan, kyungmin on 2023/08/31.
//

import Foundation

struct DateManager {
    func todayString() -> String {
        let dataFormatter = DateFormatter()
        let createdDate = dataFormatter.dateString(
            from: Date(),
            at: getPreferredLocale(),
            with: DateManager.FormatTemplate.attached
        )
        
        return createdDate
    }
    
    func getPreferredLocale() -> String {
        guard let preferredIdentifier = Locale.preferredLanguages.first else {
            return Locale.current.description
        }
        return preferredIdentifier
    }
}

extension DateManager {
    enum FormatTemplate {
        static let attached = "MMMMddyyyy"
    }
}
