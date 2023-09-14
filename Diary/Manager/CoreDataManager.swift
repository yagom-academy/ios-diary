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
    
    func insertData(entityName: String, entityProperties: [String: Any]) {
        if let entity = NSEntityDescription.entity(forEntityName: entityName, in: context) {
            let managedObject = NSManagedObject(entity: entity, insertInto: context)
            
            for entityProperty in entityProperties {
                managedObject.setValue(entityProperty.value, forKey: entityProperty.key)
            }
        }
    }
    
    func deleteData(entity: NSManagedObject) {
        context.delete(entity)
    }
    
    func saveContext () {
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
