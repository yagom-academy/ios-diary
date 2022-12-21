//
//  Ext + Int.swift
//  Diary
//
//  Created by 서현웅 on 2022/12/21.
//

import Foundation

extension Int {
    func convertDate() -> String {
        let dateFormatter = DateFormatter()
        let date = Date(timeIntervalSince1970: TimeInterval(self))
        dateFormatter.setLocalizedDateFormatFromTemplate("YYYYMMMMd")
        dateFormatter.locale = Locale(identifier: "ko_KO")
        return dateFormatter.string(from: date)
    }
}
