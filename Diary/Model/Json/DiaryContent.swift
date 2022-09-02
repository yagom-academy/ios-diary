//
//  DiaryContent.swift
//  Diary
//
//  Created by Kiwi, Brad. on 2022/08/16.
//

import Foundation

struct DiaryContent: Decodable {
    var id = UUID()
    var icon = String()
    let title, body: String
    let createdAt: Double
   
    enum CodingKeys: String, CodingKey {
        case title, body
        case createdAt = "created_at"
    }
}
