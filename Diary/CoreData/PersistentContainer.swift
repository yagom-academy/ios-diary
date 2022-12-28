//
//  PersistentContainer.swift
//  Diary
//
//  Created by JPush, Wonbi on 2022/12/28.
//

import CoreData

protocol PersistentContainer {
    var container: NSPersistentContainer { get }
}

extension PersistentContainer {
    var context: NSManagedObjectContext {
        return self.container.viewContext
    }
    
    func saveContext() {
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
