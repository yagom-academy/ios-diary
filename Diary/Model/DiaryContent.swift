//
//  DiaryContent.swift
//  Diary
//
//  Created by JPush, Wonbi on 2022/12/20.
//

import Foundation

struct DiaryContent: Decodable {
    let title, body: String
    let createdAt: Double
    
    var createdDate: Date {
        return Date(timeIntervalSince1970: createdAt)
    }
    
    enum CodingKeys: String, CodingKey {
        case title, body
        case createdAt = "created_at"
    }
}
