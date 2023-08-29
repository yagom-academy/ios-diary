//
//  Diary.swift
//  Diary
//
//  Created by redmango1446 on 2023/08/28.
//

struct Diary: Decodable {
    let title: String
    let body: String
    let createdDate: Int
    
    private enum CodingKeys: String, CodingKey {
        case title, body
        case createdDate = "created_at"
    }
}
