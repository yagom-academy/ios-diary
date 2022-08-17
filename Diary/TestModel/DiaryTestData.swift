//
//  DiaryTestData.swift
//  Diary
//
//  Created by 재재, 그루트 on 2022/08/17.
//

import Foundation

struct DiaryTestData: Decodable {
    let title: String
    let body: String
    let createdAt: Int
    
    private enum CodingKeys: String, CodingKey {
        case title, body
        case createdAt = "created_at"
    }
}
