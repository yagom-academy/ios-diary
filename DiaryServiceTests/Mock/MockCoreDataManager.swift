//
//  MockCoreDataManager.swift
//  DiaryServiceTests
//
//  Created by Andrew, brody on 2023/05/08.
//

import Foundation
import CoreData
@testable import Diary

final class MockCoreDataManager: CoreDataManagable {
    
    static let shared = MockCoreDataManager(modelName: "Diary")
    private let modelName: String
    
    private lazy var storeContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: modelName)
        container.loadPersistentStores { _, error in
            if let error = error {
                
            }
        }

        return container
    }()
    
    lazy var managedContext: NSManagedObjectContext = {
        return self.storeContainer.viewContext
    }()
    
    private init(modelName: String) {
        self.modelName = modelName
        
        let persistentStoreDescription = NSPersistentStoreDescription()
        persistentStoreDescription.type = NSInMemoryStoreType
        
        storeContainer.persistentStoreDescriptions = [persistentStoreDescription]
    }
}
