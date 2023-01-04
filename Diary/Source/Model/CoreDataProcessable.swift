//
//  CoreDataProcessable.swift
//  Diary
//  Created by inho, dragon on 2022/12/28.
//

import CoreData
import UIKit

protocol CoreDataProcessable {
    func saveCoreData(diary: Diary) -> Result<Bool, CoreDataError>
    func readCoreData() -> Result<[Entity], CoreDataError>
    func updateCoreData(diary: Diary) -> Result<Bool, CoreDataError>
    func deleteCoreData(diary: Diary) -> Result<Bool, CoreDataError>
}

extension CoreDataProcessable {
    func saveCoreData(diary: Diary) -> Result<Bool, CoreDataError> {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return .failure(.appDelegateError)
        }
        
        let managedContext = appDelegate.persistentContainer.viewContext
        guard let entity = NSEntityDescription.entity(
            forEntityName: NameSpace.entityName,
            in: managedContext
        ) else {
            return .failure(.entityError)
        }
        
        let object = NSManagedObject(entity: entity, insertInto: managedContext)
        
        object.setValue(diary.title, forKey: NameSpace.entityTitle)
        object.setValue(diary.body, forKey: NameSpace.entityBody)
        object.setValue(diary.createdAt.description, forKey: NameSpace.entityCreatedDate)
        object.setValue(diary.totalText, forKey: NameSpace.entityTotalText)
        object.setValue(diary.id, forKey: NameSpace.entityID)
        object.setValue(diary.icon, forKey: NameSpace.entityIcon)
        
        do {
            try managedContext.save()
            return .success(true)
        } catch {
            return .failure(.saveError)
        }
    }
    
    func readCoreData() -> Result<[Entity], CoreDataError> {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return .failure(.appDelegateError)
        }
        
        let managedContext = appDelegate.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<Entity>(entityName: NameSpace.entityName)
        
        do {
            let result = try managedContext.fetch(fetchRequest)
            return .success(result)
        } catch {
            return .failure(.fetchError)
        }
    }
    
    func updateCoreData(diary: Diary) -> Result<Bool, CoreDataError> {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return .failure(.appDelegateError)
        }
        
        let managedContext = appDelegate.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>.init(entityName: NameSpace.entityName)
        
        fetchRequest.predicate = NSPredicate(format: NameSpace.idFormat, diary.id.uuidString)
        
        guard let result = try? managedContext.fetch(fetchRequest),
              let object = result.first as? NSManagedObject
        else {
            return .failure(.fetchError)
        }
        
        object.setValue(diary.title, forKey: NameSpace.entityTitle)
        object.setValue(diary.body, forKey: NameSpace.entityBody)
        object.setValue(diary.createdAt.description, forKey: NameSpace.entityCreatedDate)
        object.setValue(diary.totalText, forKey: NameSpace.entityTotalText)
        
        do {
            try managedContext.save()
            return .success(true)
        } catch {
            return .failure(.saveError)
        }
    }
    
    func deleteCoreData(diary: Diary) -> Result<Bool, CoreDataError> {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return .failure(.appDelegateError)
        }
        
        let managedContext = appDelegate.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>.init(entityName: NameSpace.entityName)
        
        fetchRequest.predicate = NSPredicate(format: NameSpace.idFormat, diary.id.uuidString)
        
        guard let result = try? managedContext.fetch(fetchRequest),
              let objectToDelete = result.first as? NSManagedObject
        else {
            return .failure(.fetchError)
        }
        
        managedContext.delete(objectToDelete)
            
        do {
            try managedContext.save()
            return .success(true)
        } catch {
            return .failure(.saveError)
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
    static let entityIcon = "icon"
    static let idFormat = "id = %@"
}
