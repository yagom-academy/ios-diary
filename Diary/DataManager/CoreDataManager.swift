//
//  CoreDataManager.swift
//  Diary
//
//  Created by Max, Hemg on 2023/09/01.
//

import CoreData

class CoreDataManager {
    static let shared = CoreDataManager()
    private init() {}
        
    func fetchDiary() throws -> [Diary] {
        let request: NSFetchRequest<Diary> = Diary.fetchRequest()
        let sortByDate = NSSortDescriptor(key: "createdAt", ascending: false)
        request.sortDescriptors = [sortByDate]
        
        do {
            let diaries = try persistentContainer.viewContext.fetch(request)
            return diaries
        } catch {
            throw CoreDataError.dataNotFound
        }
    }
    
    func createDiary() -> Diary {
        let newDiary = Diary(context: persistentContainer.viewContext)
        newDiary.id = UUID()
        newDiary.createdAt = Date()
        
        return newDiary
    }
    
    func deleteDiary(_ diary: Diary?) throws {
        guard let diary = diary else {
            throw CoreDataError.deleteFailure
        }
        persistentContainer.viewContext.delete(diary)
        try saveContext()
    }
    
    lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "Diary")
        container.loadPersistentStores(completionHandler: { (_, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()

    func saveContext () throws {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                throw CoreDataError.saveFailure
            }
        }
    }
}
