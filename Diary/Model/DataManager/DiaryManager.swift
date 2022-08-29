//
//  DiaryManager.swift
//  Diary
//
//  Created by Kiwi, Brad. on 2022/08/23.
//

import Foundation

final class DiaryManager: DBMangerable {
    
    let dbManager: DBMangerable
    
    init(dbManager: DBMangerable = CoreDataManager.shared) {
        self.dbManager = dbManager
    }
    
    func loadData() {
        return self.dbManager.loadData()
    }
    
    func getData() -> [DiaryContent] {
       return self.dbManager.getData()
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
