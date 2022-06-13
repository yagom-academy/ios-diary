//
//  Diary.swift
//  Diary
//
//  Created by safari, Eddy on 2022/06/13.
//

import Foundation

struct Diary: Codable, Hashable {
    let title, body: String
    let createdAt: Int

    enum CodingKeys: String, CodingKey {
        case title, body
        case createdAt = "created_at"
    }
}
