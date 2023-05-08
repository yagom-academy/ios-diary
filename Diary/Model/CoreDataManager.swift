//
//  Diary - CoreDataManager.swift
//  Created by Rhode, 무리.
//  Copyright © yagom. All rights reserved.
//

import CoreData
import Foundation

class CoreDataManager {
    static var shared: CoreDataManager = CoreDataManager()
    
    lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "Diary")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        
        return container
    }()
    
    var context: NSManagedObjectContext {
        return persistentContainer.viewContext
    }
    
    var diaryEntity: NSEntityDescription? {
        return  NSEntityDescription.entity(forEntityName: "Entity", in: context)
    }
    
    func createDiary(_ diary: Diary) {
        if let entity = diaryEntity {
            let managedObject = NSManagedObject(entity: entity, insertInto: context)
            managedObject.setValue(diary.id, forKey: "id")
            managedObject.setValue(diary.title, forKey: "title")
            managedObject.setValue(diary.body, forKey: "body")
            managedObject.setValue(diary.date, forKey: "date")
            
            do {
                try self.context.save()
            } catch {
                print(error.localizedDescription)
            }
        }
    }
    
    func readDiary() -> [Diary]? {
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "Entity")
        var diaries = [Diary]()
        
        guard let diaryData = try? context.fetch(fetchRequest) else { return nil }
        
        for diary in diaryData {
            guard let id = diary.value(forKey: "id") as? UUID,
                  let title = diary.value(forKey: "title") as? String,
                  let body = diary.value(forKey: "body") as? String,
                  let date = diary.value(forKey: "date") as? Double else { return nil }
            
            diaries.append(Diary(id: id, title: title, body: body, date: date))
        }
        
        return diaries
    }
    
    func updateDiary(diary: Diary) {
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "Entity")
        fetchRequest.predicate = NSPredicate(format: "id == %@", diary.id as CVarArg)
        
        do {
            let objects = try context.fetch(fetchRequest)
            let objectToUpdate = objects[0]
            
            objectToUpdate.setValue(diary.title, forKey: "title")
            objectToUpdate.setValue(diary.body, forKey: "body")
            objectToUpdate.setValue(diary.date, forKey: "date")
            
            do {
                try self.context.save()
            } catch {
                print(error.localizedDescription)
            }
        } catch {
            print(error.localizedDescription)
        }
    }
    
    func deleteDiary(diary: Diary) throws {
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "Entity")
        fetchRequest.predicate = NSPredicate(format: "id == %@", diary.id as CVarArg)
        
        do {
            let objects = try context.fetch(fetchRequest)
            let objectToDelete = objects[0]
            context.delete(objectToDelete)
            
            do {
                try context.save()
            } catch {
                throw error
            }
        } catch {
            throw error
        }
    }
}
