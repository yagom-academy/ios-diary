//
//  DairySample.swift
//  Diary
//
//  Created by Zion, Serena on 2023/08/30.
//

import Foundation

struct DairySample: Decodable, Hashable {
    private let id: UUID = UUID()
    let title: String
    let body: String
    let date: Double
    
    private enum CodingKeys: String, CodingKey {
        case title
        case body
        case date = "created_at"
    }
}
