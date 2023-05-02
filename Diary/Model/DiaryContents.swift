//
//  DiarySample.swift
//  Diary
//
//  Created by Rowan, Harry on 2023/04/25.
//

import Foundation

final class DiaryContents: Decodable {
    var title, body: String?
    var createdDate: Double
    let id: UUID = UUID()
    
    init(title: String?, body: String?, createdDate: Double) {
        self.title = title
        self.body = body
        self.createdDate = createdDate
    }
    
    var createdDateText: String? {
        let date = Date(timeIntervalSince1970: createdDate)
        
        return DateFormatter.diaryForm.string(from: date)
    }
    
    func updateContents(title: String?, body: String?, createdDate: Double) {
        self.title = title
        self.body = body
        self.createdDate = createdDate
    }

    enum CodingKeys: String, CodingKey {
        case title, body
        case createdDate = "created_at"
    }
}
