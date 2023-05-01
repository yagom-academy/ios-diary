//
//  PersistenceManager.swift
//  Diary
//
//  Created by 박소연 on 2023/05/01.
//

import CoreData

class PersistenceManager {
    static var shared: PersistenceManager = PersistenceManager()
    
    // MARK: - Core Data stack
    lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "Diary")
        container.loadPersistentStores { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        }
        
        return container
    }()
    
    var context: NSManagedObjectContext {
        return self.persistentContainer.viewContext
    }
}
