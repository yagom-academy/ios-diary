//
//  Diary.swift
//  Diary
//
//  Created by safari, Eddy on 2022/06/13.
//

import Foundation

struct Diary: Hashable {
    let title: String?
    let body: String?
    let createdAt: Date
    let uuid: UUID

    private enum CodingKeys: String, CodingKey {
        case title, body
        case createdAt = "created_at"
    }
    
    init(title: String, body: String, createdAt: Date, uuid: UUID = UUID()) {
        self.title = title
        self.body = body
        self.createdAt = createdAt
        self.uuid = uuid
    }
}
