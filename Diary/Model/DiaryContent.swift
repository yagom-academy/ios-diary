//
//  DiaryContent.swift
//  Diary
//
//  Created by Mary & Whales on 8/30/23.
//

import Foundation

struct DiaryContent: Decodable {
    let id = UUID()
    var title: String
    var body: String
    let timeInterval: Double
    var date: String {
        let date = Date(timeIntervalSince1970: timeInterval)
        let formattedDate = DateFormatter().format(from: date, dateStyle: .long, timeStyle: .none)
        
        return formattedDate
    }
    
    private enum CodingKeys: String, CodingKey {
        case title, body
        case timeInterval = "created_at"
    }
}
