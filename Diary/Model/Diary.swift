//
//  Diary.swift
//  Diary
//
//  Created by rilla, songjun on 2023/04/24.
//

import Foundation

struct Diary: Codable, Hashable {
    let title: String
    let body: String
    let createdAt: Int
    let identifier = UUID()

    enum CodingKeys: String, CodingKey {
        case title
        case body
        case createdAt = "created_at"
    }
}
