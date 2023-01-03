//
//  CurrentDiary.swift
//  Diary
//
//  Created by Kyo, Baem on 2023/01/03.
//

import Foundation

struct CurrentDiary {
    var id: UUID?
    var contentText: String?
    var createdAt: Date?
    var main: String?
    var iconID: String?
    
    init(id: UUID? = nil,
         contentText: String? = nil,
         createdAt: Date? = nil,
         main: String? = nil,
         iconID: String? = nil) {
        self.id = id
        self.contentText = contentText
        self.createdAt = createdAt
        self.main = main
        self.iconID = iconID
    }
}
