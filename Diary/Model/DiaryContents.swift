//
//  DiarySample.swift
//  Diary
//
//  Created by Rowan, Harry on 2023/04/25.
//

import Foundation

struct DiaryContents: Decodable {
    let title, body: String?
    let createdDate: Double
    let id: UUID = UUID()
    
    var createdDateText: String? {
        let date = Date(timeIntervalSince1970: createdDate)
        
        return DateFormatter.diaryForm.string(from: date)
    }

    enum CodingKeys: String, CodingKey {
        case title, body
        case createdDate = "created_at"
    }
}
