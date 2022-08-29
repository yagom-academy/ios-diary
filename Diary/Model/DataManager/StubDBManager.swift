//
//  StubDBManager.swift
//  Diary
//
//  Created by Kiwi, Brad. on 2022/08/25.
//

import Foundation

final class StubDBManager: DBMangerable {
    
    private var sampleDiaryContent = [DiaryContent]() {
        didSet {
            NotificationCenter.default.post(name: .diaryModelDataDidChanged,
                                            object: self)
        }
    }
    
    func loadData() {
        guard let data: [DiaryContent]? = JSONDecoder.decodedJson(jsonName: "sample"),
              let data = data else { return }
        self.sampleDiaryContent = data
    }
    
    func getData() -> [DiaryContent] {
        return self.sampleDiaryContent
    }
    
    func count() -> Int {
        return self.sampleDiaryContent.count
    }
    
    func content(index: Int) -> DiaryContent {
        return self.sampleDiaryContent[index]
    }
    
    func saveDiary(model: DiaryContent) { }
    func deleteDiary(id: UUID) { }
    func updateData(item: DiaryContent) { }
    func fetchDiaryEntity() -> [Diary] {
        return [Diary]()
    }
}
