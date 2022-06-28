//
//  DiaryData.swift
//  Diary
//
//  Created by 김태현 on 2022/06/14.
//

import Foundation

struct DiaryDTO: Decodable, Hashable {
    var identifier = UUID()
    
    var title: String
    var body: String
    let date: Date
    
    var dateString: String {
        return Formatter.setUpDate(from: date.timeIntervalSinceReferenceDate)
    }
    
    enum CodingKeys: String, CodingKey {
        case title
        case body
        case date = "created_at"
    }
    
    init(identifier: UUID? = nil, title: String, body: String, date: Date) {
        if let identifier = identifier {
            self.identifier = identifier
        }
        
        self.title = title
        self.body = body
        self.date = date
    }
    
    mutating func editData(_ newData: DiaryDTO) {
        self.title = newData.title
        self.body = newData.body
    }
}
