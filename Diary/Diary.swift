//
//  Diary.swift
//  Diary
//
//  Created by Hisop on 2024/01/03.
//

import Foundation

class Diary: Codable {
    let title: String
    let body: String
    let createdAt: Int
    
    private enum CodingKeys: String, CodingKey {
        case title
        case body
        case createdAt = "created_at"
    }
}
