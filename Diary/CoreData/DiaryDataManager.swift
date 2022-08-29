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
        //CoreDataManager.shared.saveDiary(id: item.id, title: item.title, body: item.body, createdAt: item.createdAt)
        let sampleModel = SampleModel(entityName: "DiaryEntity", sampleData: ["id": item.id, "title": item.title, "body": item.body,
                                                                       "createdAt": item.createdAt])
        
        CoreDataManager.shared.save(sample: sampleModel)
    }

    func deleteDiary(id: UUID) {
        CoreDataManager.shared.deleteDiary(id: id)
    }
    
    func fetchData() -> [DiaryItem]? {
        guard let data = CoreDataManager.shared.fetch(DiaryEntity.fetchRequest()) else { return nil }
        
//        var diaryItems = data.compactMap {
//            DiaryItem(id: $0.id, title: $0.title, body: $0.body, createdAt: $0.createdAt)
//        }
        
        var emptyarr: [DiaryItem] = []
        
        for diaryitems2 in data {
            emptyarr.append(DiaryItem(id: diaryitems2.id, title: diaryitems2.title, body: diaryitems2.body, createdAt: diaryitems2.createdAt))
        }
        
        emptyarr.reverse()
        
        return emptyarr
    }
}
