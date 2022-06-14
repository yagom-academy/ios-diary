//
//  DiaryData.swift
//  Diary
//
//  Created by 두기, marisol on 2022/06/14.
//

import Foundation

struct DiaryData: Decodable {
    let title: String?
    let body: String?
    let createdAt: Double?
    
    private enum CodingKeys: String, CodingKey {
        case title, body
        case createdAt = "created_at"
    }
}

struct Diary {
    let title: String
    let body: String
    let createdAt: String
}
