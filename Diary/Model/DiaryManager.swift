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
            let data: [DiaryContent] = try DecodingManager.decodeJSON(fileName: name)
            
            return data
        } catch {
            os_log("%{public}@", type: .default, error.localizedDescription)
        }
        
        return nil
    }
}
