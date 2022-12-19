//
//  Diary.swift
//  Diary
//
//  Created by Kyo, Baem on 2022/12/19.
//

import Foundation

struct Diary: Decodable {
    var title: String
    var body: String
    var createdAt: String
    
    enum CodingKeys: String, CodingKey {
        case title, body
        case createdAt = "created_at"
    }
    
    var date: Date {
        return Date(timeIntervalSince1970: Double(self.createdAt) ?? .zero)
    }
}
