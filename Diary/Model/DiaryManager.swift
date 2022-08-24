//
//  DiaryManager.swift
//  Diary
//
//  Created by Kiwi, Brad. on 2022/08/23.
//

class DiaryManager: DBMangerable {
    
    let dbManager: DBMangerable
    
    init(dbManager: DBMangerable) {
        self.dbManager = dbManager
    }
    
    func loadData() {
        self.dbManager.loadData()
    }
    
    func count() -> Int {
        return self.dbManager.count()
    }
    
    func content(index: Int) -> SampleDiaryContent {
        return self.dbManager.content(index: index)
    }
}
