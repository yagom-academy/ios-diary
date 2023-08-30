//
//  DateFormatter+.swift
//  Diary
//
//  Created by Kobe, Moon on 2023/08/29.
//

import Foundation

extension DateFormatter {
    static let shared: DateFormatter = DateFormatter()
    
    func convertDate(_ date: Date, _ locale: String) -> String {
        self.locale = Locale(identifier: locale)
        let region = String(locale.suffix(2))
        let localeID = Region(region: region)
        let dateFormat = localeID.dateFormat
        self.dateFormat = dateFormat
        
        return self.string(from: date)
    }
    
    func fetchDate(_ createdAt: Int, _ locale: String) -> String {
        let timeInterval = TimeInterval(createdAt)
        let date = Date(timeIntervalSince1970: timeInterval)
        
        return self.convertDate(date, locale)
    }
    
    
}
extension DateFormatter {
    enum Region: String {
        case korea = "KR"
        case usa = "US"
        case japan = "JP"
        case notSupported = "notSupported"
        
        init(region: String) {
            switch region {
            case "KR":
                self = .korea
            case "US":
                self = .usa
            case "JP":
                self = .japan
            default:
                self = .notSupported
            }
        }
        
        var dateFormat: String {
            switch self {
            case .korea:
                return "yyyy년 MM월 dd일"
            case .usa:
                return "MMM d, yyyy"
            case .japan:
                return "yyyy/MM/dd"
            case .notSupported:
                return "yyyy-MM-dd"
            }
        }
    }
}
