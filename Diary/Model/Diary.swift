//
//  Diary.swift
//  Diary
//
//  Created by bonf, bard on 2022/08/16.
//

import Foundation

struct Diary: Decodable, Hashable {
    let uuid: UUID
    var title: String
    var body: String
    let createdAt: TimeInterval
    let icon: String
    
    enum CodingKeys: String, CodingKey {
        case uuid
        case title
        case body
        case createdAt = "created_at"
        case icon
    }
    
    mutating func modify(title: String) {
        self.title = title
    }
    
    mutating func modify(body: String) {
        self.body = body
    }
}
