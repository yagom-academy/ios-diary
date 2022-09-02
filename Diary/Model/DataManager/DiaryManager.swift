//
//  DiaryManager.swift
//  Diary
//
//  Created by Kiwi, Brad. on 2022/08/23.
//

import Foundation

final class DiaryManager {
    
    let dbManager: DBMangerable
    
    init(dbManager: DBMangerable = CoreDataManager.shared) {
        self.dbManager = dbManager
    }
    
    func loadData() {
        self.dbManager.loadData()
    }
    
    func diaryContent() -> [DiaryContent] {
       return self.dbManager.diaryContent()
    }
    
    func count() -> Int {
        return self.dbManager.count()
    }
    
    func content(index: Int) -> DiaryContent {
        return self.dbManager.content(index: index)
    }
    
    func saveDiary(model: DiaryContent) {
        self.dbManager.saveDiary(model: model)
    }
    
    func updateData(item: DiaryContent) {
        return self.dbManager.updateData(item: item)
    }
  
    func deleteDiary(id: UUID) {
        self.dbManager.deleteDiary(id: id)
    }
    
    func fetchDiaryEntity() -> [Diary] {
        self.dbManager.fetchDiaryEntity()
    }
}
