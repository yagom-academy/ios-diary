//
//  TimeInterval+.swift
//  Diary
//
//  Copyright (c) 2022 Minii All rights reserved.

import Foundation

extension TimeInterval {
    var calculatedDate: Date {
        return Date(timeIntervalSince1970: self)
    }
    
    func isToday() -> Bool {
        let currentInterval = Date().timeIntervalSince1970
        let subtractedValue = (currentInterval - self)
        return subtractedValue < 86400
    }
}
