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
        
    init(entity: DiaryEntity) {
        self.id = entity.id ?? UUID()
        self.title = entity.title ?? ""
        self.body = entity.body ?? ""
        self.createdAt = entity.createdAt
    }
}
