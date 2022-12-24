//
//  Diary.swift
//  Diary
//
//  Created by 써니쿠키, LJ on 2022/12/20.
//

import Foundation

struct Diary: Decodable, Hashable {
    
    let title: String
    let body: String
    let createdAt: Double
    let id = UUID()
    
    enum CodingKeys: String, CodingKey {
        case title, body
        case createdAt = "created_at"
    }
    
    var createdDate: String {
        return Date(timeIntervalSince1970: createdAt).localizedDateFormat
    }
}
