//
//  SampleData.swift
//  Diary
//
//  Copyright (c) 2022 woong, jeremy All rights reserved.
//

import Foundation

struct SampleData: Decodable, Hashable {
    var title: String
    var body: String
    let createdAt: Int
    let uuid: UUID = UUID()
    
    enum CodingKeys: String, CodingKey {
        case title
        case body
        case createdAt
    }
}
