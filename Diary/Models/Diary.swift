//
//  Diary.swift
//  Diary
//
//  Created by Mangdi, junho on 2022/12/20.
//

import Foundation

struct Diary: Codable, Identifiable {
    private(set) var id: UUID = UUID()
    var title, body: String
    let createdAt: TimeInterval

    init(id: UUID = UUID(), title: String, body: String, createdAt: TimeInterval) {
        self.id = id
        self.title = title
        self.body = body
        self.createdAt = createdAt
    }

    enum CodingKeys: String, CodingKey {
        case title, body
        case createdAt = "created_at"
    }
}
