//  Diary - DiaryDataManager.swift
//  Created by Ayaan, zhilly on 2022/12/26

import Foundation
import CoreData

struct DiaryDataManager: DiaryManageable {
    func add(title: String, body: String, createAt: Date) {
        guard let entity = DiaryCoreDataStack.shared.fetchEntity(forEntityName: "DiaryData") else {
            return
        }
        
        let diary = NSManagedObject(entity: entity,
                                    insertInto: DiaryCoreDataStack.shared.context)
        diary.setValue(title, forKey: "title")
        diary.setValue(body, forKey: "body")
        diary.setValue(createAt, forKey: "createdAt")
        
        DiaryCoreDataStack.shared.save()
    }
    
    func fetchDiaries() -> [Diary] {
        let fetchRequest: NSFetchRequest<DiaryData> = DiaryData.fetchRequest()
        guard let result = try? DiaryCoreDataStack.shared.context.fetch(fetchRequest) else {
            return []
        }
        
        return result.compactMap({ Diary(from: $0) })
    }
    
    func update(_ diary: Diary) {
        let fetchRequest: NSFetchRequest<DiaryData> = DiaryData.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "title == %@ AND body == %@ AND createAt == %@",
                                             argumentArray: [diary.title, diary.body, diary.createAt])
        
        guard let result = try? DiaryCoreDataStack.shared.context.fetch(fetchRequest),
              let firstObject = result.first else {
            return
        }
        
        firstObject.setValue(diary.title, forKey: "title")
        firstObject.setValue(diary.body, forKey: "body")
        
        DiaryCoreDataStack.shared.save()
    }
    
    func remove(_ diary: Diary) {
        let fetchRequest: NSFetchRequest<DiaryData> = DiaryData.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "title == %@ AND body == %@ AND createAt == %@",
                                             argumentArray: [diary.title, diary.body, diary.createAt])
        
        guard let result = try? DiaryCoreDataStack.shared.context.fetch(fetchRequest),
              let firstObject = result.first else {
            return
        }
        
        DiaryCoreDataStack.shared.context.delete(firstObject)
        DiaryCoreDataStack.shared.save()
    }
}
