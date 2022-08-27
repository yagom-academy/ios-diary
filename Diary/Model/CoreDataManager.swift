//
//  CoreDataManager.swift
//  Diary
//
//  Created by Hugh, Derrick on 2022/08/22.
//

import Foundation
import CoreData

final class CoreDataManager: DataManageLogic {
    // MARK: - Core Data stack

    lazy private var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "Diary")
        container.loadPersistentStores(completionHandler: { (_, _) in
        })
        return container
    }()
    
    // MARK: - Create
    func save(data: DiaryContent) throws {
        let context = persistentContainer.viewContext
        let entity = NSEntityDescription.entity(forEntityName: "DiaryEntity", in: context)
        
        guard let entity = entity else {
            throw CoreDataError.noneEntity
        }
        
        let managedObject = NSManagedObject(entity: entity, insertInto: context)
        
        managedObject.setValue(data.title, forKey: "title")
        managedObject.setValue(data.body, forKey: "body")
        managedObject.setValue(data.createdAt, forKey: "createdAt")
        
        try context.save()
    }
    
    // MARK: - READ
    func fetch() throws -> [DiaryContent] {
        let context = persistentContainer.viewContext
        let request = NSFetchRequest<NSManagedObject>(entityName: "DiaryEntity")
        
        let sort = NSSortDescriptor(key: "createdAt", ascending: false)
        request.sortDescriptors = [sort]
        
        guard let result = try context.fetch(request) as? [DiaryEntity] else {
            throw CoreDataError.fetchFailure
        }
        
        let data = result.compactMap { data -> DiaryContent? in
            guard let title = data.title,
                  let body = data.body,
                  let createdAt = data.createdAt else { return nil }
            
            return DiaryContent(title: title, body: body, createdAt: createdAt)
        }
        
        return data
    }
    
    //MARK: - Update
    func update(data: DiaryContent) throws {
        let context = persistentContainer.viewContext
        let request: NSFetchRequest<NSFetchRequestResult> = NSFetchRequest.init(entityName: "DiaryEntity")
        request.predicate = NSPredicate(format: "createdAt = %@", "\(data.createdAt)")
        
        guard let result = try? context.fetch(request),
              let objectUpdate = result[0] as? NSManagedObject else {
            throw CoreDataError.fetchFailure
        }
        
        objectUpdate.setValue(data.title, forKey: "title")
        objectUpdate.setValue(data.body, forKey: "body")
        objectUpdate.setValue(data.createdAt, forKey: "createdAt")
        
        try context.save()
    }
    
    //MARK: - Delete
    func remove(date: Date) throws {
        let context = persistentContainer.viewContext
        let request: NSFetchRequest<NSFetchRequestResult> = NSFetchRequest.init(entityName: "DiaryEntity")
        request.predicate = NSPredicate(format: "createdAt = %@", "\(date)")
    
        guard let result = try? context.fetch(request),
              let objectDelete = result[0] as? NSManagedObject else {
            throw CoreDataError.fetchFailure
        }
        
        context.delete(objectDelete)
        
        try context.save()
    }
}
