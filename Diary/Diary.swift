//  Diary - Diary.swift
//  Created by Ayaan, zhilly on 2022/12/20

struct Diary: Decodable, Hashable {
    let title: String
    let body: String
    let createdAt: String
    
    enum CodingKeys: String, CodingKey {
        case title, body
        case createdAt = "created_at"
    }
}
