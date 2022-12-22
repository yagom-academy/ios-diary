//
//  Diary.swift
//  Diary
//
//  Created by Mangdi on 2022/12/20.
//

import Foundation

struct Diary: Codable, Identifiable {
    let id: UUID = UUID()
    let title, body: String
    let createdAt: Double

    enum CodingKeys: String, CodingKey {
        case title, body
        case createdAt = "created_at"
    }
}
