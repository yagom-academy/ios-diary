//
//  Diary.swift
//  Diary
//
//  Created by Mangdi, junho on 2022/12/20.
//

import Foundation

struct Diary: Identifiable {
    let id: UUID
    var title, body: String
    let createdAt: TimeInterval

    init(id: UUID = UUID(), title: String, body: String, createdAt: TimeInterval) {
        self.id = id
        self.title = title
        self.body = body
        self.createdAt = createdAt
    }
}
