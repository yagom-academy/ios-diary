//
//  diary.swift
//  Diary
//
//  Created by Aaron, Gundy, Rhovin on 2022/12/20.
//

import Foundation

final class Diary: Codable {
    let title: String
    let body: String
    let createdAt: Double
    
    enum CodingKeys: String, CodingKey {
        case title
        case body
        case createdAt = "created_at"
    }
}

extension Diary {
    var createdDate: Date {
        return Date(timeIntervalSince1970: createdAt)
    }
}

extension Diary: Hashable {
    func hash(into hasher: inout Hasher) {
        hasher.combine(ObjectIdentifier(self).hashValue)
    }
    
    static func == (lhs: Diary, rhs: Diary) -> Bool {
        return lhs === rhs
    }
}
