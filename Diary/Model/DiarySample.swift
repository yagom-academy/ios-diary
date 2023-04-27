//
//  DiarySample.swift
//  Diary
//
//  Created by Rowan, Harry on 2023/04/25.
//

struct DiarySample: Decodable {
    let title, body: String
    let createdDate: Double

    enum CodingKeys: String, CodingKey {
        case title, body
        case createdDate = "created_at"
    }
}
