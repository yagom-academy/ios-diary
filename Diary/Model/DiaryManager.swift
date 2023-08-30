//
//  DiaryManager.swift
//  Diary
//
//  Created by Mary & Whales on 2023/08/30.
//

import OSLog

struct DiaryManager {
    func fetchDiaryContents(name: String) -> [DiaryContent]? {
        do {
            let data: [DiaryContentDTO] = try DecodingManager.decodeJSON(fileName: name)
            var contents: [DiaryContent] = []
            
            data.forEach { element in
                let date = Date(timeIntervalSince1970: element.timeInterval)
                let formattedDate = DiaryDateFormatter().format(from: date, by: "yyyyMMMd")
                
                contents.append(DiaryContent(title: element.title, body: element.body, date: formattedDate))
            }
            
            return contents
        } catch {
            os_log("%{public}@", type: .default, error.localizedDescription)
            
            return nil
        }
    }
}
