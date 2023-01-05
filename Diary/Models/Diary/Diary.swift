//
//  Diary.swift
//  Diary
//
//  Created by Mangdi, junho lee, on 2022/12/20.
//

import UIKit

struct Diary: Identifiable {
    let id: UUID
    var title, body: String
    let createdAt: TimeInterval
    var main: String?
    var iconID: String?
    var iconImage: UIImage?

    init(id: UUID = UUID(),
         title: String,
         body: String,
         createdAt: TimeInterval,
         main: String? = nil,
         iconID: String? = nil) {
        self.id = id
        self.title = title
        self.body = body
        self.createdAt = createdAt
        self.main = main
        self.iconID = iconID
    }
}
