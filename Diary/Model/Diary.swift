//
//  Diary.swift
//  Diary
//
//  Created by 김성준 on 2023/04/24.
//

import Foundation

struct Diary: Codable {
    let title: String
    let body: String
    let createdAt: Int

    enum CodingKeys: String, CodingKey {
        case title
        case body
        case createdAt = "created_at"
    }
}

typealias Diaries = [Diary]
