//
//  Diary.swift
//  Diary
//
//  Created by rilla, songjun on 2023/04/24.
//

import Foundation

struct Diary: Codable, Hashable {
    let id = UUID()
    let title: String
    let body: String
    let createdDate: Int
    
    enum CodingKeys: String, CodingKey {
        case title
        case body
        case createdDate = "created_at"
    }
}
