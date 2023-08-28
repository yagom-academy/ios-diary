//
//  DiaryEntry.swift
//  Diary
//
//  Created by Erick on 2023/08/28.
//

struct DiaryEntry: Decodable {
    let title: String
    let body: String
    let creationDate: Int
    
    private enum CodingKeys: String, CodingKey {
        case title
        case body
        case creationDate = "created_at"
    }
}
