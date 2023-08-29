//
//  DiaryEntity.swift
//  Diary
//
//  Created by Maxhyunm, Hamg on 2023/08/29.
//

import Foundation

struct DiaryEntity: Decodable {
    let title: String
    let body: String
    let createdAt: Date
    
    private enum CodingKeys: String, CodingKey {
        case title, body
        case createdAt = "created_at"
    }
}
