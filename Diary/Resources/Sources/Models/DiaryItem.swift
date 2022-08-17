//
//  DiaryItem.swift
//  Diary
//
//  Created by 민쏜, 보리사랑 on 2022/08/17.
//

import Foundation

struct DiaryItem: Decodable {
    
    // MARK: - Properties
    
    var title: String
    var body: String
    let createdDate: TimeInterval
    
    // MARK: - Enums(CodingKeys)
    
    private enum CodingKeys: String, CodingKey {
        case title
        case body
        case createdDate = "created_at"
    }
}
