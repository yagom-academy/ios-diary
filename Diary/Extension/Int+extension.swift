//
//  Int+extension.swift
//  Diary
//
//  Created by safari, Eddy on 2022/06/14.
//

import Foundation

extension Int {
    func time() -> String {
        return DateFormatter().changeDateFormat(time: self)
    }
}
