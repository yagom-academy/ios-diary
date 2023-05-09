//
//  CoreDataStack.swift
//  Diary
//
//  Created by Andrew, brody on 2023/05/01.
//

import CoreData

final class CoreDataManager {
    static let shared = CoreDataManager(modelName: "Diary")
    private let modelName: String

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
                
            }
        }

        return container
    }()
}
