//
//  Diary.swift
//  Diary
//
//  Created by rilla, songjun on 2023/04/24.
//

import Foundation

struct Diary: Codable, Hashable, Identifiable {
    let id = UUID()
    let title: String
    let body: String
    let timeIntervalSince1970: Int
    
    enum CodingKeys: String, CodingKey {
        case title
        case body
        case timeIntervalSince1970 = "created_at"
    }
}
