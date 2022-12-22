//
//  Diary.swift
//  Diary
//
//  Created by 애종, 애쉬 on 2022/12/20.
//

import UIKit

struct Diary: Decodable, Hashable {
    let id = UUID()
    let title: String
    let body: String
    let createdAt: Int
    
    private enum CodingKeys: String, CodingKey {
        case title, body
        case createdAt = "created_at"
    }
}
