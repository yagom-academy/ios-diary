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
    
    func createDiary() -> Diary? {
        let newDiary = Diary(context: persistentContainer.viewContext)
        newDiary.id = UUID()
        newDiary.createdAt = Date()
        
        return newDiary
    }
    
    func saveDiary(title: String, body: String, diary: Diary?) {
        guard let diary else { return }
        diary.title = title
        diary.body = body
        
        saveContext()
    }
    
    func deleteDiary(_ diary: Diary?) {
        if let diary = diary {
            persistentContainer.viewContext.delete(diary)
            saveContext()
        }
    }
    
    // MARK: - Core Data stack
    lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "Diary")
        container.loadPersistentStores(completionHandler: { (_, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()

    // MARK: - Core Data Saving support
    func saveContext () {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
}
