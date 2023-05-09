//
//  DiaryDateFormatter.swift
//  Diary
//
//  Created by rilla, songjun on 2023/05/08.
//

import Foundation

final class DiaryDateFormatter {
    private enum LocalizationKey {
        static let dateFormat = "dateFormat"
    }
    
    static let shared = DiaryDateFormatter()
    private let dateFormatter = DateFormatter()
    
    lazy var nowDateText: String = {
        return convertToString(from: Date())
    }()
    
    lazy var nowTimeIntervalSince1970: Int = {
        return convertToInterval(from: Date())
    }()
    
    private init() { }
    
    func convertToInterval(from date: Date) -> Int {
        dateFormatter.timeZone = TimeZone.current
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        
        let localDateString = dateFormatter.string(from: date)
        let localDate = dateFormatter.date(from: localDateString) ?? Date()
        
        return Int(localDate.timeIntervalSince1970)
    }
    
    func convertToInterval(from date: String) -> Int {
        dateFormatter.dateFormat = LocalizationKey.dateFormat.localized()
        let localDate = dateFormatter.date(from: date) ?? Date()
        
        return Int(localDate.timeIntervalSince1970)
    }
    
    func convertToString(from date: Date) -> String {
        dateFormatter.dateFormat = LocalizationKey.dateFormat.localized()
        let convertString = dateFormatter.string(from: date)
        
        return convertString
    }
    
    func convertToString(from timeIntervalSince1970: Int) -> String {
        let date = Date(timeIntervalSince1970: TimeInterval(timeIntervalSince1970))
        dateFormatter.dateFormat = LocalizationKey.dateFormat.localized()
        let convertString = dateFormatter.string(from: date)
        
        return convertString
    }
}
