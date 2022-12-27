//
//  CoreDataManager.swift
//  Diary
//
//  Created by Hamo, Minii on 2022/12/27.
//

import Foundation
import CoreData

final class CoreDataManager {
    static let shared = CoreDataManager()
    
    lazy var persistenterContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "Diary")
        container.loadPersistentStores(completionHandler: { (_, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })

        return container
    }()
    
    var context: NSManagedObjectContext {
        return persistenterContainer.viewContext
    }
    
    private init() { }
    
    func createDiary(diary: Diary) {
        let diaryEntity = DiaryEntity(context: context)
        
        diaryEntity.title = diary.title
        diaryEntity.body = diary.body
        diaryEntity.createdIntervalValue = Int64(diary.createdIntervalValue)
        diaryEntity.id = diary.uuid
    }

    func updateDiary(diary: Diary) {
        let fetchRequest = DiaryEntity.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "id = %@", diary.uuid.uuidString)
        
        guard let updateObjects = try? context.fetch(fetchRequest) else { return }
        
        if updateObjects.count == 1,
           let object = updateObjects.first {
            object.title = diary.title
            object.body = diary.body
            object.createdIntervalValue = Int64(diary.createdIntervalValue)
            object.id = diary.uuid
        }
    }

    func fetchDiary() -> [DiaryEntity] {
        let fetchRequest = DiaryEntity.fetchRequest()
        guard let entities = try? context.fetch(fetchRequest) else {
            return []
        }
        
        return entities
    }

    func deleteDiary(id: UUID) {
        let fetchRequest = DiaryEntity.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "id = %@", id.uuidString)
        
        guard let objects = try? context.fetch(fetchRequest) else { return }
        
        objects.forEach {
            context.delete($0)
        }
    }

    func save() {
        if context.hasChanges {
            try? context.save()
        }
    }
}
