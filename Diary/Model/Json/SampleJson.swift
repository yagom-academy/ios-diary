//
//  SampleJson.swift
//  Diary
//
//  Created by Kiwi, Brad. on 2022/08/16.
//

import Foundation

struct SampleJson: Decodable {
    let title, body: String
    let createdAt: Int

    enum CodingKeys: String, CodingKey {
        case title, body
        case createdAt = "created_at"
    }
}
