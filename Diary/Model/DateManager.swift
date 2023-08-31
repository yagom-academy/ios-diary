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
                at: Locale.current.identifier,
                with: DateManager.FormatTemplate.attached
            )
        return createdDate
    }
}

extension DateManager {
    enum FormatTemplate {
        static let attached = "MMMMddyyyy"
    }
}
