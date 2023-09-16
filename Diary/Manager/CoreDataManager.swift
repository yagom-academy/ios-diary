//
//  CoreDataManager.swift
//  Diary
//
//  Created by idinaloq, yetti on 2023/09/04.
//

import UIKit
import CoreData

final class CoreDataManager {
    static let shared: CoreDataManager = CoreDataManager()
    
    lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "Diary")
        container.loadPersistentStores { _, error in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        }
        return container
    }()
    
    var context: NSManagedObjectContext {
        return persistentContainer.viewContext
    }
    
    private init() {}
    
    func create(diary uuid: UUID) {
        let object = Diary(context: context)
        object.setValue(DateFormatter.today, forKey: "createdAt")
        object.setValue(uuid, forKey: "identifier")
        saveContext()
    }
    
    func fetchAllDiaries() -> [Diary] {
        let fetchRequest: NSFetchRequest<Diary> = Diary.fetchRequest()
        var data: [Diary] = []
        data = fetch(fetchRequest)

        return data
    }
    
    func fetchSingleDiary(by uuid: UUID) -> [Diary] {
        let fetchRequest: NSFetchRequest<Diary> = Diary.fetchRequest()
        var data: [Diary] = []
        fetchRequest.predicate = NSPredicate(format: "identifier == %@", uuid.uuidString)
        data = fetch(fetchRequest)
        
        return data
    }
    
    private func fetch(_ request: NSFetchRequest<Diary>) -> [Diary] {
        do {
            let data = try context.fetch(request)
            return data
        } catch {
            print(error.localizedDescription)
        }
        return []
    }

    func delete(diary uuid: UUID) {
        guard let diary = fetchSingleDiary(by: uuid)[safe: 0] else {
            return
        }
        
        persistentContainer.viewContext.delete(diary)
        saveContext()
    }
    
    func saveContext() {
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
