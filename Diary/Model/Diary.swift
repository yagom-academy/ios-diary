//
//  Diary.swift
//  Diary
//
//  Created by MINT, BMO on 2023/08/28.
//

import Foundation

struct Diary: Decodable {
    let title: String
    let body: String
    private let unixTime: Int
    private let dateFormatter = DateFormatter()
    var date: String {
        return dateFormatter.transformDiaryDate(using: unixTime)
    }
    
    private enum CodingKeys: String, CodingKey {
        case title
        case body
        case unixTime = "created_at"
    }
}
