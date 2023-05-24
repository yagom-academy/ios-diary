//
//  Contents.swift
//  Diary
//
//  Created by KokkilE, Hyemory on 2023/04/24.
//

import Foundation

struct Contents: Codable {
    var title: String
    var body: String
    let date: Double
    let identifier: UUID?
    var weather: Weather?
    var localizedDate: String {
        let date = Date(timeIntervalSince1970: date)
        return date.translateLocalizedFormat()
    }
    
    private enum CodingKeys: String, CodingKey {
        case title, body, identifier, weather
        case date = "created_at"
    }
}
