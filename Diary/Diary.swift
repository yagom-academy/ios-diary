//
//  Diary.swift
//  Diary
//
//  Created by safari, Eddy on 2022/06/13.
//

import Foundation

struct Diary: Codable, Hashable {
    let title, body: String?
    let createdAt: Int?

    enum CodingKeys: String, CodingKey {
        case title, body
        case createdAt = "created_at"
    }

    static func createData() -> [Diary]? {
        return [Self].parse(name: "sample")
    }
}

private extension Decodable {
    static func parse(name: String) -> Self? {
        guard let path = Bundle.main.path(forResource: name, ofType: "json") else { return nil }
        guard let jsonString = try? String(contentsOfFile: path) else { return nil }
        guard let data = jsonString.data(using: .utf8) else { return nil }

        return try? JSONDecoder().decode(Self.self, from: data)
    }
}
