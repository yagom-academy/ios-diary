//
//  CoreDataManager.swift
//  Diary
//
//  Created by MINT, BMO on 2023/09/12.
//

import CoreData

struct CoreDataManager {
    let container: NSPersistentContainer
    
    init(name: String) {
        self.container = {
            let container = NSPersistentContainer(name: name)
            container.loadPersistentStores { _, error in
                if let error = error {
                    fatalError("Unable to load persistent stores: \(error)")
                }
            }
            return container
        }()
    }
    
    func fetch<T: EntityProtocol>(of object: T) throws -> [T] {
        let fetchRequest = object.fetchRequest()
        return try container.viewContext.fetch(fetchRequest)
    }
    
    func deleteContext(of object: NSManagedObject) {
        container.viewContext.delete(object)
    }
    
    func saveContext() {
        guard container.viewContext.hasChanges else {
            return
        }
        
        do {
            try container.viewContext.save()
        } catch {
            // TODO: 사용자가 알 수 있는 에러 처리
        }
    }
}
