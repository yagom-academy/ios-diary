//
//  Entity.swift
//  Diary
//
//  Created by 이시원 on 2022/06/24.
//

import Foundation

struct Weather: Codable {
    let id: Int
    let main: String
    let weatherDescription: String
    let icon: String

    enum CodingKeys: String, CodingKey {
        case id
        case main
        case weatherDescription = "description"
        case icon
    }
}
