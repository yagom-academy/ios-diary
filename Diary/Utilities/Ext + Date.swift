//
//  Ext + Date.swift
//  Diary
//
//  Copyright (c) 2022 woong, jeremy All rights reserved.
//

import Foundation

extension Date {
    func convertDate() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.setLocalizedDateFormatFromTemplate("yyyyMMMd")
        dateFormatter.locale = Locale(identifier: "ko_KO")
        return dateFormatter.string(from: self)
    }
}
