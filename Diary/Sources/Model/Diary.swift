//
//  Diary.swift
//  Diary
//
//  Created by 이태영 on 2022/12/20.
//

import Foundation

struct Diary: Decodable, Hashable {
    let title: String
    let body: String
    let createdDate: Date
    let uuid = UUID()
    
    enum CodingKeys: String, CodingKey {
        case title
        case body
        case createdDate = "created_at"
    }
}
