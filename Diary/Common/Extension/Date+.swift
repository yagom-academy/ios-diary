//
//  Contents.swift
//  Diary
//
//  Created by KokkilE, Hyemory on 2023/04/25.
//

import Foundation

extension Date {
    func translateLocalizedFormat() -> String {
        let formatter = DateFormatter()
        
        formatter.locale = Locale(identifier: Locale.preferredLanguages.first ?? Locale.current.identifier)
        formatter.dateStyle = .long
        
        return formatter.string(from: self)
    }
}
