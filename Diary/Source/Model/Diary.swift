//  Diary - Diary.swift
//  Created by Ayaan, zhilly on 2022/12/20

import Foundation

struct Diary: Hashable {
    var content: String
    var createAt: Date
    
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
            return String(content.suffix(from: firstNewLineIndex))
        } else {
            return .init()
        }
    }
    
    init?(from diaryData: DiaryData) {
        guard let title = diaryData.title,
              let body = diaryData.body,
              let createAt = diaryData.createAt else {
            return nil
        }
        self.content = title + "\n" + body
        self.createAt = createAt
    }
    
    init(content: String, createAt: Date) {
        self.content = content
        self.createAt = createAt
    }
}
