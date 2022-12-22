//  Diary - Diary.swift
//  Created by Ayaan, zhilly on 2022/12/20

import Foundation

struct Diary: Decodable {
    let id: UUID = UUID()
    let title: String
    let body: String
    private let createdAt: Double
    var date: String {
        return DateFormatter.converted(date: Date(timeIntervalSince1970: createdAt),
                                       locale: Locale.preference,
                                       dateStyle: .long)
    }
    
    private enum CodingKeys: String, CodingKey {
        case title, body
        case createdAt = "created_at"
    }
    
    init(
        title: String = .init(),
        body: String = .init(),
        createdAt: Double = Date().timeIntervalSince1970.rounded()
    ) {
        self.title = title
        self.body = body
        self.createdAt = createdAt
    }
}

extension Diary: Hashable {
    static func == (_ lhs: Diary, _ rhs: Diary) -> Bool {
        return (lhs.id == rhs.id)
    }
}
