//
//  Diary.swift
//  Diary
//
//  Created by 백곰, 주디 on 2022/08/16.
//

struct Diary {
    let title: String
    let body: String
    let createdAt: Int
    
    private enum CodingKeys: String, CodingKey {
        case title
        case body
        case createdAt = "created_at"
    }
}
