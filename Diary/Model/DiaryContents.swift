//
//  DiarySample.swift
//  Diary
//
//  Created by Rowan, Harry on 2023/04/25.
//

import Foundation

struct DiaryContents: Decodable {
    let title, body: String
    let createdDate: Double
    let id: UUID

    enum CodingKeys: String, CodingKey {
        case title, body, id
        case createdDate = "created_at"
    }
}
