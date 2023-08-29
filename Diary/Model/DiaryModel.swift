//
//  DiaryModel.swift
//  Diary
//
//  Created by hoon, karen on 2023/08/29.
//

import Foundation

struct DiaryModel: Decodable {
    let title: String
    let body: String
    let date: Int
    
    private enum CodingKeys: String, CodingKey {
        case title, body
        case date = "created_at"
    }
}
