//
//  CoreDataStack.swift
//  Diary
//
//  Created by Andrew, brody on 2023/05/01.
//

import Foundation
import CoreData

enum CoreDataError: Error {
    case fetchError
    case insertError
    case entityNotFound
    case deleteError
    case saveError
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
    
    // 이따 모델이름 변경해서 시험해야함

    private lazy var storeContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: modelName)
        container.loadPersistentStores { storeDescription, error in
            self.handle(error)
        }

        return container
    }()
    
    // true는 성공했다. false는 변경사항이없다. throw 변경사항이있지만 에러가 났다.
    
    private func saveContext() -> Bool {
//        guard self.managedContext.hasChanges else {
//            return false
//        }
        
        do {
            try managedContext.save()
            return true
        } catch {
            return false
        }
    }
    
    private func handle(_ error: Error?, completion: @escaping () -> Void = {}) {
        if let error = error as NSError? {
            let message = "CoreDataStack -> \(#function): Unresolved error: \(error), \(error.userInfo)"
            print(message)
            completion()
        }
    }
}
