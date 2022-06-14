//
//  Diary.swift
//  Diary
//
//  Created by dudu, papri on 2022/06/14.
//

import Foundation

struct Diary: Decodable, Hashable {
    let title: String
    let body: String
    let createdDate: Date
    let id = UUID().uuidString
    
    enum CodingKeys: String, CodingKey {
        case title
        case body
        case createdDate = "created_at"
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        title = try values.decode(String.self, forKey: .title)
        body = try values.decode(String.self, forKey: .body)
        
        let interval = try values.decode(Double.self, forKey: .createdDate)
        
        createdDate = Date(timeIntervalSince1970: interval)
    }
}
