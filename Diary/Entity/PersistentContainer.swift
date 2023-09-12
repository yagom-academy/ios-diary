//
//  PersistentContainer.swift
//  Diary
//
//  Created by MINT, BMO on 2023/09/04.
//

import CoreData

final class PersistentContainer: NSPersistentContainer {
    func saveContext() {
        guard viewContext.hasChanges else { return }
        do {
            try viewContext.save()
        } catch let error as NSError {
            print("Error: \(error), \(error.userInfo)")
        }
    }
}
