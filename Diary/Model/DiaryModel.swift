//
//  DiaryModel.swift
//  Diary
//
//  Created by Donnie, OneTool on 2022/06/15.
//

import UIKit

struct DiaryModel: Decodable {
    let title: String?
    let body: String?
    let createdAt: Date
    let id: String
    var weatherImage: String
    
    private enum CodingKeys: String, CodingKey {
        case createdAt = "created_at"
        case title, body, id, weatherImage
    }
}
