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

        let title = textComponents.removeFirst() + "\n"
        let body = textComponents.reduce("") { partialResult, element in
            return partialResult + element + "\n"
        }

        return Diary(
            identifier: diary.identifier,
            title: title,
            body: body,
            createdDate: diary.createdDate
        )
    }

    func convert(with diary: Diary) -> String {
        if diary.title.isEmpty && !diary.body.isEmpty {
            return String(format: NameSpace.combineFormat, "제목 없음", diary.body)
        }
        
        if !diary.title.isEmpty && diary.body.isEmpty {
            return String(format: NameSpace.combineFormat, diary.title, "내용 없음")
        }

        return String(format: NameSpace.combineFormat, diary.title, diary.body)
    }
}

extension DiaryContentManager {
    private enum NameSpace {
        static let combineFormat = "%@%@"
        static let splitFormat = "\n"
    }
}
