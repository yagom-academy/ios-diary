//
//  CoreDataManager.swift
//  Diary
//
//  Created by Hamo, Minii on 2022/12/27.
//

import Foundation
import CoreData

extension DiaryEntity {
    var diaryDTO: Diary? {
        guard let title = self.title,
              let body = self.body else {
            return nil
        }
        
        let createdInt = Int(self.createdIntervalValue)
        return Diary(title: title, body: body, createdIntervalValue: createdInt, uuid: self.id)
    }
}

final class CoreDataManager {
    static let shared = CoreDataManager()
    
    lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "Diary")
        container.loadPersistentStores(completionHandler: { (_, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })

        return container
    }()
    
    var context: NSManagedObjectContext {
        return persistentContainer.viewContext
    }
    
    private init() { }
    
    func createDiary(diary: Diary?) {
        guard let diary = diary else { return }
        let diaryEntity = DiaryEntity(context: context)
        
        diaryEntity.title = diary.title
        diaryEntity.body = diary.body
        diaryEntity.createdIntervalValue = diary.createInt64
        diaryEntity.id = diary.uuid
        
        save()
    }

    func updateDiary(diary: Diary?) {
        guard let diary = diary else { return }
        
        let fetchRequest = DiaryEntity.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "id = %@", diary.id.uuidString)
        
        guard let updateObjects = try? context.fetch(fetchRequest) else { return }
        
        if updateObjects.count == 1,
           let object = updateObjects.first {
            object.title = diary.title
            object.body = diary.body
            object.createdIntervalValue = diary.createInt64
            object.id = diary.uuid
            
            save()
        }
    }

    func fetchDiary() -> [Diary] {
        let fetchRequest = DiaryEntity.fetchRequest()
        let dateSort = NSSortDescriptor(key: "createdIntervalValue", ascending: false)
        fetchRequest.sortDescriptors = [dateSort]
        
        guard let entities = try? context.fetch(fetchRequest) else {
            return []
        }
        
        return entities.compactMap { $0.diaryDTO }
    }

    func deleteDiary(id: UUID) {
        let fetchRequest = DiaryEntity.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "id = %@", id.uuidString)
        
        guard let objects = try? context.fetch(fetchRequest) else { return }
        
        objects.forEach {
            context.delete($0)
        }
        
        save()
    }

    private func save() {
        if context.hasChanges {
            try? context.save()
        }
    }
}
