//
//  CoreDataManager.swift
//  Diary
//
//  Created by hoon, karen on 2023/09/09.
//

import CoreData

final class CoreDataManager: DataManager<Diary> {
    static let shared = CoreDataManager()
    
    private init() {
        super.init(entity: "Diary")
    }
}

class DataManager<T: NSManagedObject> {
    private let entity: String
    
    init(entity: String) {
        self.entity = entity
    }
    
    lazy var persistentContainer: PersistentContainer = {
        let container = PersistentContainer(name: entity)
        container.loadPersistentStores(completionHandler: { (_, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        
        return container
    }()
    
    func create() -> T {
        let data = T(context: persistentContainer.viewContext)
        
        return data
    }
    
    func read() throws -> [T] {
        let request = NSFetchRequest<T>(entityName: entity)
        let dataList = try persistentContainer.viewContext.fetch(request)

        return dataList
    }
    
    func update() {
        persistentContainer.saveContext()
    }
    
    func delete(item: T) {
        persistentContainer.viewContext.delete(item)
        persistentContainer.saveContext()
    }
}
