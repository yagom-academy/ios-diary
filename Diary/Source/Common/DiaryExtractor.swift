//  Diary - DiaryExtractor.swift
//  Created by Ayaan, zhilly on 2023/01/02

import Foundation

enum DiaryExtractor {
    typealias DiaryCellContents = (title: String, body: String, createdAt: String)
    
    private enum Constant {
        static let defaultTitle = "제목 없음"
        static let defaultBody = "내용 없음"
    }
    
    static func extract(of diary: Diary) -> DiaryCellContents {
        let contents = diary.content
            .components(separatedBy: .newlines)
            .filter { $0.isEmpty == false }
        let title = contents.first ?? Constant.defaultTitle
        let body = contents.count >= 2 ? contents[1] : Constant.defaultBody
        let createdAt = DateFormatter.converted(date: diary.createdAt,
                                                locale: Locale.preference,
                                                dateStyle: .long)
    
        return (title, body, createdAt)
    }
}
