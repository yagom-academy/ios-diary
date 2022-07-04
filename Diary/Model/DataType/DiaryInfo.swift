//
//  DiaryInfo.swift
//  Diary
//
//  Created by 우롱차, RED on 2022/06/16.
//

import Foundation

protocol DataModelable {
    static var entityName: String { get }
}

struct DiaryInfo: DataModelable, Equatable {
    init(title: String?, body: String?, date: Date?, key: UUID?, weather: String? = nil, icon: String? = nil) {
        self.title = title
        self.body = body
        self.date = date
        self.key = key
        self.weather = weather
        self.icon = icon
    }
    
    static let entityName = "DiaryData"
    
    let title: String?
    let body: String?
    let date: Date?
    let key: UUID?
    let weather: String?
    let icon: String?
}
