//
//  CoreDataManager.swift
//  Diary
//
//  Created by Hugh, Derrick on 2022/08/22.
//

import Foundation
import CoreData

final class CoreDataManager {
    // MARK: - Core Data stack

    lazy var persistentContainer: NSPersistentContainer = {

        let container = NSPersistentContainer(name: "Diary")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()
    
    // MARK: - Create
    func insertContext(data: DiaryContent) {
        let context = persistentContainer.viewContext
        let entity = NSEntityDescription.entity(forEntityName: "DiaryEntity", in: context)
        
        if let entity = entity {
            let managedObject = NSManagedObject(entity: entity, insertInto: context)
            
            managedObject.setValue(data.title, forKey: "title")
            managedObject.setValue(data.body, forKey: "body")
            managedObject.setValue(data.createdAt, forKey: "createdAt")
            
            try? context.save()
        }
    }
    
    // MARK: - READ
    func fetchContext() -> [NSManagedObject]? {
        let context = persistentContainer.viewContext
        let request = NSFetchRequest<NSManagedObject>(entityName: "DiaryEntity")
        
        let sort = NSSortDescriptor(key: "createdAt", ascending: false)
        request.sortDescriptors = [sort]
        
        let result = try? context.fetch(request)
        return result
    }
    
    //MARK: - Update
    func updateContext(data: DiaryContent) {
        let context = persistentContainer.viewContext
        let request: NSFetchRequest<NSFetchRequestResult> = NSFetchRequest.init(entityName: "DiaryEntity")
        request.predicate = NSPredicate(format: "createdAt = %@", "\(data.createdAt)")
        
        let result = try? context.fetch(request)
        
        guard let objectUpdate = result?[0] as? NSManagedObject else {
            return
        }
        
        objectUpdate.setValue(data.title, forKey: "title")
        objectUpdate.setValue(data.body, forKey: "body")
        objectUpdate.setValue(data.createdAt, forKey: "createdAt")
        
        try? context.save()
    }
    
    //MARK: - Delete
    func deleteContext(title: String) {
        let context = persistentContainer.viewContext
        let request: NSFetchRequest<NSFetchRequestResult> = NSFetchRequest.init(entityName: "DiaryEntity")
        request.predicate = NSPredicate(format: "title = %@", title)
    
        let result = try? context.fetch(request)
        
        guard let objectDelete = result?[0] as? NSManagedObject else {
            return
        }
        context.delete(objectDelete)
        
        try? context.save()
    }
}
