//
//  CoreDataManager.swift
//  Diary
//
//  Created by Zion, Serena on 2023/09/11.
//

import CoreData

protocol CoreDataManagerType {
    associatedtype T
    
    func fetchData<T: NSManagedObject>(request: NSFetchRequest<T>) throws -> [T]
    func insertData(entityName: String, entityProperties: [String: Any])
    func updateData<T: Identifiable>(request: NSFetchRequest<T>, entityProperties: [String: Any]) where T.ID == UUID
    func deleteData<T: Identifiable>(request: NSFetchRequest<T>, identifier: UUID) where T.ID == UUID
    func isExistData<T: Identifiable>(request: NSFetchRequest<T>, identifier: UUID) -> Bool where T.ID == UUID
}

final class CoreDataManager<T>: CoreDataManagerType {
    private let name: String
    private lazy var context = persistentContainer.viewContext
    
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
            
            saveContext()
        }
    }
    
    func updateData<T: Identifiable>(request: NSFetchRequest<T>, entityProperties: [String: Any]) where T.ID == UUID {
        guard let dataList = try? context.fetch(request), let id = entityProperties["id"] as? UUID else { return }
        guard let updateObject = dataList.filter({ $0.id == id}).first as? NSManagedObject else { return }
        
        for entityProperty in entityProperties {
            updateObject.setValue(entityProperty.value, forKey: entityProperty.key)
        }
        
        saveContext()
    }
    
    func deleteData<T: Identifiable>(request: NSFetchRequest<T>, identifier: UUID) where T.ID == UUID {
        guard let dataList = try? context.fetch(request) else { return }
        guard let deleteObject = dataList.filter({ $0.id == identifier}).first as? NSManagedObject else { return }
        
        context.delete(deleteObject)
        saveContext()
    }

    func isExistData<T: Identifiable>(request: NSFetchRequest<T>, identifier: UUID) -> Bool where T.ID == UUID {
        guard let dataList = try? context.fetch(request) else { return false }
        guard let data = dataList.filter({ $0.id == identifier}).first as? NSManagedObject else { return false }
        
        return true
    }
    
    private func saveContext () {
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
