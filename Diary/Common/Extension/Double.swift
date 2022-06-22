//
//  Double.swift
//  Diary
//
//  Created by mmim, grumpy, mino on 2022/06/14.
//

import Foundation

extension Double {
    var formattedString: String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .long
        dateFormatter.locale = Locale(identifier: Locale.preferredLanguages.first ?? AppConstants.systemDefaultLanguage)
        return dateFormatter.string(from: Date(timeIntervalSince1970: self))
    }
}
