//
//  DiarySample.swift
//  Diary
//
//  Created by Rowan, Harry on 2023/04/25.
//

struct WelcomeElement: Codable {
    let title, body: String
    let createdAt: Int

    enum CodingKeys: String, CodingKey {
        case title, body
        case createdAt = "created_at"
    }
}
