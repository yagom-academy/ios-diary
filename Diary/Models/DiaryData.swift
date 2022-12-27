//
//  Diary.swift
//  Diary
//
//  Created by jin on 12/21/22.
//

import Foundation

struct DiaryData: Decodable {
    
    let title: String
    let body: String
    let createdAt: Double
    
    private enum CodingKeys: String, CodingKey {
        case title, body
        case createdAt = "created_at"
    }
}
