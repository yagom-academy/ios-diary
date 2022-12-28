//  Diary - DiaryDataManager.swift
//  Created by Ayaan, zhilly on 2022/12/26

import Foundation
import CoreData

struct DiaryDataManager: DiaryManageable {
    func add(_ diary: Diary) {
        guard let entity = DiaryCoreDataStack.shared.fetchEntity(forEntityName: "DiaryData") else {
            return
        }
        
        let diaryObject = NSManagedObject(entity: entity,
                                    insertInto: DiaryCoreDataStack.shared.context)
        diaryObject.setValue(diary.title, forKey: "title")
        diaryObject.setValue(diary.body, forKey: "body")
        diaryObject.setValue(diary.createdAt, forKey: "createdAt")
        
        DiaryCoreDataStack.shared.save()
    }
    
    func fetchDiaries() -> [Diary] {
        let fetchRequest: NSFetchRequest<DiaryData> = DiaryData.fetchRequest()
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "createdAt", ascending: false)]
        guard let result = try? DiaryCoreDataStack.shared.context.fetch(fetchRequest) else {
            return []
        }
        
        return result.compactMap({ Diary(from: $0) })
    }
    
    func update(_ diary: Diary) {
        guard let objectID = fetchObjectID(from: diary.objectID) else {
            return
        }
        let object = DiaryCoreDataStack.shared.context.object(with: objectID)
        
        object.setValue(diary.title, forKey: "title")
        object.setValue(diary.body, forKey: "body")
        
        DiaryCoreDataStack.shared.save()
    }
    
    func remove(_ diary: Diary) {
        guard let objectID = fetchObjectID(from: diary.objectID) else {
            return
        }
        let object = DiaryCoreDataStack.shared.context.object(with: objectID)
        
        DiaryCoreDataStack.shared.context.delete(object)
        DiaryCoreDataStack.shared.save()
    }
    
    func addNewDiary() {
        let newDiary = Diary(content: .init(), createdAt: Date.now)
        add(newDiary)
    }
    
    private func fetchObjectID(from diaryID: String?) -> NSManagedObjectID? {
        guard let diaryID = diaryID, let objectURL = URL(string: diaryID),
              let storeCoordinator = DiaryCoreDataStack.shared.context.persistentStoreCoordinator,
              let objectID = storeCoordinator.managedObjectID(forURIRepresentation: objectURL) else {
            return nil
        }
        return objectID
    }
}
