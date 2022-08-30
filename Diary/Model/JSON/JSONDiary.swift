//
//  JSONDiary.swift
//  Diary
//
//  Created by 백곰, 주디 on 2022/08/30.
//

struct JSONDiary: Decodable {
    let title: String
    let body: String
    let createdAt: Double
    
    private enum CodingKeys: String, CodingKey {
        case title
        case body
        case createdAt = "created_at"
    }
}
