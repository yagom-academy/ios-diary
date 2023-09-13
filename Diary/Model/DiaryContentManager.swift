//
//  DiaryContentManager.swift
//  Diary
//
//  Created by Dasan, kyungmin on 2023/09/12.
//

import Foundation

struct DiaryContentManager {
    func convert(with text: String, _ diary: Diary) -> Diary {
        var textComponents = text.components(separatedBy: NameSpace.splitFormat)
        var title = textComponents.removeFirst()
        var body = textComponents.joined(separator: NameSpace.splitFormat)

        if title.isEmpty {
            title = NameSpace.noTitle
        }

        return Diary(
            identifier: diary.identifier,
            title: title,
            body: body,
            createdDate: diary.createdDate
        )
    }

    func convert(with diary: Diary) -> String {
        if diary.title.isEmpty && diary.body.isEmpty {
            return ""
        }
        
        return String(format: NameSpace.combineFormat, diary.title, diary.body)
    }
}

extension DiaryContentManager {
    private enum NameSpace {
        static let combineFormat = "%@\n%@"
        static let splitFormat = "\n"
        static let noTitle = "제목 없음"
    }
}
