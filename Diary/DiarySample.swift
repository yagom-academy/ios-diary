//
//  DiarySample.swift
//  Diary
//
//  Created by yeton, hyeon2 on 2022/08/17.
//

import Foundation

struct DiarySample: Decodable, Hashable {
    let id = UUID()
    
    let title: String
    let body: String
    let createdAt: Int
    
    enum CodingKeys: String, CodingKey {
        case title, body
        case createdAt = "created_at"
    }
}
