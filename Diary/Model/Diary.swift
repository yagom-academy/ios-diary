//
//  Diary.swift
//  Diary
//
//  Created by 두기, marisol on 2022/06/14.
//

import Foundation

struct Diary {
    var title: String
    var body: String
    var text: String
    let createdAt: Double
    let id: UUID
    let weather: Weather?
}

struct Weather {
    let main: String?
    let iconID: String?
    let iconImage: Data?
}
