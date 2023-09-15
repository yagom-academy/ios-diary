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
        let body = textComponents.joined(separator: NameSpace.splitFormat)

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
            return NameSpace.empty
        }
        
        return String(format: NameSpace.combineFormat, diary.title, diary.body)
    }
    
    func isDiaryTextEmpty(_ text: String) -> Bool {
        return text.isEmpty
    }
}

extension DiaryContentManager {
    private enum NameSpace {
        static let combineFormat = "%@\n%@"
        static let splitFormat = "\n"
        static let noTitle = "제목 없음"
        static let empty = ""
    }
}
