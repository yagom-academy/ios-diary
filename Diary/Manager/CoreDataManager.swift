//
//  CoreDataManager.swift
//  Diary
//
//  Created by Zion, Serena on 2023/09/11.
//

import CoreData

class CoreDataManager {
    private let name: String
    lazy var context = persistentContainer.viewContext
    
    private lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: name)
        
        container.loadPersistentStores(completionHandler: { _, _ in })
        return container
    }()
    
    init(name: String) {
        self.name = name
    }
    
    func fetchData<T: NSManagedObject>(request: NSFetchRequest<T>) throws -> [T] {
        let data = try context.fetch(request)
        
        return data
    }
    
    func deleteData(entity: NSManagedObject) {
        context.delete(entity)
    }
    
    func saveContext () {
        let context = persistentContainer.viewContext
        
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
}
