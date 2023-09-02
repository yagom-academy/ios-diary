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
        let data: [DiaryContentDTO] = try DecodingManager.decodeJSON(fileName: name)
        var contents: [DiaryContent] = []
        
        data.forEach { element in
            let date = Date(timeIntervalSince1970: element.timeInterval)
            let formattedDate = DiaryDateFormatter().format(from: date)
            
            contents.append(DiaryContent(title: element.title, body: element.body, date: formattedDate))
        }
        
        diaryContents = contents
    }
}
