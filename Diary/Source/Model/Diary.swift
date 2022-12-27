//  Diary - Diary.swift
//  Created by Ayaan, zhilly on 2022/12/20

import Foundation

struct Diary: Hashable {
    var content: String
    var createdAt: Date
    var objectID: String?
    
    var firstNewLineIndex: String.Index? {
        return content.firstIndex(of: "\n")
    }
    var title: String {
        if let firstNewLineIndex = firstNewLineIndex {
            return String(content.prefix(through: firstNewLineIndex))
        } else {
            return content
        }
    }
    var body: String {
        if let firstNewLineIndex = firstNewLineIndex {
            let firstIndexOfBody = content.index(firstNewLineIndex, offsetBy: 1)
            return String(content.suffix(from: firstIndexOfBody))
        } else {
            return .init()
        }
    }
    
    init?(from diaryData: DiaryData) {
        guard let title = diaryData.title,
              let body = diaryData.body,
              let createdAt = diaryData.createdAt else {
            return nil
        }
        self.content = title + "\n" + body
        self.createdAt = createdAt
        self.objectID = diaryData.objectID.uriRepresentation().absoluteString
    }
    
    init(content: String, createdAt: Date) {
        self.content = content
        self.createdAt = createdAt
    }
}
