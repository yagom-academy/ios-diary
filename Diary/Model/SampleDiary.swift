//
//  SampleDiary.swift
//  Diary
//
//  Created by 리지, Goat on 2023/04/24.
//

struct SampleDiary: Decodable {
    let title: String
    let body: String
    let createdDate: Double
    
    enum CodingKeys: String, CodingKey {
        case title, body
        case createdDate = "created_at"
    }
}
