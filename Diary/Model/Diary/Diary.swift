//
//  Diary.swift
//  Diary
//
//  Created by dudu, papri on 2022/06/14.
//

import Foundation

struct Diary: Hashable {
    let title: String
    let body: String
    let createdDate: Date
    let id: String
    var weather: Weather?

    init(title: String, body: String, createdDate: Date, id: String = UUID().uuidString, weather: Weather?) {
        self.title = title
        self.body = body
        self.createdDate = createdDate
        self.id = id
        self.weather = weather
    }
    
    var isEmpty: Bool {
        return title == "" && body == ""
    }
    
    mutating func setWeather(_ weather: Weather?) {
        self.weather = weather
    }
}
