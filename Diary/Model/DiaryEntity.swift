//
//  DiaryEntity.swift
//  Diary
//
//  Created by idinaloq, yetti on 2023/08/29.
//

struct DiaryEntity: Decodable {
    let title, body: String
    let createdAt: Int
    
    enum CodingKeys: String, CodingKey {
        case title, body
        case createdAt = "created_at"
    }
}
