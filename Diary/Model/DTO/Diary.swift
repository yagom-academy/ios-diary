//
//  Diary.swift
//  Diary
//
//  Created by Erick on 2023/08/28.
//

import Foundation

struct Diary: Decodable {
    let title: String
    let body: String
    let creationDate: Int
    
    private enum CodingKeys: String, CodingKey {
        case title
        case body
        case creationDate = "created_at"
    }
}

extension Diary {
    func diaryEntry() -> DiaryEntry {
        let creationDate = DateFormatManager.string(localeDateFormatter: UserDateFormatter.shared, timestamp: creationDate)
        
        return DiaryEntry(id: UUID(), title: title, body: body, creationDate: creationDate)
    }
}
