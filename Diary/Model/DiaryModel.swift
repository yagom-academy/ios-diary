//
//  DiaryModel.swift
//  Diary
//
//  Created by unchain, 웡빙 on 2022/08/17.
//

import Foundation

struct DiaryModel: Decodable {
    let title: String
    let body: String
    let createdAt: Double
    let weatherIcon: String
    
    enum CodingKeys: String, CodingKey {
        case title
        case body
        case createdAt = "created_at"
        case weatherIcon
    }
}
