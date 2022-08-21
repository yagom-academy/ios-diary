//
//  DiaryModel.swift
//  Diary
//
//  Created by bonf, bard on 2022/08/16.
//

import Foundation

struct DiaryModel: Decodable, Hashable {
    private let uuid = UUID()
    let title: String
    let body: String
    let createdAt: TimeInterval
    
    enum CodingKeys: String, CodingKey {
        case title
        case body
        case createdAt = "created_at"
    }
}
