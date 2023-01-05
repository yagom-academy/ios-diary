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
    let weatherMain: String?
    let weatherIcon: String?

    enum CodingKeys: String, CodingKey {
        case title
        case body
        case createdAt = "created_at"
        case weatherMain = "main"
        case weatherIcon = "icon"
    }
}

extension DiaryResponseDTO {
    func toDomain() -> Diary {
        var diary = Diary(title: title,
                          body: body,
                          createdAt: Date(timeIntervalSince1970: createdAt))

        guard let main = weatherMain,
              let icon = weatherIcon else {
            return diary
        }
        diary.weather = Weather(main: main, icon: icon)

        return diary
    }
}

struct Diary: Hashable {
    let title: String
    let body: String
    let createdAt: Date
    let uuid: UUID
    var weather: Weather?

    init(title: String, body: String, createdAt: Date, uuid: UUID = UUID(), weather: Weather? = nil) {
        self.title = title
        self.body = body
        self.createdAt = createdAt
        self.uuid = uuid
        self.weather = weather
    }
}

extension DiaryEntity {
    func toDomain() -> Diary {
        var diary = Diary(title: title ?? "",
                          body: body ?? "",
                          createdAt: createdAt ?? Date(),
                          uuid: uuid ?? UUID())

        guard let main = weatherMain,
              let icon = weatherIcon else {
            return diary
        }
        diary.weather = Weather(main: main, icon: icon)

        return diary
    }
}
