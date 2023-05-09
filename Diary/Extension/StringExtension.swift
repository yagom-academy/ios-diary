//
//  StringExtension.swift
//  Diary
//
//  Created by Andrew, brody on 2023/05/04.
//

import Foundation

extension String {
    func localized(comment: String = "") -> String {
        return NSLocalizedString(self, comment: comment)
    }
}
