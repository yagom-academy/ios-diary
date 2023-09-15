//
//  DataManager.swift
//  Diary
//
//  Created by Minsup, RedMango on 2023/09/04.
//

import CoreData

final class DataManager {
    lazy var container: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "Diary")
        
        container.loadPersistentStores(completionHandler: { ( _, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()
    
    func delete(_ diary: Diary) {
        container.viewContext.delete(diary)
        saveContext()
    }
    
    func saveContext () {
        let context = container.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
    
    func fetch() -> [Diary] {
        let context = container.viewContext
        let request = Diary.fetchRequest()
        let createdDateSort = NSSortDescriptor(keyPath: \Diary.createdDate, ascending: false)
        request.sortDescriptors = [createdDateSort]
        do {
            return try context.fetch(request)
        } catch {
            let nserror = error as NSError
            fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
        }
    }
}
