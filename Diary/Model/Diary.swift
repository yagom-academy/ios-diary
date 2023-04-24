//
//  Diary - Diary.swift
//  Created by Rhode, 무리.
//  Copyright © yagom. All rights reserved.
//

struct Diary: Decodable {
    let title: String
    let body: String
    let date: Int
    
    private enum CodingKeys: String, CodingKey {
        case title, body
        case date = "created_at"
    }
}
