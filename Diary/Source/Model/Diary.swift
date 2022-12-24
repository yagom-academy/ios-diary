//
//  Diary.swift
//  Diary
//  Created by inho, dragon on 2022/12/20.
//

import Foundation

struct Diary: Decodable {
    let title: String
    let body: String
    let createdAt: Int
    
    var createdDate: String {
        let date = Date(timeIntervalSince1970: Double(createdAt))
        
        return DateFormatter.koreanDateFormatter.string(from: date)
    }
}
