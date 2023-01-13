//
//  PersistentContainer.swift
//  Diary
//
//  Created by Mangdi, junho lee, on 2022/12/27.
//

import CoreData

class PersistentContainer: NSPersistentContainer {
    static let shared: PersistentContainer = {
        let container = PersistentContainer(name: "DiaryModel")
        container.loadPersistentStores { (_, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        }
        return container
    }()

    func saveContext() {
        guard viewContext.hasChanges else { return }
        do {
            try viewContext.save()
        } catch let error as NSError {
            print("Error: \(error), \(error.userInfo)")
        }
    }
}
