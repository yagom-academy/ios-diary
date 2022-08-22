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
    func saveContext() {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                #warning("추후 개발")
            }
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
    func updateContext(title: String, body: String) {
        let context = persistentContainer.viewContext
        let request: NSFetchRequest<NSFetchRequestResult> = NSFetchRequest.init(entityName: "DiaryEntity")
        request.predicate = NSPredicate(format: "title = %@", title)
        
        do {
            let result = try context.fetch(request)
            
            guard let objectUpdate = result[0] as? NSManagedObject else {
                return
            }
            
            objectUpdate.setValue(title, forKey: "title")
            objectUpdate.setValue(body, forKey: "body")
            objectUpdate.setValue(Date.currentFormattedDate, forKey: "createdAt")
            
            do {
                try context.save()
            } catch {
                #warning("추후 개발")
            }
        } catch {
            #warning("추후 개발")
        }
    }
    
    //MARK: - Delete
    func deleteContext(title: String) {
        let context = persistentContainer.viewContext
        let request: NSFetchRequest<NSFetchRequestResult> = NSFetchRequest.init(entityName: "DiaryEntity")
        request.predicate = NSPredicate(format: "title = %@", title)
        
        do {
            let result = try context.fetch(request)
            
            guard let objectDelete = result[0] as? NSManagedObject else {
                return
            }
            context.delete(objectDelete)
            
            do {
                try context.save()
            } catch {
                #warning("추후 개발")
            }
        } catch {
            #warning("추후 개발")
        }
    }
}
