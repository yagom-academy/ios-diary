//
//  DiaryModel.swift
//  Diary
//
//  Created by kaki, 레옹아범 on 2023/04/25.
//

import Foundation

struct JsonDiary: Decodable {
    var title: String
    var body: String
    var date: Double
    
    var content: String {
        return title + "\n\n" + body
    }
    
    private enum CodingKeys: String, CodingKey {
        case title, body
        case date = "created_at"
    }
    
    init(title: String = "", body: String = "", date: Double = Date().timeIntervalSince1970) {
        self.title = title
        self.body = body
        self.date = date
    }
}
