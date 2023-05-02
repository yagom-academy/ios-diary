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
    
    func fetchDiary() -> [Diary]? {
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "Entity")
        guard let diaryData = try? context.fetch(fetchRequest) else { return nil }
        var diaries = [Diary]()
        
        for diary in diaryData {
            guard let title = diary.value(forKey: "title") as? String,
                  let body = diary.value(forKey: "body") as? String,
                  let date = diary.value(forKey: "date") as? Double else { return nil }
            
            diaries.append(Diary(title: title, body: body, date: date))
        }
        
        return diaries
    }
    
    func deleteDiary(index: Int) {
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "Entity")
        fetchRequest.predicate = NSPredicate(format: "title = %@", "title")
        
        do {
            let test = try context.fetch(fetchRequest)
            let objectToDelete = test[index]
            
            context.delete(objectToDelete)
            do {
                try context.save()
            } catch {
                print(error.localizedDescription)
            }
        } catch {
            print(error.localizedDescription)
        }
    }
}
