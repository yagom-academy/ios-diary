//
//  DiaryContentDTO.swift
//  Diary
//
//  Created by Mary & Whales on 8/30/23.
//

struct DiaryContentDTO: Decodable {
    let title: String
    let body: String
    let timeInterval: Double
    
    private enum CodingKeys: String, CodingKey {
        case title, body
        case timeInterval = "created_at"
    }
}
