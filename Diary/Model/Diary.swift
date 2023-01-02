//
//  diary.swift
//  Diary
//
//  Created by Aaron, Gundy, Rhovin on 2022/12/20.
//

import Foundation

struct DiaryResponseDTO: Decodable {
    let title: String
    let body: String
    let createdAt: Double

    enum CodingKeys: String, CodingKey {
        case title
        case body
        case createdAt = "created_at"
    }
}

extension DiaryResponseDTO {
    func toDomain() -> Diary {
        let diary = Diary(title: title,
                          body: body,
                          createdAt: Date(timeIntervalSince1970: createdAt))

        return diary
    }
}

struct Diary: Hashable {
    let title: String
    let body: String
    let createdAt: Date
    let uuid: UUID

    init(title: String, body: String, createdAt: Date, uuid: UUID = UUID()) {
        self.title = title
        self.body = body
        self.createdAt = createdAt
        self.uuid = uuid
    }
}
