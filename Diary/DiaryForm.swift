//
//  DiaryForm.swift
//  Diary
//
//  Created by SummerCat and som
//

import Foundation

struct DiaryForm: Decodable {
    let title: String
    let body: String
    let createdAt: Int
    
    enum CodingKeys: String, CodingKey {
        case title, body
        case createdAt = "created_at"
    }
}
