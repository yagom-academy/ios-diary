//
//  Diary.swift
//  Diary
//
//  Created by jin on 12/21/22.
//

import Foundation

struct Diary: Decodable {
    let title: String
    let body: String
    let createdAt: TimeInterval
    
    private enum CodingKeys: String, CodingKey {
        case title, body
        case createdAt = "created_at"
    }
}
