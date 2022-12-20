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
    let createdIntervalValue: Int
    let uuid = UUID()
    
    enum CodingKeys: String, CodingKey {
        case title
        case body
        case createdIntervalValue = "created_at"
    }
    
    var createDate: String? {
        let timeInterval = TimeInterval(createdIntervalValue)
        let intervalDate = Date(timeIntervalSince1970: timeInterval)
        
        return intervalDate.convertString()
    }
}
