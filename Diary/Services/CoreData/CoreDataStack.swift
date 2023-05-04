//
//  CoreDataStack.swift
//  Diary
//
//  Created by Andrew, brody on 2023/05/01.
//

import CoreData

public enum StoreType {
    case onDisk
    case inMemory
}

open class CoreDataStack {
    static let shared = CoreDataStack(modelName: "Diary")
    private let modelName: String

    private init(modelName: String) {
        self.modelName = modelName
    }

    public lazy var managedContext: NSManagedObjectContext = {
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
    
    func saveContext() -> Bool {
        do {
            try managedContext.save()
            return true
        } catch {
            return false
        }
    }
}

extension CoreDataStack {
    func changeStoreType(type: StoreType) {
        if type == .inMemory {
            let persistentStoreDescription = NSPersistentStoreDescription()
            persistentStoreDescription.type = NSInMemoryStoreType
            
            storeContainer.persistentStoreDescriptions = [persistentStoreDescription]
        }
    }
}
