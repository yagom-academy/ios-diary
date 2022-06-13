//
//  SampleData.swift
//  Diary
//
//  Created by 김태현 on 2022/06/13.
//

import Foundation

struct SampleData: Decodable {
    let title: String
    let body: String
    let date: Int
    
    enum CodingKeys: String, CodingKey {
        case title
        case body
        case date = "created_at"
    }
}
