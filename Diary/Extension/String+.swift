//
//  String+.swift
//  Diary
//
//  Created by JPush, Wonbi on 2023/01/03.
//

import Foundation

extension String {
    var localized: String {
        return NSLocalizedString(self, comment: "")
    }
}
