//
//  CoreDataManageable.swift
//  Diary
//
//  Created by MINT, BMO on 2023/09/12.
//

import CoreData

protocol CoreDataManageable {
    var container: NSPersistentContainer { get }
}

extension CoreDataManageable {
    func fetch<T: EntityProtocol>(of object: T) throws -> [T] {
        let fetchRequest = object.fetchRequest()
        return try container.viewContext.fetch(fetchRequest)
    }
    
    func saveContext() throws {
        guard container.viewContext.hasChanges else {
            return
        }
        
        try container.viewContext.save()
    }
    
    func deleteContext(of object: NSManagedObject) {
        container.viewContext.delete(object)
    }
}
