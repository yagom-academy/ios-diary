//
//  DiaryEditable.swift
//  Diary
//
//  Created by Mary & Whales on 2023/09/17.
//

import Foundation

protocol DiaryEditable {
    var diaryContents: [DiaryContent] { get }
    func refresh() throws
    func insert(diaryContent: DiaryContent) throws
    func update(diaryContent: DiaryContent) throws
    func delete(id: UUID) throws
}
