//
//  CoreDataManager.swift
//  Diary
//
//  Created by 백곰,주디 on 2022/08/19.
//

import UIKit
import CoreDataFramework

class DiaryDataManager {
    static let shared = DiaryDataManager()
    
    private init() { }
    
    func fetchDiary() -> [DiaryItem]? {
        guard let diaryEntities = CoreDataManager.shared.fetchDiary() else { return nil }
        
        var diaryItems = diaryEntities.compactMap {
            DiaryItem(id: $0.id, title: $0.title, body: $0.body, createdAt: $0.createdAt)
        }
        
        diaryItems.reverse()
        
        return diaryItems
    }

    func saveDiary(item: DiaryItem) {
        CoreDataManager.shared.saveDiary(id: item.id, title: item.title, body: item.body, createdAt: item.createdAt)
    }

    func deleteDiary(id: UUID) {
        CoreDataManager.shared.deleteDiary(id: id)
    }
}
