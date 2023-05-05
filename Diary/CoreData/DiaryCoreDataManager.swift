//
//  DiaryCoreDataManager.swift
//  Diary
//
//  Created by Rowan, Harry on 2023/04/28.
//

import Foundation
import CoreData

struct DiaryDataManager {
    let storage = CoreDataManager.shared
    
    var diaryEntity: NSEntityDescription? {
        return NSEntityDescription.entity(forEntityName: "DiaryDAO",
                                          in: storage.context)
    }
    
    func createDAO(from data: Diary) {
        if let diaryEntity {
            let diary = DiaryDAO(entity: diaryEntity, insertInto: storage.context)
            diary.setValue(data.title, forKey: "title")
            diary.setValue(data.updatedDate, forKey: "date")
            diary.setValue(data.body, forKey: "body")
            diary.setValue(data.id, forKey: "id")
            
            saveContext()
        }
    }
    
    func readAllDAO() -> [DiaryDAO] {
        let request = DiaryDAO.fetchRequest()
        let sortDescriptor = NSSortDescriptor(key: "date", ascending: false)
        
        request.sortDescriptors = [sortDescriptor]
        
        let fetchResult = storage.fetch(request: request)
        
        return fetchResult
    }
    
    func updateDAO(data: Diary) {
        let request = DiaryDAO.fetchRequest()
        let predicate = NSPredicate(format: "id == %@", data.id.uuidString)
        request.predicate = predicate
        
        let fetchResult = storage.fetch(request: request)
        
        guard let diary = fetchResult.first else { return }
        
        diary.setValue(data.title, forKey: "title")
        diary.setValue(data.updatedDate, forKey: "date")
        diary.setValue(data.body, forKey: "body")
        
        saveContext()
    }
    
    func deleteDiary(id: UUID) {
        let request = DiaryDAO.fetchRequest()
        let predicate = NSPredicate(format: "id == %@", id.uuidString)
        request.predicate = predicate
        
        let fetchResult = try? self.context.fetch(request)
        
        guard let diary = fetchResult?.first else { return }
        
        context.delete(diary)
        saveContext()
    }

    private func saveContext() {
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
}
