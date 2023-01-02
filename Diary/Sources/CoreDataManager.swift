//
//  CoreDataManager.swift
//  Diary
//
//  Created by Hamo, Minii on 2022/12/27.
//

import Foundation
import CoreData

extension DiaryEntity {
    var diary: Diary? {
        let createdInt = Int(self.createdIntervalValue)
        let timeInterval = TimeInterval(createdInt)
        
        guard let title = self.title,
              let body = self.body,
              let id = self.id else {
            return nil
        }
        
        return Diary(id: id, title: title, body: body, timeInterval: timeInterval)
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
        diaryEntity.createdIntervalValue = Int64(diary.createdDate.timeIntervalSince1970)
        diaryEntity.id = diary.id
        
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
            object.createdIntervalValue = Int64(diary.createdDate.timeIntervalSince1970)
            object.id = diary.id
            
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
        
        return entities.compactMap { $0.diary }
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
