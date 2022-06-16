//
//  DiaryData.swift
//  Diary
//
//  Created by 김태현 on 2022/06/14.
//

import Foundation

struct DiaryData: Decodable, Hashable {
    let identifier = UUID()
    
    let title: String
    let body: String
    let date: Int
    
    var dateString: String {
        return Formatter.setUpDate(from: date)
    }
    
    enum CodingKeys: String, CodingKey {
        case title
        case body
        case date = "created_at"
    }
}
