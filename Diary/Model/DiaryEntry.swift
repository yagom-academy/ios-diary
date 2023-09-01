//
//  DiaryEntry.swift
//  Diary
//
//  Created by Erick on 2023/08/29.
//

import Foundation

struct DiaryEntry: Hashable {
    let id: UUID
    let title: String
    let body: String
    let creationDate: String
    
    init(title: String, body: String, creationDate: String) {
        self.id = UUID()
        self.title = title
        self.body = body
        self.creationDate = creationDate
    }
}
