//
//  DiaryEntry.swift
//  Diary
//
//  Created by Erick on 2023/08/29.
//

import Foundation

struct DiaryEntry: Hashable {
    let id: UUID
    var title: String
    var body: String
    let creationDate: String
    
    init(id: UUID, title: String, body: String, creationDate: String) {
        self.id = id
        self.title = title
        self.body = body
        self.creationDate = creationDate
    }
    
    init(title: String, body: String) {
        self.id = UUID()
        self.title = title
        self.body = body
        self.creationDate = DateFormatManager.dateString(localeDateFormatter: UserDateFormatter.shared)
    }
}
