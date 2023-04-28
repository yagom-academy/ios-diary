//
//  DiaryItem.swift
//  Diary
//
//  Created by Andrew, brody on 2023/04/25.
//

import Foundation

struct DiaryItem: Decodable {
    let title: String
    let date: Int
    let body: String
    
    private enum CodingKeys: String, CodingKey {
        case title
        case date = "created_at"
        case body
    }
}
