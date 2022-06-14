//
//  DiaryData.swift
//  Diary
//
//  Created by 우롱차, RED on 2022/06/14.
//

import Foundation

struct DiaryData: Decodable {
    private(set) var title: String
    private(set) var date: Date
    private(set) var body: String
    
    enum CodingKeys: String, CodingKey {
        case title
        case body
        case date = "created_at"
    }
}
