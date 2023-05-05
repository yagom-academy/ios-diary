//
//  SampleDiary.swift
//  Diary
//
//  Created by 리지, Goat on 2023/04/24.
//

struct SampleDiary: Decodable {
    var title: String
    var body: String
    var createdDate: Double
    
    enum CodingKeys: String, CodingKey {
        case title, body
        case createdDate = "created_at"
    }
}
