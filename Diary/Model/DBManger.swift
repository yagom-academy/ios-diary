//
//  DBManager.swift
//  Diary
//
//  Created by Kiwi, Brad. on 2022/08/23.
//

import Foundation

protocol DBMangerable {
    func loadData()
    func count() -> Int
    func content(index: Int) -> SampleDiaryContent
}

class StubDBManager: DBMangerable {
        
    private var sampleDiaryContent = [SampleDiaryContent]() {
        didSet {
            NotificationCenter.default.post(name: .diaryModelDataDidChanged,
                                            object: self)
        }
    }
    
    func loadData() {
        guard let data: [SampleDiaryContent]? = JSONDecoder.decodedJson(jsonName: "sample"),
              let data = data else {
            return
        }
        self.sampleDiaryContent = data
    }
    
    func updateData() -> [SampleDiaryContent] {
        return sampleDiaryContent
    }
    
    func count() -> Int {
        return self.sampleDiaryContent.count
    }
    
    func content(index: Int) -> SampleDiaryContent {
        return self.sampleDiaryContent[index]
    }
}
