//
//  Diary.swift
//  Diary
//
//  Created by mmim, grumpy, mino on 2022/06/14.
//

import Foundation

struct Diary: Decodable {
    let title: String
    let createdAt: Double
    let body: String
    let id: String
    
    private enum CodingKeys: String, CodingKey {
        case title, body, id
        case createdAt = "created_at"
    }
}
