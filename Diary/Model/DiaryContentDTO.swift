//
//  DiaryContentDTO.swift
//  Diary
//
//  Created by Mary & Whales on 8/30/23.
//

struct DiaryContentDTO: Decodable {
    var title: String
    var body: String
    var timeInterval: Double
    
    private enum CodingKeys: String, CodingKey {
        case title, body
        case timeInterval = "created_at"
    }
}
