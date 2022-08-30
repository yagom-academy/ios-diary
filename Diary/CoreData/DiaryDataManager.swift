//
//  CoreDataManager.swift
//  Diary
//
//  Created by 백곰,주디 on 2022/08/19.
//

import UIKit
import CoreDataFramework
import CoreData

class DiaryDataManager {
    static let shared = DiaryDataManager()
    
    private init() { }
    
    func saveDiary(item: DiaryItem) {
        let fetchRequest: NSFetchRequest<NSFetchRequestResult> = NSFetchRequest(entityName: "DiaryEntity")
        fetchRequest.predicate = NSPredicate(format: "id = %@", item.id as CVarArg)
        
        let sampleModel = SaveModel(entityName: "DiaryEntity",
                                      sampleData: ["id": item.id, "title": item.title, "body": item.body, "createdAt": item.createdAt])
        
        CoreDataManager.shared.save(model: sampleModel, request: fetchRequest)
    }

    func deleteDiary(id: UUID) {
        let fetchRequest: NSFetchRequest<NSFetchRequestResult> = NSFetchRequest(entityName: "DiaryEntity")
        fetchRequest.predicate = NSPredicate(format: "id = %@", id as CVarArg)

        CoreDataManager.shared.delete(fetchRequest)
    }
    
    func fetchData() -> [DiaryItem]? {
        guard let data = CoreDataManager.shared.fetch(DiaryEntity.fetchRequest()) else { return nil }
        
        var diaryItems = data.compactMap {
            DiaryItem(id: $0.id, title: $0.title, body: $0.body, createdAt: $0.createdAt)
        }
        
        diaryItems.sort(by: { $0.createdAt > $1.createdAt })
        
        return diaryItems
    }
}
