//
//  Double+Extensions.swift
//  Diary
//
//  Created by minsson on 2022/08/17.
//

import Foundation

extension TimeInterval {
    
    // MARK: Methods
    
    func localizedFormat() -> String {
        let formattedDate = Date(timeIntervalSince1970: self)

        let dateFormatter: DateFormatter = {
            let dateFormatter = DateFormatter()
            dateFormatter.locale = NSLocale.autoupdatingCurrent
            dateFormatter.dateStyle = .long

            return dateFormatter
        }()
        
        return dateFormatter.string(from: formattedDate)
    }
}
