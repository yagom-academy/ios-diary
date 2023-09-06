//
//  DiaryManager.swift
//  Diary
//
//  Created by Mary & Whales on 2023/08/30.
//

import OSLog

struct DiaryManager {
    var diaryContents: [DiaryContent]?
    
    mutating func fetchDiaryContents(name: String) throws {
        let data: [DiaryContent] = try DecodingManager.decodeJSON(fileName: name, by: JSONDecoder())
        
        diaryContents = data
    }
}
