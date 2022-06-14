//
//  Diary.swift
//  Diary
//
//  Created by 박세웅 on 2022/06/14.
//

import Foundation

struct Diary: Decodable {
    let title: String
    let createdAt: Date
    let body: String
    
    private enum CodingKeys: String, CodingKey {
        case title, body
        case createdAt = "created_at"
    }
}
