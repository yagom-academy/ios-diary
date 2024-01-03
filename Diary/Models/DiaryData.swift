//
//  DiaryData.swift
//  Diary
//
//  Created by Toy, Morgan on 1/2/24.
//

import Foundation

struct DiaryData: Decodable {
    let title: String
    let body: String
    let createdAt: Int
    
    enum CodingKeys: String, CodingKey {
        case title
        case body
        case createdAt = "created_at"
    }
}
