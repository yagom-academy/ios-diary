//
//  ContainerManager.swift
//  Diary
//
//  Created by Mary & Whales on 2023/09/05.
//

import CoreData
import OSLog

final class ContainerManager {
    static let shared = ContainerManager()
    
    private init() { }

    private let persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "Diary")
        container.loadPersistentStores { _, error in
            if let error = error {
                fatalError("Unable to load persistent stores: \(error)")
            }
        }
        
        return container
    }()
    
    private var context: NSManagedObjectContext {
        return persistentContainer.viewContext
    }
    
    func insert(diaryContent: DiaryContent) {
        let entity = NSEntityDescription.entity(forEntityName: "Diary", in: context)
        
        if let entity = entity {
            let managedObject = NSManagedObject(entity: entity, insertInto: context)
            
            managedObject.setValue(diaryContent.title, forKey: "title")
            managedObject.setValue(diaryContent.body, forKey: "body")
            managedObject.setValue(diaryContent.timeInterval, forKey: "timeInterval")
            managedObject.setValue(diaryContent.id, forKey: "id")

            save()
        }
    }
    
    func save() {
        do {
            try context.save()
        } catch {
            os_log("%@", error.localizedDescription)
        }
    }
    
    func update(diaryContent: DiaryContent) {
        let request = Diary.fetchRequest()
        
        request.predicate = NSPredicate(format: "id == %@", diaryContent.id as CVarArg)
        
        do {
            let diaries = try context.fetch(request)
            guard let diary = diaries.first else { return }
            let diaryObject = diary as NSManagedObject
            
            diaryObject.setValue(diaryContent.title, forKey: "title")
            diaryObject.setValue(diaryContent.body, forKey: "body")
            
            save()
        } catch {
            os_log("%@", error.localizedDescription)
        }
    }
    
    func fetchAll() -> [Diary]? {
        do {
            let diaries = try context.fetch(Diary.fetchRequest())
            return diaries
        } catch {
            os_log("%@", error.localizedDescription)
        }
        
        return nil
    }
    
    func delete(id: UUID) {
        let request = Diary.fetchRequest()
        
        request.predicate = NSPredicate(format: "id == %@", id as CVarArg)
        
        do {
            let diaries = try context.fetch(request)
            guard let diary = diaries.first else { return }
            context.delete(diary)
            try context.save()
        } catch {
            os_log("%@", error.localizedDescription)
        }
    }
}
