//
//  String+Extension.swift
//  Diary
//
//  Created by kimseongjun on 2023/04/27.
//

import Foundation

extension String {
    static func localized(key: String) -> String {
        return String(format: NSLocalizedString(key, comment: ""))
    }
}
