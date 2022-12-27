//
//  PersistentContainer.swift
//  Diary
//
//  Created by Mangdi on 2022/12/27.
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
    private init(name: String) {
        super.init(name: name, managedObjectModel: NSManagedObjectModel())
    }
}
