//
//  Diary.swift
//  Diary
//
//  Created by 이태영 on 2022/12/20.
//

import Foundation

struct Diary: Decodable, Hashable {
    var title: String?
    var body: String?
    var createdIntervalValue: Int?
    var uuid: UUID?
    
    enum CodingKeys: String, CodingKey {
        case title
        case body
        case createdIntervalValue = "created_at"
    }
    
    var createdDate: String? {
        guard let createdIntervalValue = createdIntervalValue else {
            return nil
        }
        
        let timeInterval = TimeInterval(createdIntervalValue)
        let intervalDate = Date(timeIntervalSince1970: timeInterval)
        
        return intervalDate.convertString()
    }
    
    var createInt64: Int64 {
        guard let createdIntervalValue = createdIntervalValue else {
            return 0
        }
        return Int64(createdIntervalValue)
    }
    
    var id: UUID {
        guard let uuid = uuid else {
            return UUID()
        }
        
        return uuid
    }
}
