//
//  DiarySampleData.swift
//  Diary
//
//  Created by 전민수 on 2022/08/16.
//

import Foundation

struct DiarySampleData: Decodable {
    let title: String
    let body: String
    let createdAt: Int
    
    enum CodingKeys: String, CodingKey {
        case title, body
        case createdAt = "created_at"
    }
}
