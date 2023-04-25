//
//  DiaryModel.swift
//  Diary
//
//  Created by kaki, 레옹아범 on 2023/04/25.
//

import Foundation

struct DiaryModel: Decodable {
    var title: String
    var body: String
    var date: Int
    
    enum CodingKeys: String, CodingKey {
        case title, body
        case date = "created_at"
    }
}
