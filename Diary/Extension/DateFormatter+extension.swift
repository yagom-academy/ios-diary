//
//  DateFormatter+extension.swift
//  Diary
//
//  Created by safari, Eddy on 2022/06/14.
//

import Foundation

extension DateFormatter {
    static var currentDate: String = {
        let dataFormatter = DateFormatter()
        dataFormatter.dateStyle = .long
        dataFormatter.timeStyle = .none
        dataFormatter.locale = Locale.current
        
        return dataFormatter.string(from: Date())
    }()
    
    func changeDateFormat(time: Date?) -> String? {
        self.dateStyle = .long
        self.timeStyle = .none
        self.locale = Locale.current
        guard let time = time else {
            return nil
        }

        return self.string(from: time)
    }
}
