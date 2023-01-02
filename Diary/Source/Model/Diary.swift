//  Diary - Diary.swift
//  Created by Ayaan, zhilly on 2022/12/20

import Foundation

struct Diary: ManagedObjectModel {
    var content: String
    var createdAt: Date
    var objectID: String?
    
    init?(from diaryData: DiaryData) {
        guard let title = diaryData.title,
              let body = diaryData.body,
              let createdAt = diaryData.createdAt else {
            return nil
        }
        self.content = title + body
        self.createdAt = createdAt
        self.objectID = diaryData.objectID.uriRepresentation().absoluteString
    }
}
