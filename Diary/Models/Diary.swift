//
//  Diary.swift
//  Diary
//
//  Created by Kyo, Baem on 2022/12/19.
//

import Foundation

struct Diary: Decodable, Hashable {
    var uuid = UUID()
    var title: String
    var body: String
    var createdAt: Int
        
    enum CodingKeys: String, CodingKey {
        case title, body
        case createdAt = "created_at"
    }
    
    var customDate: String {
        let date = Date(timeIntervalSince1970: Double(self.createdAt))
        return Formatter.changeCustomDate(date)
    }
}
