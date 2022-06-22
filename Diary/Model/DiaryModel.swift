//
//  DiaryModel.swift
//  Diary
//
//  Created by Donnie, OneTool on 2022/06/15.
//

import Foundation

struct DiaryModel: Decodable {
    let title: String?
    let body: String?
    let createdAt: TimeInterval
    let id: String
    
    private enum CodingKeys: String, CodingKey {
        case createdAt = "created_at"
        case title, body, id
    }
}
