//
//  Diary.swift
//  Diary
//
//  Created by 백곰, 주디 on 2022/08/16.
//

import Foundation

struct DiaryItem {
    let id: UUID
    let title: String
    let body: String
    let createdAt: Double
    
    init(id: UUID, title: String, body: String, createdAt: Double) {
        self.id = id
        self.title = title
        self.body = body
        self.createdAt = createdAt
    }
}
