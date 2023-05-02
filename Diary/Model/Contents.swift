//
//  Contents.swift
//  Diary
//
//  Created by KokkilE, Hyemory on 2023/04/24.
//

import Foundation

struct Contents: Codable {
    let title: String
    let body: String
    let date: Double
    let identifier: UUID?
    var localizedDate: String {
        let date = Date(timeIntervalSince1970: date)
        return date.translateLocalizedFormat()
    }
    
    private enum CodingKeys: String, CodingKey {
        case title, body, identifier
        case date = "created_at"
    }
}
