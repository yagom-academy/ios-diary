//
//  DiarySample.swift
//  Diary
//
//  Created by yeton, hyeon2 on 2022/08/17.
//

struct DiarySample: Decodable, Hashable {
    let title: String
    let body: String
    let createdAt: Int
    
    enum CodingKeys: String, CodingKey {
        case title, body
        case createdAt = "created_at"
    }
}
