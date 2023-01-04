//
//  Diary.swift
//  Diary
//
//  Created by 이태영 on 2022/12/20.
//

import Foundation

struct Diary: Hashable {
    var id: UUID
    var title: String
    var body: String
    var createdDate: Date
    var condition: WeatherEntity?
    
    init(
        id: UUID,
        title: String,
        body: String,
        timeInterval: TimeInterval,
        condition: WeatherEntity?
    ) {
        self.id = id
        self.title = title
        self.body = body
        self.createdDate = timeInterval.calculatedDate
        self.condition = condition
    }
}

extension Diary {
    func convertShareContent() -> String {
        return title + "\n\n" + body
    }
}
