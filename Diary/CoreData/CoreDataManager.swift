//
//  CoreDataManager.swift
//  Diary
//
//  Created by hoon, karen on 2023/09/09.
//

import CoreData

final class CoreDataManager {
    static let shared = CoreDataManager()
    private init() {}
    
    lazy var persistentContainer: PersistentContainer = {
        let container = PersistentContainer(name: "Diary")
        container.loadPersistentStores(completionHandler: { (_, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        
        return container
    }()
    
    func createDiary() -> Diary {
        let diary = Diary(context: persistentContainer.viewContext)
        diary.date = Date()
        
        return diary
    }
    
    func readDiary() throws -> [Diary] {
        let request = Diary.fetchRequest()
        let diaryList = try persistentContainer.viewContext.fetch(request)
        
        return diaryList
    }
    
    func updateDiary() {
        persistentContainer.saveContext()
    }
    
    func deleteDiary(item: Diary) {
        persistentContainer.viewContext.delete(item)
        persistentContainer.saveContext()
    }
}

class PersistentContainer: NSPersistentContainer {
    func saveContext(backgroundContext: NSManagedObjectContext? = nil) {
        let context = backgroundContext ?? viewContext
        
        guard context.hasChanges else {
            return
        }
        
        do {
            try context.save()
        } catch let error as NSError {
            print("Error: \(error), \(error.userInfo)")
        }
    }
}
