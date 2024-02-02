//
//  Logger.swift
//  Diary
//
//  Created by Mary & Whales on 9/15/23.
//

import OSLog

struct Logger {
    func osLog(_ message: String) {
        os_log("%@", message)
    }
}
