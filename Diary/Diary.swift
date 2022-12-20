//  Diary - Diary.swift
//  Created by Ayaan, zhilly on 2022/12/20

import Foundation

struct Diary: Decodable {
    let id: UUID = UUID()
    let title: String
    let body: String
    let createdAt: Int
    
    enum CodingKeys: String, CodingKey {
        case title, body
        case createdAt = "created_at"
    }
}

extension Diary: Hashable {
    static func == (_ lhs: Diary, _ rhs: Diary) -> Bool {
        return (lhs.id == rhs.id)
    }
}
