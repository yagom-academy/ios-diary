//
//  DiaryManager.swift
//  Diary
//
//  Created by Kiwi, Brad. on 2022/08/23.
//

class DiaryManager: DBMangerable {
    
    let stubDBManager = StubDBManager()
    
    func loadData() {
        self.stubDBManager.loadData()
    }
    
    func count() -> Int {
        return self.stubDBManager.count()
    }
    
    func content(index: Int) -> SampleDiaryContent {
        return self.stubDBManager.diaryContent(index: index)
    }
}
