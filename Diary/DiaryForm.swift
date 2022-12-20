//
//  DiaryForm.swift
//  Diary
//
//  Created by SummerCat and som on 2022/12/20.
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
