//
//  Entity.swift
//  Diary
//
//  Created by 이시원 on 2022/06/24.
//

import Foundation

struct Weather: Codable {
    let icon: [Icon]
    
    enum CodingKeys: String, CodingKey {
        case icon = "weather"
    }
}

struct Icon: Codable {
    let icon: String?
}
