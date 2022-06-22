//
//  PersistenceManager.swift
//  Diary
//
//  Created by 김태훈 on 2022/06/22.
//

import Foundation
import CoreData

class PersistenceManager {
    static var shared = PersistenceManager()
    
    lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "DiaryEntity")
        container.loadPersistentStores { _ , error in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        }
        return container
    }()
    
    var context: NSManagedObjectContext {
        return persistentContainer.viewContext
    }
    
    func saveContext() {
        if context.hasChanges {
            do {
                try self.context.save()
            } catch {
                fatalError("invalid error")
            }
        }
    }
    
    func create(diary: DiaryModel) {
        let data = DiaryEntity(context: context)
        
        data.title = diary.title
        data.body = diary.body
        data.createdAt = diary.createdAt
        data.id = diary.id
        
        saveContext()
    }
    
    func fetch() -> [DiaryModel] {
        var diaryList = [DiaryEntity]()
        do {
            let request = DiaryEntity.fetchRequest()
            diaryList = try context.fetch(request)
        } catch {
        }
        return diaryList.map { diaryEntity in
            DiaryModel(title: diaryEntity.title, body: diaryEntity.body, createdAt: diaryEntity.createdAt, id: diaryEntity.id)
        }
    }
    
    func update(diary: DiaryModel) {
        let request = DiaryEntity.fetchRequest()
        let predicate = NSPredicate(format: "id == %@", diary.id)

        request.predicate = predicate
        guard let diaryList = try? context.fetch(request) else {
            return
        }
        
        if let diaryEntity = diaryList.first {
            diaryEntity.title = diary.title
            diaryEntity.body = diary.body
            diaryEntity.createdAt = diary.createdAt
        }
        
        saveContext()
    }
    
    func delete(diary: DiaryModel) {
        let request = DiaryEntity.fetchRequest()
        let predicate = NSPredicate(format: "id == %@", diary.id)
        request.predicate = predicate
        
        guard let diaryEntity = try? context.fetch(request).first else {
            return
        }
        
        context.delete(diaryEntity)
        
        saveContext()
    }
}
