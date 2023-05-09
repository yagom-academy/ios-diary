//
//  String+Extension.swift
//  Diary
//
//  Created by rilla, songjun on 2023/04/27.
//

import Foundation

extension String {
    func localized() -> String {
        return String(format: NSLocalizedString(self, comment: ""))
    }
}
