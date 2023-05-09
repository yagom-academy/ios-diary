//
//  CoreDataManagable.swift
//  Diary
//
//  Created by Andrew, brody on 2023/05/08.
//

import CoreData

protocol CoreDataManagable {
    var managedContext: NSManagedObjectContext { get }
    func saveContext() -> Bool
}

extension CoreDataManagable {
    func saveContext() -> Bool {
        do {
            try managedContext.save()
            return true
        } catch {
            return false
        }
    }
}
