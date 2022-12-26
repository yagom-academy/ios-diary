//
//  Diary.swift
//  Diary
//
//  Created by 써니쿠키, LJ on 2022/12/20.
//

import Foundation

struct DiaryPage: Decodable, Hashable {
    
    var title: String
    var body: String
    let createdAt: Double
    var id = UUID()
    
    enum CodingKeys: String, CodingKey {
        case title, body
        case createdAt = "created_at"
    }
    
    var createdDate: String {
        return Date(timeIntervalSince1970: createdAt).localizedDateFormat
    }
}
