//
//  Diary - Double+.swift
//  Created by Rhode, 무리.
//  Copyright © yagom. All rights reserved.
//

import Foundation

extension Double {
    func roundDownNumber() -> Double? {
        let numberFormatter = NumberFormatter()
        numberFormatter.roundingMode = .floor
        
        guard let formattedString = numberFormatter.string(from: self as NSNumber),
              let result = Double(formattedString) else { return nil }
        
        return result
    }
}
