//
//  DBMangerable.swift
//  Diary
//
//  Created by Kiwi, Brad. on 2022/08/23.
//

import Foundation

protocol DBMangerable {
    func loadData()
    func saveDiary(model: DiaryContent)
    func updateData(item: DiaryContent)
    func deleteDiary(id: UUID)
    func diaryContent() -> [DiaryContent]
    func count() -> Int
    func content(index: Int) -> DiaryContent
    func fetchDiaryEntity() -> [Diary]
}
