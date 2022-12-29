//
//  Ext + Int.swift
//  Diary
//
//  Copyright (c) 2022 woong, jeremy All rights reserved.
//

import Foundation

extension Int64 {
    func convertDate() -> String {
        let dateFormatter = DateFormatter()
        let date = Date(timeIntervalSince1970: TimeInterval(self))
        dateFormatter.setLocalizedDateFormatFromTemplate("YYYYMMMMd")
        dateFormatter.locale = Locale(identifier: "ko_KO")
        
        return dateFormatter.string(from: date)
    }
}
