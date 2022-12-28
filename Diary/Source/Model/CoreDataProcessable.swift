//
//  CoreDataProcessable.swift
//  Diary
//  Created by inho, dragon on 2022/12/28.
//

import UIKit
import CoreData

protocol CoreDataProcessable {
    func saveCoreData(diary: Diary)
    func readCoreData() -> [Entity]?
    func updateCoreData(diary: Diary)
    func deleteCoreData(diary: Diary)
}

extension CoreDataProcessable {
    func saveCoreData(diary: Diary) {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        let managedContext = appDelegate.persistentContainer.viewContext
        guard let entity = NSEntityDescription.entity(
            forEntityName: "Entity",
            in: managedContext) else {
            return
        }
        let object = NSManagedObject(entity: entity, insertInto: managedContext)
        
        object.setValue(diary.body, forKey: "body")
        object.setValue(diary.createdAt.description, forKey: "createdDate")
        object.setValue(diary.title, forKey: "title")
        object.setValue(diary.totalText, forKey: "totalText")
        object.setValue(diary.id, forKey: "id")
        
        do {
            try managedContext.save()
        } catch let error as NSError {
            print("Could not save. \(error), \(error.userInfo)")
        }
    }
    
    func readCoreData() -> [Entity]? {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return nil }
        let managedContext = appDelegate.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<Entity>(entityName: "Entity")
        let result = try? managedContext.fetch(fetchRequest)
        
        return result
    }
    
    func updateCoreData(diary: Diary) {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        let managedContext = appDelegate.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>.init(entityName: "Entity")
        
        fetchRequest.predicate = NSPredicate(format: "id = %@", diary.id.uuidString)
        
        guard let result = try? managedContext.fetch(fetchRequest),
              let object = result[0] as? NSManagedObject else { return }
        
        object.setValue(diary.title, forKey: "title")
        object.setValue(diary.body, forKey: "body")
        object.setValue(diary.createdAt.description, forKey: "createdDate")
        object.setValue(diary.totalText, forKey: "totalText")
        
        do {
            try managedContext.save()
        } catch let error as NSError {
            print("Could not update. \(error), \(error.userInfo)")
        }
    }
    
    func deleteCoreData(diary: Diary) {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        let managedContext = appDelegate.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>.init(entityName: "Entity")
        
        fetchRequest.predicate = NSPredicate(format: "id = %@", diary.id.uuidString)
        
        guard let result = try? managedContext.fetch(fetchRequest),
              let objectToDelete = result[0] as? NSManagedObject else { return }
        
        managedContext.delete(objectToDelete)
            
        do {
            try managedContext.save()
        } catch let error as NSError {
            print("Could not update. \(error), \(error.userInfo)")
        }
    }
}
