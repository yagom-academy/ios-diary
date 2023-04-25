//
//  Contents.swift
//  Diary
//
//  Created by KokkilE, Hyemory on 2023/04/24.
//

import Foundation

struct Contents: Codable {
    let title: String
    let description: String
    let date: Int
    var localizedDate: String {
        let date = Date(timeIntervalSince1970: Double(date))
        return date.translateLocalizedFormat()
    }
    
    private enum CodingKeys: String, CodingKey {
        case title
        case description = "body"
        case date = "created_at"
    }
}
