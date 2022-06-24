//
//  Diary.swift
//  Diary
//
//  Created by dudu, papri on 2022/06/14.
//

import Foundation

struct Diary: Hashable {
    let title: String
    let body: String
    let createdDate: Date
    let id: String

    init(title: String, body: String, createdDate: Date, id: String = UUID().uuidString) {
        self.title = title
        self.body = body
        self.createdDate = createdDate
        self.id = id
    }
    
    var isEmpty: Bool {
        return title == "" && body == ""
    }
}
