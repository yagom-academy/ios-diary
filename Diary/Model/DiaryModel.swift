//
//  DiaryModel.swift
//  Diary
//
//  Created by Donnie, OneTool on 2022/06/15.
//

import Foundation

struct DiaryModel {
    let title: String?
    let body: String?
    let createdAt: TimeInterval?
    
    private enum CodingKeys: String, CodingKey {
        case createdAt = "created_at"
        case title, body
    }
}
