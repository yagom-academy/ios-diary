//
//  CoreDataProcessable.swift
//  Diary
//  Created by inho, dragon on 2022/12/28.
//

import CoreData
import UIKit

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
            forEntityName: NameSpace.entityName,
            in: managedContext
        ) else {
            return
        }
        let object = NSManagedObject(entity: entity, insertInto: managedContext)
        
        object.setValue(diary.title, forKey: NameSpace.entityTitle)
        object.setValue(diary.body, forKey: NameSpace.entityBody)
        object.setValue(diary.createdAt.description, forKey: NameSpace.entityCreatedDate)
        object.setValue(diary.totalText, forKey: NameSpace.entityTotalText)
        object.setValue(diary.id, forKey: NameSpace.entityID)
        
        do {
            try managedContext.save()
        } catch let error as NSError {
            print("Could not save. \(error), \(error.userInfo)")
        }
    }
    
    func readCoreData() -> [Entity]? {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return nil }
        let managedContext = appDelegate.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<Entity>(entityName: NameSpace.entityName)
        let result = try? managedContext.fetch(fetchRequest)
        
        return result
    }
    
    func updateCoreData(diary: Diary) {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        let managedContext = appDelegate.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>.init(entityName: NameSpace.entityName)
        
        fetchRequest.predicate = NSPredicate(format: NameSpace.idFormat, diary.id.uuidString)
        
        guard let result = try? managedContext.fetch(fetchRequest),
              let object = result.first as? NSManagedObject else { return }
        
        object.setValue(diary.title, forKey: NameSpace.entityTitle)
        object.setValue(diary.body, forKey: NameSpace.entityBody)
        object.setValue(diary.createdAt.description, forKey: NameSpace.entityCreatedDate)
        object.setValue(diary.totalText, forKey: NameSpace.entityTotalText)
        
        do {
            try managedContext.save()
        } catch let error as NSError {
            print("Could not update. \(error), \(error.userInfo)")
        }
    }
    
    func deleteCoreData(diary: Diary) {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        let managedContext = appDelegate.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>.init(entityName: NameSpace.entityName)
        
        fetchRequest.predicate = NSPredicate(format: NameSpace.idFormat, diary.id.uuidString)
        
        guard let result = try? managedContext.fetch(fetchRequest),
              let objectToDelete = result.first as? NSManagedObject else { return }
        
        managedContext.delete(objectToDelete)
            
        do {
            try managedContext.save()
        } catch let error as NSError {
            print("Could not delete. \(error), \(error.userInfo)")
        }
    }
}

private enum NameSpace {
    static let entityName = "Entity"
    static let entityTitle = "title"
    static let entityBody = "body"
    static let entityCreatedDate = "createdDate"
    static let entityTotalText = "totalText"
    static let entityID = "id"
    static let idFormat = "id = %@"
}
