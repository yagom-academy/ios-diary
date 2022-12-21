//  Diary - Diary.swift
//  Created by Ayaan, zhilly on 2022/12/20

import Foundation

struct Diary: Decodable {
    let id: UUID = UUID()
    let title: String
    let body: String
    let createdAt: Double
    
    enum CodingKeys: String, CodingKey {
        case title, body
        case createdAt = "created_at"
    }
    
    init(
        title: String = "",
        body: String = "",
        createdAt: Double = Date().timeIntervalSince1970.rounded()
    ) {
        self.title = title
        self.body = body
        self.createdAt = createdAt
    }
}

extension Diary: Hashable {
    static func == (_ lhs: Diary, _ rhs: Diary) -> Bool {
        return (lhs.id == rhs.id)
    }
}
