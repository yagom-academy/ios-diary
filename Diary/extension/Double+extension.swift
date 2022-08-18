//
//  Double+extension.swift
//  Diary
//
//  Created by NAMU on 2022/08/18.
//

import Foundation

extension Double {
    func convertDate() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .long
        dateFormatter.locale = Locale(identifier: Locale.preferredLanguages.first ?? "ko")
    
        return dateFormatter.string(from: Date(timeIntervalSince1970: self))
    }
}
