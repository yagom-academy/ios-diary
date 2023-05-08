//
//  CoreDataStack.swift
//  Diary
//
//  Created by Andrew, brody on 2023/05/01.
//

import CoreData

enum StoreType {
    case onDisk
    case inMemory
}

final class CoreDataManager {
    static let shared = CoreDataManager(modelName: "Diary")
    let modelName: String
    var name: String = "hi"

    private init(modelName: String) {
        self.modelName = modelName
    }

    lazy var managedContext: NSManagedObjectContext = {
        return self.storeContainer.viewContext
    }()
    
    private lazy var storeContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: modelName)
        container.loadPersistentStores { _, error in
            if let error = error {
                print(error.localizedDescription)
            }
        }

        return container
    }()
}
