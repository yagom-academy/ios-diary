//
//  Diary.swift
//  Diary
//
//  Created by 애종, 애쉬 on 2022/12/20.
//

struct Diary: Decodable, Hashable {
    let title: String
    let body: String
    let createdAt: Int
    
    enum CodingKeys: String, CodingKey {
        case title, body
        case createdAt = "created_at"
    }
}
