//
//  DiaryData.swift
//  Diary
//
//  Created by 김태현 on 2022/06/14.
//

import Foundation

private struct Formatter {
    static let dateFormatter = DateFormatter()
    
    private init() { }
    
    static func setUpDate(from timeInterval: Int) -> String {
        dateFormatter.dateStyle = .long
        dateFormatter.locale = .autoupdatingCurrent
        
        let date = Date(timeIntervalSinceReferenceDate: Double(timeInterval))
        let result = dateFormatter.string(from: date)
        return result
    }
}

struct DiaryData: Hashable {
    let identifier = UUID()
    
    let title: String
    let date: String
    let body: String
    
    init(data: SampleData) {
        title = data.title
        date = Formatter.setUpDate(from: data.date)
        body = data.body
    }
}
